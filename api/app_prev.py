import pytz
import time
import sys
import sqlite3
import random
import zlib
import base64
import uvicorn
import os
from loguru import logger
from datetime import datetime
from starlette.applications import Starlette
from starlette.requests import Request
from starlette.responses import Response, JSONResponse

logger.remove()
logger.add(sys.stderr, format='API | {time:YYYY-MM-DD HH:mm:ss} | {level} | {message}', level='INFO')

app = Starlette(debug=False)

def database(category):

    ##? SELECT & UPDATE queries
    select_data = (category,)
    select_query = '''SELECT text FROM texts
                        WHERE category = ?
                        AND hasBeenUsed = 0;'''
    
    update_query = '''UPDATE texts SET hasBeenUsed = 1
                    WHERE category = ?
                    AND text = ?
                    AND hasBeenUsed = 0;'''

    ##? Connect to Sqlite3 DB
    try:
        conn = sqlite3.connect('data/texts.db')
        cursor = conn.cursor()
    except sqlite3.OperationalError as oe:
        return True, str(oe)

    ##? Main block
    try:

        ##? There might be cases, though it is very unlikely, where two different users pick the same random text out of N texts at the exact time. 
        ##? In that case, one of them - whichever was the fastest - will get the text due to row locking while the other one will get an error even though
        ##? it is not likely to be an error since there are more texts available. So re-try 5 times again to reduce the chance of it happening again.
        ##? It is an actual error when there are indeed no texts available but that can't happen during the UPDATE since it only gets to that step if
        ##? there were texts available in the first place

        retry = 0
        max_retries = 5
        while True:
            
            ##? Get all texts for a given category that hasn't been used before
            cursor.execute(select_query, select_data)
            records = cursor.fetchall()

            logger.info('Found {} texts'.format(len(records)))

            if records:
                text = random.choice(records)[0]
                update_data = (category, text)
                cursor.execute(update_query, update_data)
                rowcount = cursor.rowcount
                if rowcount < 1:
                    time.sleep(2)
                    retry += 1
                    if retry >= max_retries:
                        return True, 'MAX RETRIES reached'
                else:
                    ##? SUCEEDED
                    conn.commit()
                    return False, text
            else:
                return True, 'No texts available'
                
    except sqlite3.Error as e:
        return True, str(e)

    finally:
        cursor.close()
        conn.close()


@app.route('/api/status', methods=['GET'])
async def status(request):

    try:
        conn = sqlite3.connect('data/texts.db')
        cursor = conn.cursor()

        sql = 'select category, count(*) from texts group by category;'
        cursor.execute(sql)
        records = cursor.fetchall()

        cursor.close()
        conn.close()

        return JSONResponse({'status': records})
        
    except Exception as e:
        return Response('ERROR - {}'.format(str(e)), status_code=400, media_type='text/plain')




@app.route('/api/endpoint', methods=['POST'])
async def api(request):

    # time.sleep(random.randint(4, 8))

    try:
        ##? Get client info
        logger.info('****** STARTING ******')
        logger.info('HOST: {}'.format(request.headers['host']))
        logger.info('USER AGENT: {}'.format(request.headers['user-agent']))
        
        reqBody = await request.json()
        category = reqBody['category'].lower()
        logger.info('CATEGORY: {}'.format(category))
        error, res = database(category)

        if error:
            logger.error(res)
            logger.info('****** COMPLETED WITH ERRORS ******')
            return Response('ERROR - {}'.format(res), status_code=400, media_type='text/plain')
        else:
            logger.info('Successfully got text from DB')
            ##? Get current datetime
            utc_now = pytz.utc.localize(datetime.utcnow())
            cst_now = utc_now.astimezone(pytz.timezone('America/Mexico_City'))
            cst_now_formatted_1 = cst_now.strftime('%d/%m/%Y %H:%M:%S')
            cst_now_formatted_2 = cst_now.strftime('%b. %d, %Y %I:%M %p %Z')

            logger.info('****** SUCCESSFULLY COMPLETED ******')
            return JSONResponse({'text': res, 'formatted_date_1': cst_now_formatted_1, 'formatted_date_2': cst_now_formatted_2})

    except Exception as e:
        logger.error(e)
        logger.info('****** COMPLETED WITH ERRORS ******')
        return Response('ERROR - {}'.format(str(e)), status_code=400, media_type='text/plain')

## Or remove this, and run using 'uvicorn app:app --reload --loop asyncio'
if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))

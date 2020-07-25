import pytz
import time
import sys
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
import firebase_admin
from firebase_admin import credentials, auth, firestore

cred = credentials.Certificate("inspirr-ab176-firebase-adminsdk-2rfdk-808e549f67.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

logger.remove()
logger.add(
    sys.stderr,
    format="API | {time:YYYY-MM-DD HH:mm:ss} | {level} | {message}",
    level="INFO",
)

app = Starlette(debug=False)


def get_text(category):

    try:
        docs_stream = (
            db.collection(u"texts").where(u"category", u"==", category).stream()
        )
        docs_list = list(docs_stream)
        doc = random.choice(docs_list)
        docId = doc.id
        text = doc.to_dict()["text"]
        db.collection(u"texts").document(u"{}".format(docId)).delete()
        return False, text
    except Exception as e:
        True, str(e)


@app.route("/api/endpoint", methods=["POST"])
async def api(request):

    # time.sleep(random.randint(2, 5))

    try:
        ##? Get client info
        logger.info("****** STARTING ******")

        reqBody = await request.json()
        category = reqBody["category"].lower()
        logger.info("CATEGORY: {}".format(category))
        error, res = get_text(category)

        if error:
            logger.error(res)
            logger.info("****** COMPLETED WITH ERRORS ******")
            return Response(
                "ERROR - {}".format(res), status_code=400, media_type="text/plain"
            )
        else:
            logger.info("Successfully got text from DB")
            ##? Get current datetime
            utc_now = pytz.utc.localize(datetime.utcnow())
            cst_now = utc_now.astimezone(pytz.timezone("America/Mexico_City"))
            cst_now_formatted_1 = cst_now.strftime("%d/%m/%Y %H:%M:%S")
            cst_now_formatted_2 = cst_now.strftime("%b. %d, %Y %I:%M %p %Z")

            logger.info("****** SUCCESSFULLY COMPLETED ******")
            return JSONResponse(
                {
                    "text": res,
                    "formatted_date_1": cst_now_formatted_1,
                    "formatted_date_2": cst_now_formatted_2,
                }
            )

    except Exception as e:
        logger.error(e)
        logger.info("****** COMPLETED WITH ERRORS ******")
        return Response(
            "ERROR - {}".format(str(e)), status_code=400, media_type="text/plain"
        )


## Or remove this, and run using 'uvicorn app:app --reload [--loop asyncio]' [Windows only]
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))

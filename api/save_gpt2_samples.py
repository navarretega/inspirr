import sys
from google.cloud import translate_v2 as translate
import sqlite3

def insert_data(category, text):

    try:
        conn = sqlite3.connect('data/texts.db')
        cursor = conn.cursor()
        query = """INSERT INTO texts
                    (category, text, hasBeenUsed) 
                    VALUES 
                    (?, ?, ?);"""
        data = (category, text, 0)
        cursor.execute(query, data)
        conn.commit()
        cursor.close()
    except sqlite3.Error as e:
        raise e
    finally:
        if conn:
            conn.close()

category = 'articulo'
filename = '/home/alex/Downloads/articles-2_A_0_samples.txt'

# export GOOGLE_APPLICATION_CREDENTIALS="/home/alex/Documents/Projects/inspirr/api/inspirr-ab176-4932bdb2b3e2.json"
translate_client = translate.Client()

with open(filename, encoding='utf-8') as f:

    samples = f.read().split('====================')

assert len(samples) == 51 # 101
for i, sample in enumerate(samples):

    if category == 'ensayo':

        cleaned_text = sample.replace('”', '"').replace('’', "'").replace('“', '"').replace('‘', "'")
        text_split = cleaned_text.strip().split('\n')
        text_list = []

        for x in text_split:
            x = ' '.join(x.split()) ## Remove multiple spaces / Replace multiple spaces with just one space
            if x.endswith('.') or x.endswith('"') or x.endswith('!') or x.endswith('?'):
                text_list.append(x)
                text_list.append('\n')
            else:
                text_list.append(x)
                text_list.append(' ')

        # text = ''.join(text_list)

        try:
            for idx, n in enumerate(text_list):
                if n.startswith('"') or n[0].isupper():
                    break
        except IndexError:
            continue

        p = ''.join(text_list[idx:])
        p = p[:2000]
        p = '.'.join(p.split('.')[:-1])
        p = f'{p}.'
        
    else:

        p = sample.strip()
        p = p.replace('<|startoftext|>', '')
        p = p.replace('”', '"').replace('’', "'").replace('“', '"').replace('‘', "'")
        p = '.'.join(p.split('.')[:-1])
        p = f'{p}.'

    print('PROCESSING TEXT {}\n'.format(i + 1))
    print(f'{p}\n')
    save = input('SAVE TO DB? (y/n): ')
    print('*********************************************************************************************************')

    if save == 'q':

        result = translate_client.translate(p, format_='text', target_language='es')
        translated_text = result['translatedText']
        insert_data(category, translated_text)

    elif save == 'a':
        continue
    else:
        print('Wrong option')
        sys.exit()
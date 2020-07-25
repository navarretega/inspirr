import argparse
import firebase_admin
from firebase_admin import credentials, auth, firestore

## Make sure to get the latest certificate (If you re-create the firebase project, you need new credentials)
cred = credentials.Certificate('/home/alex/Documents/Projects/inspirr/api/inspirr-ab176-firebase-adminsdk-2rfdk-808e549f67.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

def countDocuments():
    
    categories = ['articulo', 'cita', 'libro', 'pelicula']
    for category in categories:
        docs_stream = db.collection(u'texts').where(u'category', u'==', category).stream()
        docs_list = list(docs_stream)
        print('{} --- # {} documents'.format(category, len(docs_list)))

def updateFirestore():

    collections = [u'users', u'deviceIds']
    for collection in collections:
        users_ref = db.collection(collection)
        users_docs = users_ref.stream()
        for user_doc in users_docs:
            print(collection, user_doc.id)
            users_fields_ref = db.collection(collection).document(user_doc.id)
            users_fields_ref.update({u'freeTexts': 25})

# def deleteAuthUsers():
#     ## Delete auth users
#     for user in auth.list_users().iterate_all():
#         auth.delete_user(user.uid)
#         print('Successfully deleted user {}'.format(user.uid))

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('--action', required=True, choices=['Count', 'Update'])
    args = parser.parse_args()
    if args.action == 'Count':
        countDocuments()
    elif args.action == 'Update':
        updateFirestore()
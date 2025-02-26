import firebase_admin
from firebase_admin import credentials, messaging
import pymysql


cred = credentials.Certificate("sdk.json")
firebase_admin.initialize_app(cred)

db = pymysql.connect(
    host="127.0.0.1",
    user="root",
    password="",
    database="librarynew"
)
cursor = db.cursor()


cursor.execute("SELECT nid, uid, message FROM notification WHERE is_sent = 0")
notifications = cursor.fetchall()

for nid, uid, message in notifications:
    
    cursor.execute("SELECT token FROM fcm_token WHERE uid = %s", (uid,))
    token_row = cursor.fetchone()

    if token_row:
        fcm_token = token_row[0]
        message = messaging.Message(
            notification=messaging.Notification(
                title="New Notification",
                body=message,
            ),
            token=fcm_token
        )
        try:
            response = messaging.send(message)
            print(f"Notification sent to UID {uid}: {response}")
            cursor.execute("UPDATE notification SET is_sent = 1 WHERE nid = %s", (nid,))
            db.commit()

        except Exception as e:
            print(f"Failed to send notification to UID {uid}: {str(e)}")
cursor.close()
db.close()

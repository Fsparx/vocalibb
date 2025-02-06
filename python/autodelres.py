import pymysql
from datetime import datetime, timedelta

conn = pymysql.connect(
    host="127.0.0.1",
    user="root",
    password="",
    database="librarynew",
)
try:
    with conn.cursor() as cursor:
      
        current_date = datetime.now()

        
        query_reservations = """
        SELECT rid, bid FROM reservation 
        WHERE DATEDIFF(edt,rdt) > 0.1
        """
        cursor.execute(query_reservations)
        reservations = cursor.fetchall()

        for reservation in reservations:
            rid, bid = reservation

           
            delete_query = "DELETE FROM reservation WHERE rid = %s"
            cursor.execute(delete_query, (rid,))

            
            update_query = "UPDATE bookinfo SET available = 'YES' WHERE bid = %s"
            cursor.execute(update_query, (bid,))

       
        conn.commit()
        print(f"Processed {len(reservations)} reservations.")

except Exception as e:
    print(f"Error: {e}")

finally:
    conn.close()

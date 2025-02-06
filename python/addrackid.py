import pymysql
from itertools import cycle

# Database connection
db = pymysql.connect(
    host="127.0.0.1",         # Replace with your database host
    user="root",     # Replace with your database username
    password="", # Replace with your database password
    database="librarynew"  # Replace with your database name
)

cursor = db.cursor()

# List of 132 Rack IDs
rack_ids = [
    "1A", "2B", "2A", "2B", "3A", "3B", "4A", "4B", "5A", "5B",
    "6A", "6B", "7A", "7B", "8A", "8B", "9A", "9B", "10A", "10B",
    "11A", "11B", "12A", "12B", "13A", "13B", "14A", "14B", "15A", "15B",
    "16A", "16B", "17A", "17B", "18A", "18B", "19A", "19B", "20A", "21A",
    "21B", "22A", "22B", "23A", "23B", "24A", "25B", "26A", "26B", "27A",
    "27B", "28A", "28B", "33A", "33B", "35A", "35B", "40A", "40B", "41A",
    "41B", "44A", "99A", "99B", "98A", "48A", "49A", "50A", "51A", "52A",
    "53A", "54A", "55A", "56A", "59A", "58A", "57A", "60A", "61A", "73A",
    "74A", "32A", "62A", "63A", "65A", "64A", "66A", "67A", "69A", "29A",
    "28A", "70A", "71A", "72A", "78A", "79A", "80A", "81A", "82A", "75A",
    "85A", "30A", "31A", "84A", "88A", "89A", "94A", "90A", "91A", "93A",
    "92A", "47A", "103B", "103A", "102B", "102A", "97A", "100B", "100A",
    "34B", "34A", "96A"
]

# Fetch all book IDs ordered by book_id
cursor.execute("SELECT bid FROM bookinfo ORDER BY bid ASC;")
book_ids = [row[0] for row in cursor.fetchall()]

# Cycle through rack IDs to ensure all 132 are used repeatedly
rack_id_cycle = cycle(rack_ids)

# Assign rack IDs to each book
for book_id in book_ids:
    rack_id = next(rack_id_cycle)
    cursor.execute(
        "UPDATE bookinfo SET rackid = %s WHERE bid = %s",
        (rack_id, book_id)
    )

# Commit the updates to the database
db.commit()

print(f"Successfully updated {len(book_ids)} books with rack IDs.")
cursor.close()
db.close()

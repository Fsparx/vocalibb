import requests
import pymysql
from PIL import Image

# Database connection
def connect_to_database():
    return pymysql.connect(
        host="127.0.0.1",
        user="root",
        password="",
        database="librarynew",
        cursorclass=pymysql.cursors.DictCursor  # Return rows as dictionaries
    )

# Function to check image width
def get_image_width(image_url):
    try:
        response = requests.get(image_url, stream=True, timeout=10)
        if response.status_code == 200:
            response.raw.decode_content = True
            with Image.open(response.raw) as img:
                return img.width
        else:
            print(f"Failed to fetch image. Status code: {response.status_code}")
            return None
    except requests.exceptions.RequestException as req_err:
        print(f"Request error fetching image: {req_err}")
        return None
    except Exception as e:
        print(f"Error processing image: {e}")
        return None

# Main script
def main():
    db_connection = connect_to_database()
    cursor = db_connection.cursor()
    
    try:
        # Fetch ISBNs from the database
        cursor.execute("SELECT isbn FROM bookinfo WHERE bid < 100")
        rows = cursor.fetchall()

        if not rows:
            print("No records found.")
            return

        for row in rows:
            isbn = row['isbn']
            image_url = f"https://covers.openlibrary.org/b/isbn/{isbn}-S.jpg"
            width = get_image_width(image_url)
            print(width)
            # Criteria for small white images
            if width and width <= 1:  # Adjust the width threshold as needed
                print(f"Deleting ISBN {isbn} with small image width: {width}")
                cursor.execute("UPDATE bookinfo SET isbn = NULL WHERE isbn = %s", (isbn,))

        db_connection.commit()
        print("Operation completed.")
    
    except Exception as db_err:
        print(f"Database error: {db_err}")
    
    finally:
        cursor.close()
        db_connection.close()

if __name__ == "__main__":
    main()

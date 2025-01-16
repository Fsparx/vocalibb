from flask import Flask, request, jsonify
import spacy

app = Flask(__name__)
nlp = spacy.load("en_core_web_trf")

def extract_action_and_book_name(text):
    doc = nlp(text)
    action_words = []
    book_name = None

    # Extract verbs for action words
    for token in doc:
        if token.pos_ == "VERB":
            action_words.append(token.text)

    # Extract book names (work of art, product, org)
    for ent in doc.ents:
        if ent.label_ in ["WORK_OF_ART", "ORG", "PRODUCT"]:
            book_name = ent.text
            break

    return action_words, book_name

@app.route('/process_text', methods=['POST'])
def process_text():
    print("In procssing")
    data = request.json
    text = data['text']
    action_words, book_name = extract_action_and_book_name(text)
    return jsonify({"action_words": action_words, "book_name": book_name})

if __name__ == '__main__':
    app.run(host="0.0.0.0",port=5000,debug=True)

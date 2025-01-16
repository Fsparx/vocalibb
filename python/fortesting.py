import spacy
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
print("In procssing")
data = "I am looking for the book titled Flora of British India" 
text = data
action_words, book_name = extract_action_and_book_name(text)
print(action_words,book_name)
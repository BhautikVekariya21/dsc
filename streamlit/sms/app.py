import streamlit as st
import pickle
import string
from nltk.corpus import stopwords
import nltk
from nltk.stem.porter import PorterStemmer
import nltk
nltk.download('punkt', quiet=True)
nltk.download('stopwords', quiet=True)


# Initialize stemmer
ps = PorterStemmer()

# Preprocessing function
def transform_text(text):
    text = text.lower()
    text = nltk.word_tokenize(text)

    y = []
    for i in text:
        if i.isalnum():
            y.append(i)

    text = y[:]
    y.clear()

    for i in text:
        if i not in stopwords.words('english') and i not in string.punctuation:
            y.append(i)

    text = y[:]
    y.clear()

    for i in text:
        y.append(ps.stem(i))

    return " ".join(y)

# Load vectorizer and model
cv = pickle.load(open('vectorizer.pkl', 'rb'))
model = pickle.load(open('model.pkl', 'rb'))

# --- Page config ---
st.set_page_config(page_title="Spam Classifier", page_icon="📧", layout="centered")

# --- Main UI ---
st.markdown("<h1 style='text-align: center;'>📩 Email & SMS Spam Classifier</h1>", unsafe_allow_html=True)
st.markdown("<p style='text-align: center; font-size: 18px;'>Detect whether a message is <b>Spam</b> or <b>Not Spam</b> using Machine Learning.</p>", unsafe_allow_html=True)
st.markdown("---")

# Input box
input_sms = st.text_area("✏️ Type or paste your message below:", height=150)

# Predict button
if st.button('🚀 Predict'):
    if input_sms.strip() != "":
        # Preprocess
        transformed_sms = transform_text(input_sms)
        # Vectorize
        vector_input = cv.transform([transformed_sms])
        # Predict
        result = model.predict(vector_input)[0]

        # Display result with brighter colors
        if result == 1:
            st.markdown(
                "<div style='text-align: center; padding: 20px; background-color: #ff4d4d; color: white; border-radius: 10px;'>"
                "<h2>🚨 Spam Detected</h2>"
                "<p>This message is likely spam. Be cautious!</p>"
                "</div>",
                unsafe_allow_html=True
            )
        else:
            st.markdown(
                "<div style='text-align: center; padding: 20px; background-color: #2ecc71; color: white; border-radius: 10px;'>"
                "<h2>✅ Not Spam</h2>"
                "<p>This message seems safe.</p>"
                "</div>",
                unsafe_allow_html=True
            )
    else:
        st.warning("⚠️ Please enter a message before predicting.")

# Footer
st.markdown("---")
st.markdown("<p style='text-align: center; font-size: 14px; color: gray;'>Built with ❤️ using Streamlit & Machine Learning</p>", unsafe_allow_html=True)

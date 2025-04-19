from flask import Flask, request, jsonify
import os
import google.generativeai as genai

app = Flask(__name__)

# Configure Gemini API
GOOGLE_API_KEY = "AIzaSyDD9sV2q9RBE3ysQo8Gm3CFTkwKIsQxVJE"
genai.configure(api_key=GOOGLE_API_KEY)
model = genai.GenerativeModel('gemini-2.0-flash')

@app.route('/generate', methods=['POST'])
def generate_text():
    data = request.get_json()
    prompt = data.get('prompt')
    if not prompt:
        return jsonify({'error': 'Missing prompt'}), 400

    try:
        response = model.generate_content(prompt)
        return jsonify({'response': response.text})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
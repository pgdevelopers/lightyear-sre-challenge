from flask import Flask
from flask import jsonify
import random

app = Flask(__name__)

quotes = [
    'Python is definitely the best language',
    'Why wait until tomorrow? we could do that today!',
    'You definitely got this',
    'That’s too cute!',
    'Better late than never',
    'Shouldn’t be that hard! I’m not gone lie it was kind of hard'
]


@app.route('/api/chadiamond')
def main():
    quote = random.choice(quotes)
    return jsonify(
        quote=quote
    )

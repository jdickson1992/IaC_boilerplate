import socket
import os
from flask import Flask, request

app = Flask(__name__)

@app.route("/home", methods=["GET", "POST"])
def home():
    hostname = socket.gethostname()
    deployment = os.getenv('DEPLOYMENT')
    if request.method == "GET":
        return f"Welcome to the home page, from {hostname}.  [{deployment} Deployment]"
    elif request.method == "POST":
        return f"You made a POST request to the home page, from {hostname}. [{deployment} Deployment]"

@app.route("/about", methods=["GET", "POST"])
def about():
    deployment = os.getenv('DEPLOYMENT')
    if request.method == "GET":
        return f"This is the about page. [{deployment} Deployment]"
    elif request.method == "POST":
        return f"You made a POST request to the about page.  [{deployment} Deployment]"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)

from flask import Flask, render_template, request
import redis

app = Flask(__name__)
r = redis.Redis(host="redis", port=6379, db=0)

@app.route("/", methods=['POST','GET'])
def hello():
    voter_id = request.cookies.get('voter_id')
    vote = None
    if request.method == 'POST':
        vote = request.form['vote']
        r.rpush('votes', vote)
    return "Vote Cast! You voted for: " + str(vote) if vote else "Ready to vote!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)

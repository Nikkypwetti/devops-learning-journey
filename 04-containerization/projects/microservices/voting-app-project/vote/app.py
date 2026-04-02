from flask import Flask, render_template, request
import redis

app = Flask(__name__)
r = redis.Redis(host="redis", port=6379, db=0)

#for html form
# @app.route("/", methods=['POST','GET'])
# def hello():
#     voter_id = request.cookies.get('voter_id')
#     vote = None
#     if request.method == 'POST':
#         vote = request.form['vote']
#         r.rpush('votes', vote)
#     return "Vote Cast! You voted for: " + str(vote) if vote else "Ready to vote!"


@app.route("/api/vote", methods=['POST'])
def vote():
    try:
        data = request.get_json()
        # Next.js sends { "choice": "Docker" }, so we must use 'choice'
        vote_choice = data.get('choice') 
        
        if not vote_choice:
            return "Missing choice in request", 400

        # Push to Redis
        r.rpush('votes', vote_choice)
        return f"Vote recorded for {vote_choice}", 200
        
    except Exception as e:
        print(f"Error: {e}")
        return "Internal Server Error", 500

if __name__ == "__main__":
    # The 'host' must be 0.0.0.0 for Docker Swarm to route traffic
    app.run(host='0.0.0.0', port=80, debug=False)

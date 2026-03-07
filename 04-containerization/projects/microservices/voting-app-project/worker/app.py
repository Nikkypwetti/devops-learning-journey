import redis
import json
import time

r = redis.Redis(host='redis', port=6379, db=0)

while True:
    # 1. Grab vote from queue
    vote_data = r.brpop('votes', timeout=5)
    if vote_data:
        # 2. Logic to update DB (Omitted for brevity)
        print(f"Processing vote: {vote_data}")

        # 3. THE TRIGGER: Send new counts back to Redis for the UI to hear
        # In a real app, you'd pull these counts from Postgres
        new_counts = {"Docker": 10, "Kubernetes": 5} 
        r.publish('results_channel', json.dumps(new_counts))
    
    time.sleep(0.1)
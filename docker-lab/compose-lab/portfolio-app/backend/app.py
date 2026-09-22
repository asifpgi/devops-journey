from flask import Flask, jsonify
import redis
import os

app = Flask(__name__)

redis_host = os.getenv("REDIS_HOST", "redis")
r = redis.Redis(host=redis_host, port=6379, decode_responses=True)

@app.route("/api")
def api():
    count = r.incr("visits")

    return jsonify({
        "message": "Hello from Asif's Docker DevOps Project",
        "visits": count
    })

@app.route("/health")
def health():
    return jsonify({"status": "healthy"})

app.run(host="0.0.0.0", port=5000)

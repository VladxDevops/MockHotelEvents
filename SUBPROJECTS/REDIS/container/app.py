import redis
import os
import time

def main():
    host = os.getenv("REDIS_HOST", "localhost")
    port = int(os.getenv("REDIS_PORT", 6379))
    password = os.getenv("REDIS_PASSWORD")

    print(f"Connecting to Redis at {host}:{port}...")
    try:
        r = redis.Redis(host=host, port=port, password=password, decode_responses=True)
        r.ping()
        print("Connected to Redis successfully!")
        
        while True:
            # heartbeat
            time.sleep(10)
    except Exception as e:
        print(f"Failed to connect to Redis: {e}")

if __name__ == "__main__":
    main()

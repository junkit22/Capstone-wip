from flask import Flask, jsonify
import time
import threading

app = Flask(__name__)
ping_count = 0

def ping_loop():
    global ping_count
    while True:
        ping_count += 1
        print(f"Ping {ping_count}")
        time.sleep(5)

@app.route('/metrics')
def metrics():
    return jsonify({"ping_count": ping_count})

# Start the ping loop in a separate thread
thread = threading.Thread(target=ping_loop)
thread.daemon = True
thread.start()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=31327)


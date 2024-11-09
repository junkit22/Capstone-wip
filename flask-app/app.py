from prometheus_client import start_http_server, Counter
import time

# Create a counter metric
ping_counter = Counter('ping_messages', 'Number of ping messages sent')

def send_ping():
    while True:
        ping_counter.inc()  # Increment the counter
        print("Ping message")
        time.sleep(5)

if __name__ == "__main__":
    # Start the HTTP server on port 31327 for Prometheus metrics
    start_http_server(31327)
    send_ping()

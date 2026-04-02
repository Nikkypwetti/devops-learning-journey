console.log("🚀 BOOTING CUSTOM SERVER WITH WEBSOCKETS...");

const { createServer } = require("http");
const { parse } = require("url");
const next = require("next");
const { Server } = require("socket.io");
const Redis = require("ioredis");

const dev = process.env.NODE_ENV !== "production";
const app = next({ dev });
const handle = app.getRequestHandler();

// Connect to Redis
const redis = new Redis({
  host: "redis",
  port: 6379,
  retryStrategy(times) {
    const delay = Math.min(times * 50, 2000);
    return delay;
  },
});
app.prepare().then(() => {
  const httpServer = createServer((req, res) => {
    const parsedUrl = parse(req.url, true);
    const { pathname } = parsedUrl;

    // 1. IMPORTANT: Exclude socket.io from Next.js router
    if (pathname.startsWith('/socket.io')) {
      return; 
    }

    handle(req, res, parsedUrl);
  });

  // 2. Initialize Socket.io
  const io = new Server(httpServer, {
    path: "/socket.io",
    cors: { origin: "*" },
    transports: ['polling', 'websocket']
  });

  // 3. Redis Subscriber Logic
  redis.subscribe("results_channel", (err) => {
    if (err) console.error("Redis Subscribe Error:", err);
    console.log("Subscribed to results_channel. Listening for votes...");
  });

  redis.on("message", (channel, message) => {
    if (channel === "results_channel") {
      try {
        const data = JSON.parse(message);
        console.log("Broadcasting new results:", data);
        io.emit("updateResults", data);
      } catch (e) {
        console.error("JSON Parse Error:", e);
      }
    }
  });

  // 4. THE CORRECT LISTEN BLOCK
  const PORT = process.env.PORT || 3000;
  // We listen on 0.0.0.0 so the container is accessible from Nginx
  httpServer.listen(PORT, '0.0.0.0', (err) => {
    if (err) throw err;
    console.log(`> Ready on http://0.0.0.0:${PORT}`);
  });
});

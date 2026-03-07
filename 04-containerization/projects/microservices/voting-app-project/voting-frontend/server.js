const { createServer } = require("http");
const { parse } = require("url");
const next = require("next");
const { Server } = require("socket.io");
const Redis = require("ioredis");

const dev = process.env.NODE_ENV !== "production";
const app = next({ dev });
const handle = app.getRequestHandler();

// Connect to the 'redis' service in your Swarm
const redis = new Redis("redis://redis:6379");

app.prepare().then(() => {
  const httpServer = createServer((req, res) => {
    const parsedUrl = parse(req.url, true);
    handle(req, res, parsedUrl);
  });

  // Setup Socket.io for Real-time browser updates
  const io = new Server(httpServer, {
    path: "/socket.io",
    cors: { origin: "*" }
  });

  // Listen for the 'results_channel' from your Python Worker
  redis.subscribe("results_channel", (err, count) => {
    if (err) console.error("Redis Subscribe Error:", err);
    console.log("Subscribed to results_channel. Listening for votes...");
  });

  redis.on("message", (channel, message) => {
    if (channel === "results_channel") {
      const data = JSON.parse(message);
      console.log("Broadcasting new results:", data);
      // SEND TO ALL BROWSERS INSTANTLY
      io.emit("updateResults", data);
    }
  });

  const PORT = process.env.PORT || 3000;
  httpServer.listen(PORT, () => {
    console.log(`> Advanced Frontend Ready on http://localhost:${PORT}`);
  });
});
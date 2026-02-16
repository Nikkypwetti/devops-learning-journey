const express = require('express');
const redis = require('redis');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// Connect to Redis (Docker handles the 'redis' hostname)
const client = redis.createClient({
    url: process.env.REDIS_URL || 'redis://redis:6379'
});

client.on('error', (err) => console.log('Redis Client Error', err));

async function connectRedis() {
    await client.connect();
    console.log("Connected to Redis for Dashboard Data");
}
connectRedis();

// Serve your static CSS and Images
app.use(express.static('public'));

// API for Theme Configuration
app.get('/api/config', (req, res) => {
    res.json({
        theme: process.env.APP_THEME || 'dark'
    });
});

// API for Real-Time Stats
app.get('/api/stats', async (req, res) => {
    try {
        // This is where the 'Real' website magic happens:
        // Every time the dashboard refreshes, it increments a counter in Redis
        const visits = await client.incr('dashboard_visits');
        
        res.json({
            region: process.env.AWS_REGION || 'us-east-1',
            runtime: 'Node.js 20',
            visits: visits,
            status: 'Online'
        });
    } catch (err) {
        res.status(500).json({ error: "Failed to fetch from Redis" });
    }
});

// Serve index.html for the root route
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
    console.log(`Dashboard server running on http://localhost:${port}`);
});
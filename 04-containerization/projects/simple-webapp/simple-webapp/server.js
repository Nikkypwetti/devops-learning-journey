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
    const timestamp = new Date().toLocaleTimeString();
    // Save a log entry in Redis
    await client.lPush('site_logs', `[${timestamp}] New visitor detected`);
    await client.lTrim('site_logs', 0, 9); // Only keep the last 10 logs

    const visits = await client.incr('dashboard_visits');
    res.json({
        region: process.env.AWS_REGION || 'us-east-1',
        visits: visits
    });
});

app.get('/api/logs', async (req, res) => {
    const logs = await client.lRange('site_logs', 0, -1);
    res.json(logs);
});

// Serve index.html for the root route
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(port, () => {
    console.log(`Dashboard server running on http://localhost:${port}`);
});
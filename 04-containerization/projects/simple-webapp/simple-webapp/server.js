const express = require('express');
const redis = require('redis');
const path = require('path');
const os = require('os'); 


const app = express();
const port = process.env.PORT || 3000;

app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// Connect to Redis (Docker handles the 'redis' hostname)
const client = redis.createClient({
    url: process.env.REDIS_URL || 'redis://localhost:6379'
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


app.get('/api/stats', async (req, res) => {
    // Calculate Memory Usage
    const freeMem = os.freemem();
    const totalMem = os.totalmem();
    const memUsage = Math.round(((totalMem - freeMem) / totalMem) * 100);

    // Calculate CPU Load (Average over the last minute)
    const cpuLoad = Math.round(os.loadavg()[0] * 100);

    const timestamp = new Date().toLocaleTimeString();
    await client.lPush('site_logs', `[${timestamp}] System Metrics Sampled: CPU ${cpuLoad}% | MEM ${memUsage}%`);
    await client.lTrim('site_logs', 0, 9);

    const visits = await client.incr('dashboard_visits');
    
    res.json({
        region: process.env.AWS_REGION || 'us-east-1',
        runtime: 'Node.js 20',
        visits: visits,
        cpu: cpuLoad,      // New Data
        memory: memUsage,  // New Data
        status: 'Online'
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
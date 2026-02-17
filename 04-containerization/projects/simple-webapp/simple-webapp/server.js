const express = require('express');
const redis = require('redis');
const path = require('path');
const os = require('os');

const app = express();
const port = process.env.PORT || 3000;

// 1. Health Check (Top priority for AWS ALB)
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// 2. Redis Configuration
const client = redis.createClient({
    url: process.env.REDIS_URL || 'redis://localhost:6379'
});

client.on('error', (err) => console.error('Redis Client Error:', err));

// 3. Connect to Redis and Log Deployment
async function connectRedis() {
    try {
        await client.connect();
        console.log("Successfully connected to Redis at localhost:6379");

        const deployTime = new Date().toLocaleString();
        const deployVersion = process.env.DEPLOY_TIMESTAMP || 'v2.1';
        
        await client.lPush('deploy_history', `Date: ${deployTime} | Version: ${deployVersion}`);
        await client.lTrim('deploy_history', 0, 4); 
    } catch (err) {
        console.error("Failed to connect to Redis. Metrics will be unavailable.", err);
    }
}
connectRedis();

// 4. Static Files (Serves your CSS and public assets)
// If your index.html is in the 'public' folder, use this:
app.use(express.static(path.join(__dirname, 'public')));

// 5. API Endpoints
app.get('/api/config', (req, res) => {
    res.json({ theme: process.env.APP_THEME || 'dark' });
});

app.get('/api/history', async (req, res) => {
    try {
        const history = await client.lRange('deploy_history', 0, -1);
        res.json(history || []);
    } catch (err) {
        res.status(500).json({ error: "History unavailable" });
    }
});

app.get('/api/logs', async (req, res) => {
    try {
        const logs = await client.lRange('site_logs', 0, -1);
        res.json(logs || []);
    } catch (err) {
        res.status(500).json({ error: "Logs unavailable" });
    }
});

app.get('/api/stats', async (req, res) => {
    try {
        const freeMem = os.freemem();
        const totalMem = os.totalmem();
        const memUsage = Math.round(((totalMem - freeMem) / totalMem) * 100);
        const cpuLoad = Math.round(os.loadavg()[0] * 100);

        const timestamp = new Date().toLocaleTimeString();
        await client.lPush('site_logs', `[${timestamp}] CPU: ${cpuLoad}% | MEM: ${memUsage}%`);
        await client.lTrim('site_logs', 0, 9);

        const visits = await client.incr('dashboard_visits');
        
        res.json({
            region: process.env.AWS_REGION || 'us-east-1',
            runtime: 'Node.js 20',
            visits: visits,
            cpu: cpuLoad,
            memory: memUsage,
            status: 'Online'
        });
    } catch (err) {
        res.status(500).json({ error: "Stats unavailable" });
    }
});

// 6. Serve the Frontend
app.get('/', (req, res) => {
    // This sends your index.html to the browser
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.listen(port, () => {
    console.log(`Server is live! Access it at http://localhost:${port}`);
});
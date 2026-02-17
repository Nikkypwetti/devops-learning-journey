const express = require('express');
const redis = require('redis');
const path = require('path');
const os = require('os');

const app = express();
const port = process.env.PORT || 3000;

// 1. IMMEDIATE HEALTH CHECK
app.get('/health', (req, res) => res.status(200).send('OK'));
app.get('/api/config', (req, res) => res.json({ theme: process.env.APP_THEME || 'dark' }));

// 2. REDIS SETUP
const client = redis.createClient({
    url: process.env.REDIS_URL || 'redis://localhost:6379'
});

client.on('error', (err) => console.error('Redis Error:', err));

async function initApp() {
    try {
        await client.connect();
        console.log("Connected to Redis");
        
        const deployTime = new Date().toLocaleString();
        await client.lPush('deploy_history', `Deploy: ${deployTime}`);
        await client.lTrim('deploy_history', 0, 4);
    } catch (err) {
        console.error("Running without Redis storage.");
    }
}
initApp();

// 3. MIDDLEWARE & ROUTES
app.use(express.static(path.join(__dirname, 'public')));

app.get('/api/stats', async (req, res) => {
    try {
        const visits = await client.incr('dashboard_visits').catch(() => 0);
        res.json({
            region: process.env.AWS_REGION || 'us-east-1',
            visits: visits,
            cpu: Math.round(os.loadavg()[0] * 100),
            memory: Math.round(((os.totalmem() - os.freemem()) / os.totalmem()) * 100)
        });
    } catch (e) { res.status(500).json({ error: 'Stats error' }); }
});

app.get('/api/history', async (req, res) => {
    const history = await client.lRange('deploy_history', 0, -1).catch(() => []);
    res.json(history);
});

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// 4. START SERVER
app.listen(port, () => console.log(`Server live on ${port}`));

// 5. GRACEFUL SHUTDOWN (Important for ECS)
process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});
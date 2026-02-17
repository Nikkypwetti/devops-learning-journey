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
    console.log("Connected to Redis");

    // LOG THE DEPLOYMENT
    const deployTime = new Date().toLocaleString();
    const deployVersion = process.env.DEPLOY_TIMESTAMP || 'v2.0';
    // Store the last 5 deployments in a Redis List
    await client.lPush('deploy_history', `Date: ${deployTime} | Version: ${deployVersion}`);
    await client.lTrim('deploy_history', 0, 4); 
}
connectRedis();

// Add an API endpoint to fetch this history
app.get('/api/history', async (req, res) => {
    const history = await client.lRange('deploy_history', 0, -1);
    res.json(history);
});

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

function updateHistory() {
    fetch('/api/history')
        .then(res => res.json())
        .then(data => {
            const body = document.getElementById('history-body');
            body.innerHTML = data.map(event => `<tr><td>${event}</td></tr>`).join('');
        });
}

// Call this once on load
window.onload = () => {
    updateDashboard();
    updateHistory();
    setInterval(updateDashboard, 10000);
    setInterval(updateHistory, 60000); // Refresh history every minute
};
// Add this to server.js
app.get('/api/history', async (req, res) => {
    try {
        const history = await client.lRange('deploy_history', 0, -1);
        res.json(history);
    } catch (err) {
        res.status(500).json({ error: "Could not fetch history" });
    }
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
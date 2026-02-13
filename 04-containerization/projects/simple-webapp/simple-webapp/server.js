const express = require('express');
const redis = require('redis');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/api/config', (req, res) => {
    res.json({ 
        theme: process.env.APP_THEME || 'dark' 
    });
});

// Connect to Redis (using the service name defined in docker-compose)
const client = redis.createClient({
    url: 'redis://redis:6379'
});

client.on('error', (err) => console.log('Redis Client Error', err));
client.connect();

app.use(express.static(path.join(__dirname, 'public')));

app.get('/visit', async (req, res) => {
    const visits = await client.incr('visits');
    res.send({ total_visits: visits });
});

app.get('/health', (req, res) => res.status(200).send('Healthy'));

app.listen(PORT, () => console.log('Pro Dashboard running on port ' + PORT));
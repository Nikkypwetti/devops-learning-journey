const express = require('express');
const morgan = require('morgan');
const os = require('os');

const app = express();
const port = process.env.PORT || 3000;

app.use(morgan('combined'));

app.get('/', (req, res) => {
    res.json({
        message: 'Hello from Dockerized Node.js!',
        container: os.hostname(),
        node_version: process.version,
        environment: process.env.NODE_ENV || 'development'
    });
});

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy' });
});

app.listen(port, () => {
    console.log(`🚀 Server running on port ${port}`);
});
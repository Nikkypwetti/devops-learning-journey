// app.js
const express = require('express');
const app = express();

// Load environment variables
const INSTANCE_ID = process.env.INSTANCE_ID || 'unknown';
const AVAILABILITY_ZONE = process.env.AVAILABILITY_ZONE || 'unknown';
const APP_PORT = process.env.APP_PORT || 3000;

// Request Counter (per instance)
let requestCount = 0;

// Routes
app.get('/', (req, res) => {
    requestCount++;

    res.send(`
        <h1>AWS Load Balancer Project</h1>
        <p><strong>Instance ID:</strong> ${INSTANCE_ID}</p>
        <p><strong>Availability Zone:</strong> ${AVAILABILITY_ZONE}</p>
        <p><strong>Requests Served By This Instance:</strong> ${requestCount}</p>
        <p><strong>Time:</strong> ${new Date().toISOString()}</p>
    `);
});

// Health Check Route (for ALB)
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// Graceful Shutdown
process.on('SIGTERM', () => {
    console.log('SIGTERM received. Shutting down gracefully...');
    process.exit(0);
});

// Start Server
app.listen(APP_PORT, () => {
    console.log(`App running on port ${APP_PORT}`);
    console.log(`Instance: ${INSTANCE_ID} | AZ: ${AVAILABILITY_ZONE}`);
});

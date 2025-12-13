const express = require('express');
const app = express();
const http = require('http');

// Fetch metadata directly from IMDS
const getMetadata = (path) => {
    return new Promise((resolve) => {
        http.get(`http://169.254.169.254/latest/meta-data/${path}`, (resp) => {
            let data = '';
            resp.on('data', chunk => data += chunk);
            resp.on('end', () => resolve(data));
        }).on('error', () => resolve('unknown'));
    });
};

// Initialize with values
let INSTANCE_ID = 'unknown';
let AVAILABILITY_ZONE = 'unknown';
const APP_PORT = process.env.APP_PORT || 3000;

// Fetch metadata on startup
(async () => {
    INSTANCE_ID = await getMetadata('instance-id');
    AVAILABILITY_ZONE = await getMetadata('placement/availability-zone');
    console.log(`Instance: ${INSTANCE_ID} | AZ: ${AVAILABILITY_ZONE}`);
})();

let requestCount = 0;

app.get('/', (req, res) => {
    requestCount++;
    res.send(`
        <h1>AWS Load Balancer Project - SUCCESS</h1>
        <p><strong>Instance ID:</strong> ${INSTANCE_ID}</p>
        <p><strong>Availability Zone:</strong> ${AVAILABILITY_ZONE}</p>
        <p><strong>Request Count:</strong> ${requestCount}</p>
        <p><strong>Time:</strong> ${new Date().toISOString()}</p>
    `);
});

app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

app.listen(APP_PORT, '0.0.0.0', () => {
    console.log(`Application successfully started on port ${APP_PORT}`);
});



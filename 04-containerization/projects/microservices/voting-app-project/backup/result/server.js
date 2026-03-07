const express = require('express');
const app = express();
app.get('/', (req, res) => { res.send('Result App is Running!'); });
app.listen(80, () => { console.log('Listening on port 80'); });

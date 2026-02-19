const express = require('express');
const mongoose = require('mongoose');
const app = express();

// Use the environment variable we set in docker-compose.yml
const mongoUrl = process.env.DATABASE_URL || 'mongodb://localhost:27017/vidly';

mongoose.connect(mongoUrl)
  .then(() => console.log('✅ Connected to MongoDB...'))
  .catch(err => console.error('❌ Could not connect to MongoDB...', err));

app.get('/', (req, res) => {
  res.send('Nikky\'s API is Live and Connected!');
});

app.listen(3001, () => console.log('🚀 Listening on port 3001...'));
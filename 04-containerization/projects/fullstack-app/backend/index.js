const { Pool } = require('pg');
const express = require('express');
const app = express();

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Simple endpoint to get milestones
app.get('/', async (req, res) => {
  try {
    const dbRes = await pool.query('SELECT * FROM milestones ORDER BY day_number ASC');
    res.json(dbRes.rows); // Return as JSON
  } catch (err) {
    console.error(err);
    res.status(500).send('Database connection error');
  }
});

app.listen(5000, () => console.log('Backend running on 5000'));
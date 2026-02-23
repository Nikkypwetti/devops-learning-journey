const express = require('express');
const { Pool } = require('pg');
const cors = require('cors'); 
const app = express();

app.use(cors()); 

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.get('/', async (req, res) => {
  try {
    const dbRes = await pool.query('SELECT * FROM milestones ORDER BY day_number ASC');
    res.json(dbRes.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Database connection error');
  }
});

app.listen(5000, () => console.log('Backend running on 5000'));
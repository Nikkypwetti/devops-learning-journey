const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();

app.use(cors());

const mongoUrl = process.env.DATABASE_URL || 'mongodb://localhost:27017/vidly';
mongoose.connect(mongoUrl);

// Define a simple Schema
const VisitSchema = new mongoose.Schema({ count: Number });
const Visit = mongoose.model('Visit', VisitSchema);

app.get('/status', async (req, res) => {
    // Increment visit count in DB
    let visit = await Visit.findOne();
    if (!visit) visit = new Visit({ count: 0 });
    visit.count++;
    await visit.save();

    res.json({
        message: "Nikky's Stack is Healthy!",
        db_count: visit.count,
        timestamp: new Date()
    });
});

app.listen(3001, () => console.log('🚀 API running on 3001'));
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();

app.use(cors());

const mongoUrl = process.env.DATABASE_URL || 'mongodb://localhost:27017/vidly';
mongoose.connect(mongoUrl)
    .then(() => console.log("✅ Connected to MongoDB..."))
    .catch(err => console.error("❌ Connection error:", err));

// Define a simple Schema
const VisitSchema = new mongoose.Schema({ count: Number });
const Visit = mongoose.model('Visit', VisitSchema);

// Change /status to ONLY read the data
app.get('/status', async (req, res) => {
    let visit = await Visit.findOne();
    if (!visit) visit = new Visit({ count: 0 });
    
    res.json({
        message: "Nikky's Stack is Healthy!",
        db_count: visit.count,
        timestamp: new Date()
    });
});

// Create a new route just for "logging a visit"
app.post('/visit', async (req, res) => {
    let visit = await Visit.findOne();
    if (!visit) visit = new Visit({ count: 0 });
    visit.count++;
    await visit.save();
    res.json({ count: visit.count });
});

app.post('/reset', async (req, res) => {
    await Visit.deleteMany({});
    console.log("🗑️ Database has been reset");
    res.json({ message: "Counter Reset Successfully!" });
});

console.log("Nikky DevOps Pro");

app.listen(3001, () => console.log('🚀 API running on 3001'));
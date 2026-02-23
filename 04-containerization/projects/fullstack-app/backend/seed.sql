-- Create a simple table for your DevOps Journey
CREATE TABLE IF NOT EXISTS milestones (
    id SERIAL PRIMARY KEY,
    day_number INTEGER NOT NULL,
    topic TEXT NOT NULL,
    status TEXT DEFAULT 'Completed'
);

-- Insert some initial data
INSERT INTO milestones (day_number, topic) VALUES 
(8, 'Docker Fundamentals'),
(10, 'Docker Networks & Volumes'),
(13, 'Docker Compose Orchestration'),
(14, 'Full-Stack Implementation')
ON CONFLICT DO NOTHING;
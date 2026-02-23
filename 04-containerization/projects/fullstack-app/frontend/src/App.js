import React, { useEffect, useState } from 'react';

function App() {
  const [milestones, setMilestones] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch('/api/')
      .then(res => res.json())
      .then(data => {
        setMilestones(data);
        setLoading(false);
      })
      .catch(err => {
        console.error("Fetch error:", err);
        setLoading(false);
      });
  }, []);

  return (
    <div style={{ padding: '40px', fontFamily: 'Arial, sans-serif', backgroundColor: '#f4f7f6', minHeight: '100vh' }}>
      <h1 style={{ color: '#2c3e50' }}>Nikky's Day 14: DevOps Milestone Tracker</h1>
      
      {loading ? (
        <p>Loading your progress...</p>
      ) : (
        <table style={{ width: '100%', borderCollapse: 'collapse', backgroundColor: 'white', boxShadow: '0 2px 10px rgba(0,0,0,0.1)' }}>
          <thead>
            <tr style={{ backgroundColor: '#34495e', color: 'white', textAlign: 'left' }}>
              <th style={{ padding: '15px' }}>Day</th>
              <th style={{ padding: '15px' }}>Topic</th>
              <th style={{ padding: '15px' }}>Status</th>
            </tr>
          </thead>
          <tbody>
            {milestones.map(m => (
              <tr key={m.id} style={{ borderBottom: '1px solid #ddd' }}>
                <td style={{ padding: '15px' }}>Day {m.day_number}</td>
                <td style={{ padding: '15px' }}>{m.topic}</td>
                <td style={{ padding: '15px', color: '#27ae60', fontWeight: 'bold' }}>{m.status}</td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default App;
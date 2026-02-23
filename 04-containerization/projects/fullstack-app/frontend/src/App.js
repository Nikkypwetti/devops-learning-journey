import React, { useEffect, useState } from 'react';

const App = () => {
  const [milestones, setMilestones] = useState([]);
  const [loading, setLoading] = useState(true);
  const [dbStatus, setDbStatus] = useState('Checking...');

useEffect(() => {
    // Check if we are running the 'Production' version
    // If we are served by Nginx, we use the relative path
    const isDevServer = window.location.hostname === 'localhost' && window.location.port === '3000' && process.env.NODE_ENV === 'development';
    
    const apiUrl = isDevServer ? 'http://localhost:5000' : '/api/';

    fetch(apiUrl)
      .then(res => {
        if (!res.ok) throw new Error('API Error');
        setDbStatus('Connected');
        return res.json();
      })
      .then(data => {
        setMilestones(data);
        setLoading(false);
      })
      .catch(err => {
        setDbStatus('Disconnected');
        setLoading(false);
      });
  }, []);

  return (
    <div className="min-h-screen bg-gray-50 text-gray-900 font-sans">
      {/* Header */}
      <header className="bg-white border-b border-gray-200 py-6 px-8 shadow-sm">
        <div className="max-w-6xl mx-auto flex justify-between items-center">
          <div>
            <h1 className="text-2xl font-bold text-indigo-600">Nikky's DevOps Lab</h1>
            <p className="text-sm text-gray-500">Day 14: Enterprise Containerization</p>
          </div>
          <div className="flex items-center space-x-2 bg-gray-100 px-4 py-2 rounded-full">
            <div className={`w-3 h-3 rounded-full ${dbStatus === 'Connected' ? 'bg-green-500' : 'bg-red-500'}`}></div>
            <span className="text-xs font-medium text-gray-600 uppercase tracking-wider">DB Status: {dbStatus}</span>
          </div>
        </div>
      </header>

      <main className="max-w-6xl mx-auto py-12 px-8">
        {/* Project Stats Section */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
          <StatCard title="Architecture" value="3-Tier Stack" icon="🏗️" />
          <StatCard title="Automation" value="GitHub Actions" icon="🚀" />
          <StatCard title="Registry" value="Docker Hub" icon="📦" />
        </div>

        {/* Milestone Table */}
        <div className="bg-white rounded-xl shadow-md overflow-hidden border border-gray-100">
          <div className="px-6 py-4 border-b border-gray-100 bg-gray-50">
            <h2 className="font-semibold text-gray-700">DevOps Learning Journey Milestones</h2>
          </div>
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead>
                <tr className="text-xs uppercase text-gray-400 font-semibold border-b border-gray-100">
                  <th className="px-6 py-4">Timeline</th>
                  <th className="px-6 py-4">Technology Focus</th>
                  <th className="px-6 py-4">Verification</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-50">
                {loading ? (
                  <tr><td colSpan="3" className="px-6 py-10 text-center text-gray-400">Loading pipeline data...</td></tr>
                ) : (
                  milestones.map((m) => (
                    <tr key={m.id} className="hover:bg-indigo-50 transition-colors">
                      <td className="px-6 py-4 font-medium text-indigo-600">Day {m.day_number}</td>
                      <td className="px-6 py-4 text-gray-600 font-semibold">{m.topic}</td>
                      <td className="px-6 py-4">
                        <span className="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-bold">
                          {m.status}
                        </span>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>
      </main>

      <footer className="text-center py-10 text-gray-400 text-xs">
        <p>© 2026 Nikky DevOps Portfolio • Built with Docker, Node, & React</p>
      </footer>
    </div>
  );
};

// Helper component for the dashboard cards
const StatCard = ({ title, value, icon }) => (
  <div className="bg-white p-6 rounded-xl shadow-sm border border-gray-100 flex items-center space-x-4">
    <div className="text-3xl bg-indigo-50 p-3 rounded-lg">{icon}</div>
    <div>
      <p className="text-xs text-gray-400 uppercase font-bold tracking-widest">{title}</p>
      <p className="text-lg font-bold text-gray-800">{value}</p>
    </div>
  </div>
);

export default App;
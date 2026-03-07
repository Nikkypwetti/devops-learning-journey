"use client";
import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { io } from "socket.io-client";

// The 'result' service name in your Swarm
const SOCKET_URL = "http://localhost/result"; 

export default function ResultsPage() {
  const [results, setResults] = useState({ Docker: 0, Kubernetes: 0 });

  useEffect(() => {
    // 1. Initialize WebSocket connection
    const socket = io(SOCKET_URL, { path: "/socket.io" });

    // 2. Listen for 'update' events from the backend
    socket.on("updateResults", (data) => {
      console.log("New results received:", data);
      setResults(data);
    });

    return () => {
      socket.disconnect();
    };
  }, []);

  const total = results.Docker + results.Kubernetes || 1;

  return (
    <div className="min-h-screen bg-[#0f172a] text-white flex flex-col items-center justify-center p-6">
      <h1 className="text-4xl font-bold mb-12 bg-gradient-to-r from-green-400 to-blue-500 bg-clip-text text-transparent">
        Live Results
      </h1>

      <div className="w-full max-w-2xl space-y-10">
        {Object.entries(results).map(([name, count]) => (
          <div key={name} className="space-y-2">
            <div className="flex justify-between text-lg font-medium">
              <span>{name}</span>
              <span>{Math.round((count / total) * 100)}% ({count} votes)</span>
            </div>
            <div className="h-6 w-full bg-slate-800 rounded-full overflow-hidden border border-slate-700">
              <motion.div
                initial={{ width: 0 }}
                animate={{ width: `${(count / total) * 100}%` }}
                transition={{ type: "spring", stiffness: 50 }}
                className={`h-full ${name === 'Docker' ? 'bg-blue-500' : 'bg-cyan-400'}`}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
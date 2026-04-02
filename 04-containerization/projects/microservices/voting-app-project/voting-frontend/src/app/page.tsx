"use client";
import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { io } from "socket.io-client";

// This tells Socket.io to use the current domain and hit the /socket.io path Nginx expects
const socket = io({
  path: "/socket.io/"
}); 

export default function VotingPage() {
  const [votes, setVotes] = useState({ Docker: 0, Kubernetes: 0 });
  const [voted, setVoted] = useState(false);

useEffect(() => {
  socket.on("updateResults", (data) => {
    setVotes(data);
  });

  // Clean up the listener on unmount to prevent memory leaks
  return () => {
    socket.off("updateResults");
  };
}, []);

const handleVote = async (choice: string) => {
  try {
    const response = await fetch("/api/vote", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ choice: choice }), 
    });
    
    if (response.ok) {
      setVoted(true);
    } else {
      console.error("❌ Vote failed at the server level");
    }
  } catch (err) {
    console.error("❌ Network Error: Unable to connect to Nginx/API");
  }
};

  return (
    <div className="min-h-screen bg-slate-900 text-white flex flex-col items-center justify-center p-4">
      <motion.h1 
        initial={{ y: -20 }} animate={{ y: 0 }}
        className="text-4xl font-bold mb-8 text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-blue-500"
      >
        Real-Time DevOps Poll
      </motion.h1>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6 w-full max-w-4xl">
        {['Docker', 'Kubernetes'].map((option) => (
          <button
            key={option}
            onClick={() => handleVote(option)}
            disabled={voted}
            className={`p-8 rounded-2xl border-2 transition-all ${
              voted ? 'border-slate-700 bg-slate-800' : 'border-cyan-500 hover:bg-cyan-500/10'
            }`}
          >
            <h2 className="text-2xl font-semibold mb-4">{option}</h2>
            {/* Animated Progress Bar */}
            <div className="w-full bg-slate-700 h-4 rounded-full overflow-hidden">
              <motion.div 
                initial={{ width: 0 }}
                animate={{ width: `${(option === 'Docker' ? votes.Docker : votes.Kubernetes)}%` }}
                className="h-full bg-cyan-400"
              />
            </div>
          </button>
        ))}
      </div>
      
      {voted && <p className="mt-6 text-cyan-400 animate-pulse">Vote recorded! Watching live results...</p>}
    </div>
  );
}
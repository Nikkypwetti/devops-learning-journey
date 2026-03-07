"use client";
import { useState, useEffect } from "react";
import { motion } from "framer-motion";
import { io } from "socket.io-client";

// Connect to the 'Result' service we built in Swarm
const socket = io("http://localhost/result"); 

export default function VotingPage() {
  const [votes, setVotes] = useState({ optionA: 0, optionB: 0 });
  const [voted, setVoted] = useState(false);

useEffect(() => {
  socket.on("updateResults", (data) => {
    setVotes(data);
  });

  // This is the proper cleanup function (The "Destructor")
  return () => {
    socket.off("updateResults");
  };
}, []);

  const handleVote = async (choice: string) => {
    // Send vote to our Nginx gateway
    await fetch("/api/vote", {
      method: "POST",
      body: JSON.stringify({ choice }),
    });
    setVoted(true);
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
                animate={{ width: `${(option === 'Docker' ? votes.optionA : votes.optionB)}%` }}
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
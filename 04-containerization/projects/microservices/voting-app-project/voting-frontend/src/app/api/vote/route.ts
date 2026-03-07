import { NextResponse } from 'next/server';
import Redis from 'ioredis';

// Swarm service name is 'redis'
const redis = new Redis('redis://redis:6379');

export async function POST(req: Request) {
  try {
    const { choice } = await req.json();
    // Add to Redis list for the Worker service to process
    await redis.lpush('votes', JSON.stringify({ choice, host: 'nextjs-ui' }));
    return NextResponse.json({ message: "Vote Cast!" });
  } catch (error) {
    return NextResponse.json({ error: "Redis Connection Failed" }, { status: 500 });
  }
}
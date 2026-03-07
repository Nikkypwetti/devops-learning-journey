/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'standalone', // Essential for the Dockerfile to work
};

export default nextConfig;

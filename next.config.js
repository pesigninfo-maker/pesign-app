/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  
  // Image Optimization Configuration
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'res.cloudinary.com', // For design proofs & product assets
        pathname: '**',
      },
      {
        protocol: 'https',
        hostname: 'img.clerk.com', // For secure vendor/customer profile avatars
        pathname: '**',
      }
    ],
  },

  // Advanced Server Configuration
  experimental: {
    serverActions: {
      // Allow larger file limits for graphic design asset uploads
      bodySizeLimit: '15mb', 
    },
  },

  // Security Headers
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'X-Frame-Options',
            value: 'DENY', // Prevents clickjacking attacks on our dashboards
          },
          {
            key: 'X-XSS-Protection',
            value: '1; mode=block',
          },
        ],
      },
    ];
  },
};

module.exports = nextConfig;

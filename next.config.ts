import type { NextConfig } from "next";
const basePath = process.env.NEXT_BASE_PATH || "";
const nextConfig: NextConfig = {
  basePath,
  assetPrefix: basePath ? `${basePath}/` : undefined,
  /* config options here */
};

export default nextConfig;

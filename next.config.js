/** @type {import('next').NextConfig} */
const nextConfig = {
  // experimental: {
  //   ppr: "incremental",
  // },
  output: "standalone", // 支持 docker 部署
};

module.exports = nextConfig;

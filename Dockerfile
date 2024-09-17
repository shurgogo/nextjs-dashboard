# 使用官方Node.js镜像作为基础镜像
# FROM node AS base



# # 安装/下载 依赖
# FROM base AS deps
# # 设置工作目录
# WORKDIR /app
# # 复制 package.json 和 package-lock.json 到容器中
# COPY package*.json ./
# # 安装依赖（这一步会被 Docker 缓存）
# RUN npm i --registry https://registry.npmmirror.com
# ## 下载的依赖位于 deps 层的/app/node_modules



# FROM base AS builder
# WORKDIR /app
# # 下载的依赖从 deps 层的/app/node_modules 到 builder 层的 /app/node_modules
# COPY --from=deps /app/node_modules ./node_modules
# # 复制项目代码到 builder 层的 /app
# COPY . .
# RUN npm run build



# FROM base AS runner
# WORKDIR /app

# ENV NODE_ENV=production

# RUN addgroup --system --gid 1001 nodejs
# RUN adduser --system --uid 1001 nextjs
# # builder 层 /app/public 放的是项目代码中自带的 public
# COPY --from=builder /app/public ./public

# RUN mkdir .next
# RUN chown nextjs:nodejs .next
# # builder 层的 /app/.next 是 `npm run build` 生成的内容
# COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
# COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# USER nextjs

# # 本代码暴露的端口号
# EXPOSE 3000

# # ENV PORT=3000
# # ENV HOSTNAME="0.0.0.0"

# # 构建项目或启动应用
# CMD ["node", "server.js"]

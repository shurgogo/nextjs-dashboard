# 使用官方Node.js镜像作为基础镜像
FROM node

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json 到容器中
COPY package*.json ./

# 安装依赖（这一步会被 Docker 缓存）
RUN node -v
RUN npm config set registry https://registry.npmmirror.com
RUN npm install

# 复制项目文件到容器中
COPY . .

# 构建项目或启动应用
CMD ["tail", "-f", "/dev/null"]
#CMD ["npm", "run", "build"]

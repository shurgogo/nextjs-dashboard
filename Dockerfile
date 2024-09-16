FROM node

RUN node -v
RUN npm config set registry https://registry.npmmirror.com
RUN npm install
RUN npm run build

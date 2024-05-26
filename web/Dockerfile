FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN rm -rf node_modules/.vite/
RUN npm run build

EXPOSE 4173

CMD ["npm", "run", "serve"]

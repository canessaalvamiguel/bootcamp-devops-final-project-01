FROM node:18

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force

COPY . .

RUN npm run build

EXPOSE 4173

CMD ["npm", "run", "serve"]

FROM node:16-alpine as builder

# указываем рабочую директорию и сохраняем новый слой
WORKDIR /var/www/app

# Копируем в предыдущий слой файлы из текущей директории и сохраняем новый
COPY package*.json .



# На предыдущем слое вызываем команду npm install и сохраняем новый
RUN npm install

COPY . .
RUN npm run build


FROM node:16-alpine as production

WORKDIR /var/www/app

COPY --from=builder /var/www/app/package*.json ./

RUN npm i --omit=dev


# На предыдущем слое вызываем команду npm run build и сохраняем новый
COPY --from=builder /var/www/app/dist ./dist/
EXPOSE 3000
CMD [ "node", "./dist/main.js" ]

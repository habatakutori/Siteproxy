FROM node:alpine

WORKDIR /usr/app

COPY ./ ./
RUN sed -i s/siteproxy.netptop.workers.dev/$SERVERNAME/g config.js
RUN cat config.js | head -n 8 | tail -n 4
RUN npm install

EXPOSE 8011
CMD ["npm", "start"]

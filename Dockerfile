FROM node:alpine

WORKDIR /usr/app

COPY ./ ./
ARG SERVER_NAME
ENV SERVER_NAME=${SERVER_NAME}
RUN sed -i s/siteproxy.netptop.workers.dev/${SERVER_NAME}/g config.js
RUN cat config.js | sed -n '8,11p'
RUN npm install

EXPOSE 8011
CMD ["npm", "start"]

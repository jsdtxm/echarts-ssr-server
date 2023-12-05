FROM python:3.9-alpine3.17

LABEL maintainer="Xia Min <jsdtxm@gmail.com>"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apk add --no-cache git nodejs npm icu-data-full

RUN npm config set registry https://registry.npmmirror.com

WORKDIR /app/

ADD server.js /app/
ADD package.json /app/

RUN apk add --no-cache pkgconfig pixman-dev cairo-dev pango-dev g++ make

RUN npm install -g pm2 && npm install --build-from-source canvas && npm install && npm cache clean --force

RUN apk add --no-cache fontconfig ttf-dejavu
COPY ./simhei.ttf /usr/share/fonts/simhei.ttf
COPY ./simsun.ttc /usr/share/fonts/simsun.ttc

EXPOSE 8191

CMD ["pm2-docker", "start", "server.js"]

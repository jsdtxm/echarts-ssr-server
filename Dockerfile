FROM python:3.9-alpine3.17 as builder

LABEL maintainer="Xia Min <jsdtxm@gmail.com>"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache -U tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apk add --no-cache git nodejs npm icu-data-full
RUN apk add --no-cache pkgconfig pixman-dev cairo-dev pango-dev g++ make

RUN npm config set registry https://registry.npmmirror.com

WORKDIR /app/

ADD server.js /app/
ADD package.json /app/

RUN npm install -g pm2 && npm install --build-from-source canvas && npm install && npm cache clean --force

####################################################################################################

FROM python:3.9-alpine3.17 as runner

LABEL maintainer="Xia Min <jsdtxm@gmail.com>"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN apk add --no-cache git nodejs npm cairo pango fontconfig

RUN npm config set registry https://registry.npmmirror.com
RUN npm install -g pm2 && npm cache clean --force

WORKDIR /app/
COPY --from=builder /app .

EXPOSE 8191

CMD ["pm2-docker", "start", "server.js"]

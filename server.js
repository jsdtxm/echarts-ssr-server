const http = require("http");
const echarts = require("echart5-canvars-ssr");
const url = require("url");
const os = require("os");
const cluster = require("cluster");
const safeEval = require("safe-eval");
const json5 = require("json5");

const CPU_CORES_NUM = os.cpus().length;

if (cluster.isMaster) {
  console.log(`Master ${process.pid} is running.`);
  for (let i = 0; i < CPU_CORES_NUM; i++) {
    cluster.fork();
  }
  cluster.on("exit", (worker, code, signal) => {
    console.log(`worker ${worker.process.pid} died.`);
  });
} else {
  const server = http.createServer(function (request, response) {
    processConfig(request, response, function () {
      let config;
      try {
        config = json5.parse(request.config, (_, value) => {
          if (
            typeof value === "string" &&
            (value.includes("function") || value.includes("=>"))
          ) {
            return safeEval(value);
          }
          return value;
        });
      } catch (e) {
        response.statusCode = 400;
        response.end('request parameter "config" format invalid, is not JSON');
        return;
      }
      if (!config || !config.option) {
        response.statusCode = 400;
        response.end('request parameter "config" format invalid');
        return;
      }
      const buffer = echarts({
        option: config.option,
        width: config.width || 600,
        height: config.height || 400,
      });
      response.setHeader("Content-Type", "image/png");
      response.write(buffer);
      response.end();
    });
  });
  const hostName = "0.0.0.0";
  const port = 8191;
  server.listen(port, hostName, function () {
    console.log(`Worker ${process.pid} started server at port ${port}.`);
  });
}

function processConfig(request, response, callback) {
  let queryData = "";
  if (typeof callback !== "function") {
    return null;
  }
  if (request.method === "GET") {
    const arg = url.parse(request.url, true).query;
    if (!arg.config) {
      response.statusCode = 400;
      response.end('request parameter "config" invalid');
      return;
    }
    request.config = arg.config;
    callback();
  } else {
    request.on("data", function (data) {
      queryData += data;
      if (queryData.length > 1e6) {
        response.statusCode = 422;
        response.end("request body too large");
      }
    });
    request.on("end", function () {
      request.config = queryData;
      callback();
    });
  }
}

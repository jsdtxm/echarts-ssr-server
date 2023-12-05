> Fork From https://github.com/jessezhang007007/echarts-ssr-server


# Echarts 服务器端生成图片服务

github地址：https://github.com/jsdtxm/echarts-ssr-server


## 一、说明：

Echarts server side render by node canvas, generate chart image by Echarts.

使用NodeJs服务器端渲染echarts图表，生成图片格式。

## 二、运行

### 1. 构建image

```
docker build -t echarts-ssr-server:latest .
```


### 2. 准备字体

将准备好的中英文字体存放至fonts文件夹中，推荐字体：Dejavu、wqy


### 3. 启动container

```
docker run -it -p 8191:8191 -v `pwd`/fonts:/usr/share/fonts echarts-ssr-server:latest
```


## 三、访问服务

### 1. 请求参数格式：
```javascript
{
    "width": 800,
    "height": 500,
    "option": {
    	"backgroundColor": "#fff",
        "xAxis": {
            "type": "category",
            "data": [
                "Mon",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat",
                "Sun"
            ]
        },
        "yAxis": {
            "type": "value"
        },
        "series": [
            {
                "data": [
                    820,
                    932,
                    901,
                    934,
                    1290,
                    1330,
                    1320
                ],
                "type": "line"
            }
        ]
    }
}
```

参数JSON里的第一层属性说明：

|属性名|类型|默认值|说明|
|---|---|---|---|
|width|Number|600|图片宽度|
|height|Number|400|图片高度|
|option|Object|{}|Echarts 的 Option 配置，参考Echarts文档|


### 2. POST方式访问

```
curl -X POST \
  http://127.0.0.1:8191/ \
  -o echart-image.png \
  -d '{
    "width": 800,
    "height": 500,
    "option": {
    	"backgroundColor": "#fff",
        "xAxis": {
            "type": "category",
            "data": [
                "Mon",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat",
                "Sun"
            ]
        },
        "yAxis": {
            "type": "value"
        },
        "series": [
            {
                "data": [
                    820,
                    932,
                    901,
                    934,
                    1290,
                    1330,
                    1320
                ],
                "type": "line"
            }
        ]
    }
}'
```

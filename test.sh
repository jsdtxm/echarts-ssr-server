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
                "周一",
                "Tue",
                "Wed",
                "Thu",
                "Fri",
                "Sat",
                "周5"
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
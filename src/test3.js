{
    "pipeline":[
        { "name":"derivative" },
        { "name":"gaussian_blur",
           "attr":{
              "sigma": [2.0],
           }
        },
        { "name":"harris_detector" },
    ]
}

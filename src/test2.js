{
    "title":"Half Tone Gradient",
    "pipeline":[
        { "name":"halftone", "ui":{ "primary":["radius"] },
            "attr":{ "color1":[0.5, 0.5, 0.5, 1.0], "radius":6.0 } },
        { "name":"gradient",
            "attr":{ "color1":[0.3, 0.3, 0.8, 1.0], "color2":[0.2, 0.8, 0.2, 1.00] } },
        { "name":"swap" },
        { "name":"luminosity" },
    ]
}

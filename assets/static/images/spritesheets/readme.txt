The images and the inkscape file must follow the following conventions to make Dreadnought.Core.Spritesheet compile correctly.

IMAGE SIZE
Image size is dictated by the scaling in the SVG file, so the size of the actual image doesn't matter.

IMAGE FILE NAME
This dictates the function names in Spritesheet.
Example: To access the "small_ship" in the "red1.png" file:
Spritesheet.red1("small_ship")

INKSCAPE LAYERS

Each layer contains all the data for a single spritesheet.

Its name should match the filename (minus extension). This is just for readability, as the Spritesheet macro pulls from the filename itself.
Example: "red1.png"'s layer should be called "red1"

INKSCAPE SUBLAYERS

Each sublayer (w/in a layer) ...

{
  "svg" => %{
    "#content" => %{
      "defs" => %{
        "#content" => %{
          "linearGradient" => [
            %{
              "#content" => %{
                "stop" => %{
                  "#content" => nil,
                  "-id" => "stop5075",
                  "-offset" => "0",
                  "-style" => "stop-color:#0067ff;stop-opacity:1;"
                }
              },
              "-id" => "linearGradient5077"
            },
            %{
              "#content" => %{
                "stop" => %{
                  "#content" => nil,
                  "-id" => "stop5069",
                  "-offset" => "0",
                  "-style" => "stop-color:#86ff00;stop-opacity:0.52549022;"
                }
              },
              "-id" => "main_green",
              "-{http://www.openswatchbook.org/uri/2009/osb}paint" => "solid"
            },
            %{
              "#content" => %{
                "stop" => %{
                  "#content" => nil,
                  "-id" => "stop2892",
                  "-offset" => "0",
                  "-style" => "stop-color:#0067ff;stop-opacity:0.58431375;"
                }
              },
              "-id" => "mounting_blue",
              "-{http://www.openswatchbook.org/uri/2009/osb}paint" => "solid"
            },
            %{
              "#content" => %{
                "stop" => %{
                  "#content" => nil,
                  "-id" => "stop2860",
                  "-offset" => "0",
                  "-style" => "stop-color:#ff00a6;stop-opacity:0.50196081;"
                }
              },
              "-gradientTransform" => "translate(54.525943,24.154594)",
              "-id" => "origin_red",
              "-{http://www.openswatchbook.org/uri/2009/osb}paint" => "solid"
            },
            %{
              "#content" => %{
                "stop" => %{
                  "#content" => nil,
                  "-id" => "stop2836",
                  "-offset" => "0",
                  "-style" => "stop-color:#0067ff;stop-opacity:1;"
                }
              },
              "-id" => "linearGradient2838"
            },
            %{
              "#content" => nil,
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(59.559101,6.2780443)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(125.39845,-40.971682)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3-5",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(180.73188,-10.566248)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3-5-9",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(207.7805,-46.634744)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3-5-7",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(150.48658,-56.05139)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3-5-7-3",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(196.27491,-50.174926)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3-5-6",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient5079",
              "-x1" => "15.472434",
              "-x2" => "53.346184",
              "-y1" => "32.366779",
              "-y2" => "32.366779",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#main_green"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "translate(88.420284,0.00462456)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient2896-3-5-2",
              "-x1" => "20.562542",
              "-x2" => "32.018116",
              "-y1" => "16.733143",
              "-y2" => "16.733143",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#origin_red"
            },
            %{
              "#content" => nil,
              "-gradientTransform" => "matrix(1.0883973,0,0,0.91878216,34.263357,5.6464336)",
              "-gradientUnits" => "userSpaceOnUse",
              "-id" => "linearGradient5166",
              "-x1" => "54.268879",
              "-x2" => "82.730721",
              "-y1" => "18.686352",
              "-y2" => "29.685867",
              "-{http://www.inkscape.org/namespaces/inkscape}collect" => "always",
              "-{http://www.w3.org/1999/xlink}href" => "#main_green"
            }
          ]
        },
        "-id" => "defs6"
      },
      "g" => [
        %{
          "#content" => %{
            "g" => [
              %{
                "#content" => %{
                  "image" => %{
                    "#content" => nil,
                    "-height" => "57",
                    "-id" => "image1201",
                    "-preserveAspectRatio" => "none",
                    "-style" => "image-rendering:optimizeSpeed",
                    "-width" => "122",
                    "-x" => "0",
                    "-y" => "0",
                    "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}absref" => "/home/jc/projects/dreadnought/assets/static/spritesheets/red1.png",
                    "-{http://www.w3.org/1999/xlink}href" => "red1.png"
                  }
                },
                "-id" => "g10",
                "-style" => "display:inline",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "image"
              },
              %{
                "#content" => %{
                  "circle" => [
                    %{
                      "#content" => nil,
                      "-cx" => "108.77674",
                      "-cy" => "49.79044",
                      "-id" => "tsrtsratsraa-7-5-9-0",
                      "-r" => "5.727787",
                      "-style" => "display:inline;fill:url(#linearGradient2896-3-5-7-3);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                    },
                    %{ 
                      "#content" => nil,
                      "-cx" => "119.60484",
                      "-cy" => "49.333767",
                      "-id" => "mounting2-6-1-8",
                      "-r" => "4.8382006",
                      "-style" => "display:inline;fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_1"
                    }
                  ],
                  "path" => %{
                    "#content" => nil,
                    "-d" => "m 114.97139,54.837516 -4.77671,2.407779 -9.85285,-3.952174 -0.33767,-6.628149 7.93644,-4.304868 6.14212,1.033982 0.1328,2.02775 6.91631,0.01054 0.15257,7.719266 -6.22185,-0.122489 z",
                    "-id" => "turret1",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer1",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "turret2"
              },
              %{
                "#content" => %{
                  "circle" => [
                    %{
                      "#content" => nil,
                      "-cx" => "108.76904",
                      "-cy" => "33.151772",
                      "-id" => "tsrtsratsraa-7-5-9",
                      "-r" => "5.727787",
                      "-style" => "display:inline;fill:url(#linearGradient2896-3-5-7);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                    },
                    %{
                      "#content" => nil,
                      "-cx" => "119.91442",
                      "-cy" => "32.89669",
                      "-id" => "mounting2-6-1",
                      "-r" => "4.8382006",
                      "-style" => "display:inline;fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_1"
                    }
                  ],
                  "path" => %{
                    "#content" => nil,
                    "-d" => "m 115.74073,37.04267 5.98494,-0.05192 -0.0238,-8.695817 -6.58034,0.02236 0.0345,-1.593606 -5.37657,-2.146846 -10.898659,4.976835 0.02434,7.451037 11.106069,4.952935 5.62388,-3.6197 z",
                    "-id" => "turret2",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer2",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "turret1"
              },
              %{ 
                "#content" => %{
                  "circle" => [
                    %{
                      "#content" => nil,
                      "-cx" => "67.529015",
                      "-cy" => "43.427483",
                      "-id" => "center",
                      "-r" => "4.9701986",
                      "-style" => "fill:#ff007f;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                    },
                    %{
                      "#content" => nil,
                      "-cx" => "22",
                      "-cy" => "43.721001",
                      "-id" => "mounting2",
                      "-r" => "4.8382006",
                      "-style" => "fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_2"
                    },
                    %{
                      "#content" => nil,
                      "-cx" => "70",
                      "-cy" => "43.721001",
                      "-id" => "mounting1",
                      "-r" => "3.5795486",
                      "-style" => "fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_1"
                    }
                  ],
                  "path" => %{
                    "#content" => nil,
                    "-d" => "M 73.421946,56.435023 49.017571,56.430522 22.595,57.259254 1.9272685,52.240661 0.07428334,38.147362 19.923642,28.223722 l 51.781227,1.68658 20.068997,6.291772 7.84248,6.716778 0.228374,4.817948 z",
                    "-id" => "main",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer6",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "ship_large"
              },
              %{
                "#content" => %{
                  "circle" => %{
                    "#content" => nil,
                    "-cx" => "117.18596",
                    "-cy" => "20.796219",
                    "-id" => "tsrtsratsraa-7-5-6",
                    "-r" => "5.727787",
                    "-style" => "display:inline;fill:url(#linearGradient2896-3-5-6);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                  },
                  "path" => %{
                    "#content" => nil,
                    "-d" => "m 118.50229,23.450946 -17.58265,-1.415666 0.0165,-2.724716 17.33199,-1.013664 1.50977,0.792968 0.10379,3.441823 z",
                    "-id" => "shell1",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer3",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "shell2"
              },
              %{
                "#content" => %{
                  "circle" => %{
                    "#content" => nil,
                    "-cx" => "117.0368",
                    "-cy" => "12.70329",
                    "-id" => "tsrtsratsraa-7-5-2",
                    "-r" => "5.727787",
                    "-style" => "display:inline;fill:url(#linearGradient2896-3-5-9);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                  },
                  "path" => %{
                    "#content" => nil,
                    "-d" => "m 117.77598,15.969697 -21.748099,-1.380925 -0.02276,-2.201623 4.011549,-2.320141 18.58766,0.892309 1.84219,1.134692 -0.12341,2.562465 z",
                    "-id" => "path877",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "g881",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "shell1"
              },
              %{
                "#content" => %{
                  "circle" => [
                    %{
                      "#content" => nil,
                      "-cx" => "78.785614",
                      "-cy" => "17.809113",
                      "-id" => "tsrtsratsraa-7",
                      "-r" => "5.727787",
                      "-style" => "display:inline;fill:url(#linearGradient2896-3);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                    },
                    %{
                      "#content" => nil,
                      "-cx" => "76.69136",
                      "-cy" => "17.756834",
                      "-id" => "mounting2-6-1-7",
                      "-r" => "4.8382006",
                      "-style" => "display:inline;fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_1"
                    }
                  ],
                  "path" => %{
                    "#content" => nil,
                    "-d" => "M 98.489943,23.090072 68.900196,29.520969 55.344925,24.463975 54.218128,10.154981 67.720568,4.7043322 98.714502,17.950626 Z",
                    "-id" => "shipSmall",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer5",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "ship_small"
              },
              %{
                "#content" => %{
                  "a" => %{
                    "#content" => %{
                      "circle" => %{
                        "#content" => nil,
                        "-cx" => "26.290329",
                        "-cy" => "16.733143",
                        "-id" => "tsrtsratsraa",
                        "-r" => "5.727787",
                        "-style" => "display:inline;fill:url(#linearGradient2896);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                        "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                      }
                    },
                    "-id" => "a2898",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                  },
                  "path" => %{
                    "#content" => nil,
                    "-d" => "m 40.975524,30.45178 -12.847526,-6.159801 -5.919108,-5.974453 -1.81186,-5.097507 3.633931,-2.00389 3.069987,-8.700887 4.353007,-0.090738 1.300525,3.1341729 5.70062,-2.4245215 4.442273,2.5904048 -3.156236,2.9147956 9.484801,1.0936275 0.825241,3.6017087 -3.739632,1.800635 8.171814,5.111405 -0.03951,3.759412 -2.151496,1.562245 -10.660151,-2.539106 2.282372,5.233472 z",
                    "-id" => "boom",
                    "-style" => "fill:#86ff00;fill-opacity:0.475486;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer4",
                "-style" => "display:inline",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "muzzle_flash"
              }
            ]
          },
          "-id" => "layer7",
          "-style" => "display:inline",
          "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
          "-{http://www.inkscape.org/namespaces/inkscape}label" => "red1"
        },
        %{
          "#content" => %{
            "g" => [
              %{
                "#content" => nil,
                "-id" => "layer12",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "image"
              },
              %{
                "#content" => %{
                  "circle" => %{
                    "#content" => nil,
                    "-cx" => "92.134949",
                    "-cy" => "35.554276",
                    "-id" => "tsrtsratsraa-7-5-23-8",
                    "-r" => "5.727787",
                    "-style" => "display:inline;fill:url(#origin_red);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                  },
                  "path" => %{
                    "#content" => nil,
                    "-d" => "M 66.801606,13.395796 H 104.67535 V 45.367325 H 66.801606 Z",
                    "-id" => "rect5067-2",
                    "-style" => "display:inline;fill:url(#linearGradient5166);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer10",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "test_clip_path2"
              }, 
              %{
                "#content" => %{
                  "circle" => [
                    %{
                      "#content" => nil,
                      "-cx" => "24.725218",
                      "-cy" => "23.274162",
                      "-id" => "tsrtsratsraa-7-5-23",
                      "-r" => "5.727787",
                      "-style" => "display:inline;fill:url(#linearGradient2896-3-5-2);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
                    },
                    %{
                      "#content" => nil,
                      "-cx" => "42.630157",
                      "-cy" => "39.844872",
                      "-id" => "mounting2-6-9",
                      "-r" => "4.8382006",
                      "-style" => "display:inline;fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                      "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_1"
                    }
                  ],
                  "path" => %{
                    "#content" => nil,
                    "-d" => "M 15.472434,16.381016 H 53.346183 V 48.352545 H 15.472434 Z",
                    "-id" => "rect5067",
                    "-style" => "fill:url(#linearGradient5079);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                    "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
                  }
                },
                "-id" => "layer9",
                "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
                "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "test_clip_path1"
              }
            ]
          },
          "-id" => "layer8",
          "-style" => "display:none",
          "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
          "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
          "-{http://www.inkscape.org/namespaces/inkscape}label" => "test_layer"
        },
        %{
          "#content" => %{
            "circle" => [
              %{
                "#content" => nil,
                "-cx" => "61.703381",
                "-cy" => "-17.702145",
                "-id" => "tsrtsratsraa-7-5",
                "-r" => "5.727787",
                "-style" => "display:inline;fill:url(#linearGradient2896-3-5);fill-opacity:1;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "origin"
              },
              %{
                "#content" => nil,
                "-cx" => "79.789818",
                "-cy" => "-16.408155",
                "-id" => "mounting2-6",
                "-r" => "4.8382006",
                "-style" => "display:inline;fill:#0067ff;fill-opacity:0.475486;stroke-width:10;stroke-linecap:round;stroke-linejoin:round;paint-order:fill markers stroke",
                "-{http://www.inkscape.org/namespaces/inkscape}label" => "mounting_1"
              }
            ],
            "path" => %{
              "#content" => nil,
              "-d" => "M 50.639395,-10.761048 21.049648,-4.3301509 7.4943772,-9.3871448 6.3675802,-23.696139 19.87002,-29.146787 50.863954,-15.900493 Z",
              "-id" => "shipSmall-9",
              "-style" => "display:inline;fill:url(#main_green);fill-opacity:1;stroke:none;stroke-width:0.182973px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1",
              "-{http://www.inkscape.org/namespaces/inkscape}label" => "main"
            }
          },
          "-id" => "layer11",
          "-style" => "display:none",
          "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}insensitive" => "true",
          "-{http://www.inkscape.org/namespaces/inkscape}groupmode" => "layer",
          "-{http://www.inkscape.org/namespaces/inkscape}label" => "common_shapes"
        }
      ],
      "metadata" => %{
        "#content" => %{
          "{http://www.w3.org/1999/02/22-rdf-syntax-ns#}RDF" => %{
            "{http://creativecommons.org/ns#}Work" => %{
              "#content" => %{
                "{http://purl.org/dc/elements/1.1/}format" => "image/svg+xml",
                "{http://purl.org/dc/elements/1.1/}title" => nil,
                "{http://purl.org/dc/elements/1.1/}type" => %{
                  "#content" => nil,
                  "-{http://www.w3.org/1999/02/22-rdf-syntax-ns#}resource" => "http://purl.org/dc/dcmitype/StillImage"
                }
              },
              "-{http://www.w3.org/1999/02/22-rdf-syntax-ns#}about" => ""
            }
          }
        },
        "-id" => "metadata8"
      },
      "style" => %{"#content" => nil, "-id" => "style5183"},
      "{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}namedview" => %{
        "#content" => nil,
        "-bordercolor" => "#666666",
        "-borderopacity" => "1",
        "-gridtolerance" => "10",
        "-guidetolerance" => "10",
        "-id" => "namedview4",
        "-objecttolerance" => "10",
        "-pagecolor" => "#ffffff",
        "-showgrid" => "false",
        "-showguides" => "true",
        "-{http://www.inkscape.org/namespaces/inkscape}current-layer" => "g10",
        "-{http://www.inkscape.org/namespaces/inkscape}cx" => "49.709127",
        "-{http://www.inkscape.org/namespaces/inkscape}cy" => "49.057738",
        "-{http://www.inkscape.org/namespaces/inkscape}document-rotation" => "0",
        "-{http://www.inkscape.org/namespaces/inkscape}guide-bbox" => "true",
        "-{http://www.inkscape.org/namespaces/inkscape}lockguides" => "false",
        "-{http://www.inkscape.org/namespaces/inkscape}pageopacity" => "0",
        "-{http://www.inkscape.org/namespaces/inkscape}pageshadow" => "2",
        "-{http://www.inkscape.org/namespaces/inkscape}window-height" => "1352",
        "-{http://www.inkscape.org/namespaces/inkscape}window-maximized" => "0",
        "-{http://www.inkscape.org/namespaces/inkscape}window-width" => "2560",
        "-{http://www.inkscape.org/namespaces/inkscape}window-x" => "2560",
        "-{http://www.inkscape.org/namespaces/inkscape}window-y" => "51",
        "-{http://www.inkscape.org/namespaces/inkscape}zoom" => "6.0696721"
      }
    },
    "-height" => "57",
    "-id" => "svg2",
    "-version" => "1.1",
    "-viewBox" => "0 0 122 57",
    "-width" => "122",
    "-{http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd}docname" => "clip_paths.svg",
    "-{http://www.inkscape.org/namespaces/inkscape}version" => "1.0.1 (3bc2e813f5, 2020-09-07)"
  }
}


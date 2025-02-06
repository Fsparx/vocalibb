import 'package:flutter/material.dart';

class GroundFloor_Screen extends StatefulWidget {
  final String bookId;
  final String rackId;
  final array;
  const GroundFloor_Screen(
      {super.key, required this.bookId, required this.rackId, this.array});
  @override
  _GroundFloor_ScreenState createState() => _GroundFloor_ScreenState();
}

class _GroundFloor_ScreenState extends State<GroundFloor_Screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  late TransformationController _zoom_controller = TransformationController();
  late Matrix4 _initialZoom;
  final ScrollController _scrollController = ScrollController();
  bool isZoomedIn = false;
  double minScale = 0.41; // Set your initial scale as min scale
  late Rect boundaryRect;
  // Define directions as a list of maps with sizes

  @override
  void initState() {
    super.initState();
    _zoom_controller =
        TransformationController(Matrix4.identity()..scale(minScale));

    // Set initial zoom to a smaller scale
    _initialZoom = Matrix4.identity()..scale(0.41); // Adjust scale as needed
    _zoom_controller =
        TransformationController(_initialZoom); // Apply initial zoom
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    togglebool();
    super.dispose();
  }

  void _resetZoom() {
    // ============ This function is used to change the state in to initial zoomout===================
    _zoom_controller = TransformationController(_initialZoom);
  }

  void _resetscroll() {
    //============== This function is used for return the scroller controller to its starting stage to reduce blank space=================
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
  }

  void togglebool() {
    // ============== Change the bool when we need , the bool is controlling the scroller controller================
    setState(() {
      isZoomedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    // final List<Map<String, dynamic>> _directions = [
    //   {"direction": "straight", "length": 160.0},
    //   {"direction": "straight", "length": 895.0},
    //   {"direction": "right", "length": 200.0},
    //   {"direction": "straight", "length": 100.0},
    //   {"direction": "right", "length": 140.0},
    //   {"direction": "straight", "length": 120.0},
    //   {"direction": "right", "length": 10.0},
    // ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },),
        title: Row(
          children: [
            SizedBox(
                width: 140,
                child: Text(
                  'BookID:${widget.bookId}',
                  style: TextStyle(fontSize: 12),
                )),
            SizedBox(
                width: 100,
                child: Text(
                  'RackID:${widget.rackId}',
                  style: TextStyle(fontSize: 12),
                )),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        physics: isZoomedIn
            ? AlwaysScrollableScrollPhysics()
            : NeverScrollableScrollPhysics(),
        child: SingleChildScrollView(
          physics: isZoomedIn
              ? AlwaysScrollableScrollPhysics()
              : NeverScrollableScrollPhysics(),
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Center(
            child: InteractiveViewer(
              // scaleEnabled: false,
              // constrained: false,
              // boundaryMargin: EdgeInsets.zero,
              clipBehavior: Clip.hardEdge,
              panEnabled: true, // Enable panning
              // boundaryMargin: EdgeInsets.all(20), // Add padding outside
              minScale: minScale, // Minimum zoom-out scale
              maxScale: 1.0, // Maximum zoom-in scale
              transformationController: _zoom_controller, // Use the controller
              onInteractionEnd: (details) {
                double currentScale =
                    _zoom_controller.value.getMaxScaleOnAxis();
                print(currentScale);
                if (currentScale == minScale) {}
                if (currentScale > minScale) {
                  setState(() {
                    // Change the boolean when the scale goes beyond the default value
                    isZoomedIn = true;
                  });
                }
              },
              onInteractionUpdate: (details) {
                double _previousScale = 1.0;
                double currentScale = details.scale;

                if (currentScale > _previousScale) {
                  print("Zooming In");
                } else if (currentScale < _previousScale) {
                  _resetscroll();
                  togglebool();

                  _resetZoom();
                  print("Zooming Out");
                }

                _previousScale = currentScale;
              },
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            sizedBox(0.0, 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // height: 130,
                                  color: Colors.white,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // sizedBox(0.0, 10.0),
                                      Column(
                                        children: [
                                          sizedBox(10.0, 0.0),
                                          customeContainer(
                                              20.0, 60.0, '50A', 1.0),
                                          sizedBox(20.0, 0.0),
                                          customeContainer(
                                              15.0, 60.0, '51A', 1.0),
                                          customeContainer(
                                              15.0, 60.0, '52A', 1.0),
                                          sizedBox(20.0, 0.0),
                                          customeContainer(
                                              15.0, 60.0, '53A', 1.0),
                                          customeContainer(
                                              15.0, 60.0, '54A', 1.0),
                                          sizedBox(70.0, 0.0),
                                          customeContainer(
                                              20.0, 60.0, '55A', 1.0),
                                          sizedBox(10.0, 0.0),
                                        ],
                                      ),
                                      sizedBox(0.0, 20.0),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          sizedBox(10.0, 0.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  customeContainer(
                                                      50.0, 20.0, '57A', 1.0),
                                                  sizedBox(10.0, 0.0),
                                                  customeContainer(
                                                      50.0, 20.0, '58A', 1.0),
                                                ],
                                              ),
                                              sizedBox(10.0, 20.0),
                                              customeContainer(
                                                  110.0, 20.0, '60A', 1.0),
                                            ],
                                          ),
                                          sizedBox(20.0, 20.0),
                                          customeContainer(
                                              20.0, 60.0, '59A', 1.0),
                                          sizedBox(40.0, 20.0),
                                          customeContainer(
                                              20.0, 60.0, '56A', 1.0),
                                        ],
                                      ),
                                      sizedBox(10.0, 20.0),

                                      customeContainer(110.0, 20.0, '61A', 1.0),

                                      customeContainer(110.0, 20.0, '73A', 1.0),
                                      sizedBox(10.0, 20.0),
                                      Column(
                                        children: [
                                          sizedBox(160.0, 20.0),
                                          customeContainer(
                                              60.0, 20.0, '32A', 1.0),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          customeContainer(
                                              20.0, 100.0, '74A', 1.0),
                                          sizedBox(20.0, 20.0),
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  sizedBox(20.0, 20.0),
                                                  customeContainer(
                                                      60.0, 20.0, '63A', 1.0),
                                                  customeContainer(
                                                      100.0, 20.0, '62A', 1.0),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  sizedBox(20.0, 20.0),
                                                  customeContainer(
                                                      90.0, 20.0, '64A', 1.0),
                                                  customeContainer(
                                                      70.0, 20.0, '65A', 1.0),
                                                ],
                                              ),
                                              sizedBox(10.0, 20.0),
                                              Column(
                                                children: [
                                                  sizedBox(20.0, 20.0),
                                                  customeContainer(
                                                      70.0, 20.0, '67A', 1.0),
                                                  customeContainer(
                                                      90.0, 20.0, '66A', 1.0),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  sizedBox(20.0, 20.0),
                                                  customeContainer(
                                                      60.0, 20.0, '', 1.0),
                                                  customeContainer(
                                                      100.0, 20.0, '69A', 1.0),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      sizedBox(20.0, 50.0),
                                      // columns in strating for row==============================
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //========================================= 75 A to 85 a =======================================================

                                          Row(
                                            children: [
                                              sizedBox(20.0, 30.0),
                                              customeContainer(
                                                  20.0, 100.0, '75A', 1.0),
                                              // sizedBox(20.0, 20.0),
                                            ],
                                          ),
                                          //========================================= 75 A to 85 a =======================================================

                                          sizedBox(20.0, 80.0),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              sizedBox(20.0, 20.0),
                                              customeContainer(
                                                  60.0, 20.0, '78A', 1.0),
                                              // ============ stairs area starting================================
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      customeContainer(50.0,
                                                          20.0, '79A', 1.0),
                                                      sizedBox(20.0, 20.0),
                                                      customeContainer(50.0,
                                                          20.0, '80A', 1.0),
                                                      customeContainer(50.0,
                                                          20.0, '81A', 1.0),
                                                      sizedBox(20.0, 20.0),
                                                      customeContainer(50.0,
                                                          20.0, '82A', 1.0),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 10,
                                                    width: 120,
                                                    color: Colors.blueGrey,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          sizedBox(0.0, 20.0),

                                          Row(
                                            children: [
                                              sizedBox(0.0, 80.0),
                                              Container(
                                                height: 20,
                                                width: 80,
                                                color: Colors.blueGrey,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              sizedBox(0.0, 20.0),
                                              customeContainer(
                                                  50.0, 20.0, '70A', 1.0),
                                              customeContainer(
                                                  50.0, 20.0, '71A', 1.0),
                                              sizedBox(0.0, 20.0),
                                              customeContainer(
                                                  50.0, 20.0, '72A', 1.0),
                                              Container(
                                                height: 50,
                                                width: 40,
                                                color: Colors.blueGrey,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              customeContainer(
                                                  50.0, 20.0, '28A', 1.0),
                                              Container(
                                                height: 50,
                                                width: 120,
                                                color: Colors.blueGrey,
                                              ),
                                              sizedBox(0.0, 2.0),
                                              customeContainer(
                                                  50.0, 20.0, '85A', 1.0),
                                            ],
                                          ),
                                          Row(children: [
                                            customeContainer(
                                                20.0, 50.0, '29A', 1.0),
                                            sizedBox(0.0, 90.0),
                                            customeContainer(
                                                20.0, 50.0, '30A', 1.0),
                                          ])
                                        ],
                                        // ============ stairs area starting================================
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customeContainer(
                                              20.0, 70.0, '84A', 1.0),
                                          sizedBox(20.0, 2.0),
                                          customeContainer(60.0, 30.0, '', 1.0),
                                          sizedBox(20.0, 2.0),
                                          customeContainer(50.0, 30.0, '', 1.0),
                                          sizedBox(10.0, 2.0),
                                          customeContainer(
                                              50.0, 30.0, '31A', 1.0),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          sizedBox(120.0, 2.0),
                                          customeContainer(
                                              60.0, 25.0, '88A', 1.0),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          sizedBox(60.0, 2.0),
                                          customeContainer(
                                              60.0, 25.0, '89A', 1.0),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          customeContainer(
                                              60.0, 25.0, '91A', 1.0),
                                          customeContainer(
                                              60.0, 25.0, '90A', 1.0),
                                          sizedBox(90.0, 2.0),
                                          customeContainer(
                                              20.0, 60.0, '94A', 1.0),
                                        ],
                                      ),
                                      sizedBox(0.0, 20.0),
                                      Column(
                                        children: [
                                          sizedBox(5.0, 20.0),
                                          customeContainer(
                                              120.0, 30.0, 'table', 5.0),
                                        ],
                                      ),
                                      sizedBox(0.0, 25.0),
                                      Column(
                                        children: [
                                          customeContainer(
                                              60.0, 25.0, '92A', 1.0),
                                          customeContainer(
                                              60.0, 25.0, '93A', 1.0),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            // Container(
                            //   height: 130,
                            //   width: 90,
                            //   color: const Color.fromARGB(255, 0, 0, 0),
                            // ),
                            sizedBox(0.0, 10.0),
                          ],
                        ),
                        //======================================================================= Main Area =====================================================================
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            sizedBox(0.0, 10.0),
                            // ==========================left side ============================
                            Container(
                              width: width / 2.6,
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  sizedBox(20.0, 10.0),

                                  customeContainer(200.0, double.infinity,
                                      'Staff Area', 0.0),
                                  sizedBox(10.0, 10.0),
                                  customeContainer(
                                      20.0, double.infinity, '49A', 0.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      35.0, double.infinity, 'Table', 0.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, double.infinity, '48A', 0.0),
                                  sizedBox(10.0, 10.0),
                                  Container(
                                    height: 250,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey)),
                                  ), //================= left bottom side area ==================================
                                  // sizedBox(10.0, 10.0),

                                  Container(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            sizedBox(50.0, 10.0),
                                            Column(
                                              children: [
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    60.0, 20.0, '98A', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    60.0, 20.0, '99B', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    60.0, 20.0, '99A', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    60.0, 20.0, '44A', 1.0),
                                                sizedBox(10.0, 10.0),
                                              ],
                                            ),
                                            sizedBox(50.0, 30.0),
                                            Column(
                                              children: [
                                                customeContainer(
                                                    40.0, 20.0, '33A', 1.0),
                                                sizedBox(40.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '35A', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '39A', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '40A', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '41A', 1.0),
                                                sizedBox(10.0, 10.0),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                customeContainer(
                                                    40.0, 20.0, '33B', 1.0),
                                                sizedBox(40.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '35B', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '39B', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '40B', 1.0),
                                                sizedBox(10.0, 10.0),
                                                customeContainer(
                                                    40.0, 20.0, '41B', 1.0),
                                                sizedBox(10.0, 10.0),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // ==========================left side ============================
                            // lengthy rack area 1 left =========================================================
                            sizedBox(0.0, 10.0),
                            Container(
                              // height: height / 0.88,
                              width: width / 2.0,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '13B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '13A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '12B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '12A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '11B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '11A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '10B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '10A', 3.0),
                                  sizedBox(100.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '9B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '9A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '8B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '8A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '7B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '7A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '6B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '6A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '5B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '5A', 3.0),
                                  sizedBox(50.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '4B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '4A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '3B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '3A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '2B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '2A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.9, '1B', 3.0),
                                  customeContainer(
                                      20.0, width / 1.9, '1A', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      40.0, width / 1.9, 'table', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      40.0, width / 1.9, 'table', 3.0),
                                  sizedBox(20.0, 10.0),
                                  const Divider()
                                ],
                              ),
                            ),
                            // lengthy rack area 1 left =========================================================

                            sizedBox(0.0, 10.0),
                            // ===================table =====================================
                            Column(
                              children: [
                                sizedBox(20.0, 20.0),
                                customeContainer(
                                    height / 1.3, width / 15, 'Table', 2.0
                                    // color: Colors.yellow,
                                    ),
                                sizedBox(45.0, 20.0),
                                customeContainer(
                                    height / 3.5, width / 15, 'Table', 2.0
                                    // color: Colors.yellow,
                                    ),
                              ],
                            ),
                            sizedBox(0.0, 20.0),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: height / 0.9,
                              width: width / 9,
                              color: const Color.fromARGB(255, 122, 122, 122),
                              child: const Center(
                                child: RotatedBox(
                                  quarterTurns: 135,
                                  child: Text(
                                    'Table',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            sizedBox(0.0, 110.0),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: height / 0.9,
                              width: width / 9,
                              color: const Color.fromARGB(255, 122, 122, 122),
                              child: const Center(
                                child: RotatedBox(
                                  quarterTurns: 135,
                                  child: Text(
                                    'Table',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            sizedBox(0.0, 20.0),
                            Column(
                              children: [
                                sizedBox(20.0, 20.0),
                                customeContainer(
                                    height / 1.3, width / 15, 'Table', 2.0
                                    // color: Colors.yellow,
                                    ),
                                sizedBox(45.0, 20.0),
                                customeContainer(
                                    height / 3.5, width / 15, 'Table', 2.0
                                    // color: Colors.yellow,
                                    ),
                              ],
                            ),
                            sizedBox(0.0, 10.0),
                            Container(
                              width: width / 1.7,
                              // color: Colors.yellow,
                              child: Column(
                                children: [
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '14A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '14B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '15A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '15B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '16A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '16B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '17A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '17B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '18A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '18B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '19A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '19B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '20A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '20B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '21A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '21B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '22A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '22B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '23A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '23B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '24A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '24B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '25A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '25B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '26A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '26B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '27A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '27B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      20.0, width / 1.7, '28A', 3.0),
                                  customeContainer(
                                      20.0, width / 1.7, '28B', 3.0),
                                  sizedBox(20.0, 10.0),
                                  customeContainer(
                                      100.0, width / 1.7, 'Librarian', 3.0),
                                  sizedBox(20.0, 10.0),
                                  const Divider()
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: width / 2.5,
                              color: Colors.white,
                            ),
                            Container(
                              height: 100,
                              width: width / 1.5,
                              color: const Color.fromARGB(255, 255, 239, 202),
                              child: Center(
                                child: Text('Lobby'),
                              ),
                            ),
                            Container(
                              height: 100,
                              width: width / 1.5,
                              color: const Color.fromARGB(255, 162, 209, 255),
                              child: Center(
                                child: Text('Entrance'),
                              ),
                            ),
                            Container(
                              height: 100,
                              width: width / 1.5,
                              color: const Color.fromARGB(255, 255, 239, 202),
                              child: const Center(
                                child: Text('Checkout Area'),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    CustomPaint(
                        painter: NavigationPainter(
                            progress: _progress.value,
                            directions: widget.array,
                            screenSize: MediaQuery.of(context).size,
                            height: height,
                            width: width),
                        child: Container()),
                    Padding(
                        padding: const EdgeInsets.only(top: 225),
                        child: Container(
                          height: 8,
                          width: 170,
                          color: Colors.black,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 225, left: width / 1.6),
                        child: Container(
                          height: 8,
                          width: 130,
                          color: Colors.black,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 230, left: width / 0.507),
                        child: Container(
                          height: 8,
                          width: 170,
                          color: Colors.black,
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          top: 1150,
                        ),
                        child: Container(
                          height: 8,
                          width: 145,
                          color: Colors.black,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 845, left: width / 2.55),
                        child: Container(
                          height: 30,
                          width: 8,
                          color: Colors.black,
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 925, left: width / 2.55),
                        child: Container(
                          height: height / 1.66,
                          width: 8,
                          color: Colors.black,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dispose1() {
    _zoom_controller.dispose();
    super.dispose();
  }
}

class NavigationPainter extends CustomPainter {
  final double progress;
  final List<Map<String, dynamic>> directions;
  final Size screenSize;
  final double height;
  final double width;

  NavigationPainter(
      {required this.progress,
      required this.directions,
      required this.screenSize,
      required this.height,
      required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final Path path = Path();
    final Paint iconPaint = Paint()..color = Colors.grey;

    // Starting point (bottom-center)
    Offset currentPosition =
        Offset(size.width + width / 0.73, size.height + 1300);
    path.moveTo(currentPosition.dx, currentPosition.dy);

    double animatedDistance = progress *
        directions.fold(0.0, (sum, dir) => sum + dir["length"]); // Total length
    for (var i = 0; i < directions.length; i++) {
      final direction = directions[i];
      if (animatedDistance <= 0) break;

      final double segmentProgress = animatedDistance >= direction["length"]
          ? direction["length"]
          : animatedDistance;

      Offset nextPosition;
      switch (direction["direction"]) {
        case "straight":
          nextPosition =
              Offset(currentPosition.dx, currentPosition.dy - segmentProgress);
          break;
        case "right":
          nextPosition =
              Offset(currentPosition.dx + segmentProgress, currentPosition.dy);
          break;
        case "left":
          nextPosition =
              Offset(currentPosition.dx - segmentProgress, currentPosition.dy);
          break;
        case "down":
          nextPosition =
              Offset(currentPosition.dx, currentPosition.dy + segmentProgress);
          break;
        default:
          nextPosition = currentPosition;
      }

      path.lineTo(nextPosition.dx, nextPosition.dy);

      animatedDistance -= direction["length"];
      currentPosition = nextPosition;
    }

    canvas.drawPath(path, linePaint);

    // Draw navigation icon at the end of the animated line
    canvas.drawCircle(currentPosition, 8.0, iconPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

Widget customeContainer(
  height,
  width,
  text,
  boarder,
) {
  return Container(
    height: height,
    width: width,
    child: Center(
        child: SizedBox(
      width: height > 50 ? 20 : 50,
      child: Center(
        child: RotatedBox(
          quarterTurns: height > 40 ? 135 : 0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ),
      ),
    )),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            // offset: Offset(4, 10),
            blurRadius: 2,
            color: const Color.fromARGB(255, 235, 235, 235),
          ),
          BoxShadow(
            spreadRadius: 2,
            // offset: Offset(-4, -1),
            blurRadius: 5,
            color: const Color.fromARGB(255, 239, 239, 239),
          ),
        ],
        borderRadius: BorderRadius.circular(boarder),
        color: const Color.fromARGB(255, 222, 222, 222)),
  );
}

Widget sizedBox(height, width) {
  return SizedBox(
    height: height,
    width: width,
  );
}
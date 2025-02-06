import 'package:flutter/material.dart';

import 'package:vocalibb/Pages/Groundfloor.dart';

class FirstFloor extends StatefulWidget {
  final String bookId;
  final String rackId;
  final array;
  const FirstFloor(
      {super.key, required this.bookId, required this.rackId, this.array});

  @override
  State<FirstFloor> createState() => _FirstFloorState();
}

class _FirstFloorState extends State<FirstFloor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;
  final TransformationController _zoom_controller = TransformationController();
  TransformationController _transformationController =
      TransformationController();
  double _minScale = 0.5; // Minimum zoom-out scale
  double _maxScale = 2.0; // Maximum zoom-in scale
  // Define directions as a list of maps with sizes

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //==============================Demo testing navigation line=========================================================

    // final List<Map<String, dynamic>> _directions = [
    //   {"direction": "straight", "length": 360.0},
    //   {"direction": "left", "length": 220.0},
    //   {"direction": "down", "length": 75.0},
    //   {"direction": "left", "length": 75.0},
    //   {"direction": "down", "length": 30.0},
    // ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: InteractiveViewer(
            panEnabled: true, // Enable panning
            boundaryMargin: EdgeInsets.all(5), // Add padding outside
            minScale: 0.2, // Minimum zoom-out scale
            maxScale: 4.0, // Maximum zoom-in scale
            transformationController: _zoom_controller,
            onInteractionEnd: (details) {
              setState(() {
                if (_transformationController.value.getMaxScaleOnAxis() <
                    _minScale) {
                  _transformationController.value = Matrix4.identity()
                    ..scale(_minScale);
                } else if (_transformationController.value.getMaxScaleOnAxis() >
                    _maxScale) {
                  _transformationController.value = Matrix4.identity()
                    ..scale(_maxScale);
                }
              });
            },
            child: Stack(
              children: [
                Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sizedBox(0.0, 30.0),
                                  customeContainer(60.0, 20.0, '', 1.0),
                                  sizedBox(0.0, 30.0),
                                  customeContainer(20.0, 60.0, '', 1.0),
                                  sizedBox(0.0, 30.0),
                                  customeContainer(20.0, 60.0, '47A', 1.0),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  sizedBox(0.0, 60.0),
                                  customeContainer(20.0, 50.0, '', 1.0),
                                  sizedBox(0.0, 30.0),
                                  Column(
                                    children: [
                                      customeContainer(20.0, 60.0, '103B', 1.0),
                                      customeContainer(20.0, 60.0, '103A', 1.0),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      customeContainer(20.0, 60.0, '102B', 1.0),
                                      customeContainer(20.0, 60.0, '102A', 1.0),
                                    ],
                                  ),
                                ],
                              ),
                              sizedBox(10.0, 60.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  sizedBox(0.0, 30.0),
                                  customeContainer(60.0, 20.0, '97A', 1.0),
                                  sizedBox(0.0, 10.0),
                                  Column(
                                    children: [
                                      sizedBox(10.0, 10.0),
                                      customeContainer(20.0, 70.0, '100B', 1.0),
                                      customeContainer(20.0, 70.0, '100A', 1.0),
                                    ],
                                  ),
                                  sizedBox(0.0, 50.0),
                                  Column(
                                    children: [
                                      sizedBox(10.0, 10.0),
                                      customeContainer(20.0, 70.0, '34B', 1.0),
                                      customeContainer(20.0, 70.0, '34A', 1.0),
                                    ],
                                  ),
                                ],
                              ),
                              sizedBox(10.0, 30.0),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  sizedBox(10.0, 30.0),
                                  customeContainer(40.0, 20.0, '', 1.0),
                                  sizedBox(10.0, 30.0),
                                  customeContainer(20.0, 70.0, '', 1.0),
                                  customeContainer(20.0, 70.0, '96A', 1.0),
                                ],
                              )
                            ],
                          ),
                          Column(
                            children: [
                              sizedBox(60.0, 0.0),
                              Container(
                                height: 160,
                                width: 40,
                                color: Colors.blueGrey,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              sizedBox(60.0, 0.0),
                              Container(
                                height: 160,
                                width: 100,
                                color: const Color.fromARGB(140, 96, 125, 139),
                                child: Column(
                                  children: [
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                    sizedBox(5.0, 0.0),
                                    Divider(),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              sizedBox(60.0, 0.0),
                              Container(
                                height: 160,
                                width: 40,
                                color: Colors.blueGrey,
                              )
                            ],
                          ),
                          customeContainer(220.0, 300.0, 'Study Area', 0.0)
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        height: 5,
                        width: 270,
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                      sizedBox(180.0, 0.0),
                      Container(
                        margin: EdgeInsets.only(left: 30),
                        height: 50,
                        width: 700,
                        color: const Color.fromARGB(255, 161, 213, 255),
                        child: Center(
                          child: Text('Ground Floor'),
                        ),
                      )
                    ],
                  ),
                ),
                CustomPaint(
                    painter: NavigationPainter1(
                        progress: _progress.value,
                        directions: widget.array,
                        screenSize: MediaQuery.of(context).size,
                        height: height,
                        width: width),
                    child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NavigationPainter1 extends CustomPainter {
  final double progress;
  final List<Map<String, dynamic>> directions;
  final Size screenSize;
  final double height;
  final double width;
  NavigationPainter1({
    required this.progress,
    required this.directions,
    required this.screenSize,
    required this.height,
    required this.width,
  });

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
        Offset(size.width + width / 1.03, size.height + 405);
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
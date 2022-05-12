import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Cards extends StatefulWidget {
  const Cards({
    Key? key,
    required this.isPressed,
    required this.index,
    required this.type,
    this.points = 0,
    this.stamps = 0,
    required this.id,
    required this.name,
    required this.onTap,
    required this.update,
  }) : super(key: key);

  final bool isPressed;
  final int index;
  final String type;
  final double points;
  final int stamps;
  final String id;
  final String name;

  final VoidCallback onTap;
  final VoidCallback update;

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  bool showfront = true;
  bool delete = false; // to update UI

  @override
  Widget build(BuildContext context) {
    List<Color> c = [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent
    ];
    for (int i = 0; i < 8; i++) {
      if (i < widget.stamps) {
        c[i] = Colors.white;
      }
    }
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showfront != showfront;
        });
      },
      onTap: widget.onTap,
      child: Stack(
        alignment: const Alignment(1, -1),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              // Card Background
              child: Container(
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/LC${(widget.index + 1) % 4}.png'),
                  ),
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: showfront == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // top row
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.local_dining_outlined,
                                      color: Colors.white,
                                    ),
                                    // Barcode button
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showfront == true
                                              ? showfront = false
                                              : showfront = true;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.qr_code_2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Main Content
                              Expanded(
                                child: widget.type == 'stamps'
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 30),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: List.generate(
                                            2,
                                            (index) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      (MediaQuery.of(context)
                                                                  .size
                                                                  .width >=
                                                              400)
                                                          ? 95
                                                          : 80),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: List.generate(
                                                  4,
                                                  (index2) => ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Container(
                                                      color: index == 0
                                                          ? c[index2]
                                                          : c[index2 + 4],
                                                      height: 35,
                                                      width: 35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          '${widget.points.toStringAsFixed(2)} points',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                              ),
                              // bottom data row
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.name,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      widget.id,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      // Main Content for the back of the card
                      : Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    showfront == true
                                        ? showfront = false
                                        : showfront = true;
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            QrImage(
                              data: 'id=${widget.id}',
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
          // Delete Cards
          Visibility(
            visible: widget.isPressed,
            child: GestureDetector(
              onTap: widget.update,
              child: const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}

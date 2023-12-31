import 'package:flutter/material.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:sprite/sprite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Game Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late Offset _offset;
  bool playAnim = false;
  late AnimationController _backgroundController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    _offset = const Offset(0, 0);
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _colorAnimation = ColorTween(
      begin: Colors.indigo,
      end: Colors.blueAccent,
    ).animate(_backgroundController);

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            color: _colorAnimation.value,
            child: child,
          );
        },
        child: const SizedBox(),
      ),
      Positioned.fill(
        child: FloatingBubbles.alwaysRepeating(
          noOfBubbles: 50,
          colorsOfBubbles: const [
            Colors.white,
            Colors.lightBlueAccent,
          ],
          sizeFactor: 0.2,
          opacity: 70,
          speed: BubbleSpeed.slow,
          paintingStyle: PaintingStyle.fill,
          shape: BubbleShape.circle, //This is the default
        ),
      ),
      GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _offset = Offset(
              (_offset.dx + details.delta.dx).clamp(0.0, MediaQuery
                  .of(context)
                  .size
                  .width - 50.0),
              (_offset.dy + details.delta.dy).clamp(0.0, MediaQuery
                  .of(context)
                  .size
                  .height - 50.0),
            );
          });
        },
        child: Container(
        width: 100,
        height: 150,
        margin: EdgeInsets.only(left: _offset.dx, top: _offset.dy),
        child: const Sprite(
          stepTime: 200,
          axis: Axis.horizontal,
          imagePath: "assets/images/sprite.png",
          size: Size(150, 230),
          amount: 10,
        ),
      ),

    ),]
    )
    ,
    );
  }
}

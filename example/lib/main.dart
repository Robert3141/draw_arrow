import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:draw_arrow/draw_arrow.dart';

import 'globals.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          globals.ghost = true;
        },
        onPanUpdate: (details) {
          setState(() {
            globals.tapPos = details.localPosition;
            globals.repaint = true;
          });
        },
        onPanEnd: (details) {
          setState(() {
            globals.ghost = false;
            globals.repaint = true;
          });
        },
        child: CustomPaint(
          painter: UIPainter(),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class UIPainter extends CustomPainter {
  double _abs(double a) {
    return a > 0 ? a : -a;
  }

  @override
  void paint(Canvas canvas, Size size) {
    globals.repaint = false;
    double h = size.height;
    double w = size.width;
    Offset localCentrePos =
        Offset(globals.squarePos.dx * w, globals.squarePos.dy * h);
    Paint painter = Paint()
      ..color = Colors.pink
      ..blendMode = BlendMode.srcOver
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    //circle in centre
    canvas.drawCircle(localCentrePos, 5, painter);

    if (globals.ghost) {
      //tap pos oposite to drawPos
      double x = _abs(globals.tapPos.dx - localCentrePos.dx);
      x = localCentrePos.dx + (globals.tapPos.dx > localCentrePos.dx ? -x : x);
      double y = _abs(globals.tapPos.dy - localCentrePos.dy);
      y = localCentrePos.dy + (globals.tapPos.dy > localCentrePos.dy ? -y : y);
      Offset ghostPos = Offset(x, y);

      //draw
      canvas.drawArrow(
          Offset(globals.squarePos.dx * w, globals.squarePos.dy * h), ghostPos);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    //throw UnimplementedError();
    return globals.repaint;
  }
}

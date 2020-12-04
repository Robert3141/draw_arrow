library draw_arrow;

import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class Draw {
  num abs(num val) {
    return val > 0 ? val : -val;
  }

  ///
  /// BASED OFF https://www.codeproject.com/Questions/125049/Draw-an-arrow-with-big-cap
  ///
  void drawArrow(Canvas canvas, Offset arrowStart, Offset arrowEnd,
      [Paint painter]) {
    double arrowMultiplier = 3;

    //tip of the arrow
    Offset arrowPoint = arrowEnd;

    //determine arrow length
    double arrowLength = sqrt(pow(abs(arrowStart.dx - arrowEnd.dx), 2) +
        pow(abs(arrowStart.dy - arrowEnd.dy), 2));

    //determine arrow angle
    double arrowAngle = atan2(
        abs(arrowStart.dy - arrowEnd.dy), abs(arrowStart.dx - arrowEnd.dx));

    //get the x,y of the back of the point

    //to change from an arrow to a diamond, change the 3
    //in the next if/else blocks to 6

    double pointX, pointY;
    if (arrowStart.dx > arrowEnd.dx) {
      pointX = arrowStart.dx -
          (cos(arrowAngle) * (arrowLength - (3 * arrowMultiplier)));
    } else {
      pointX = cos(arrowAngle) * (arrowLength - (3 * arrowMultiplier)) +
          arrowStart.dx;
    }

    if (arrowStart.dy > arrowEnd.dy) {
      pointY = arrowStart.dy -
          (sin(arrowAngle) * (arrowLength - (3 * arrowMultiplier)));
    } else {
      pointY = (sin(arrowAngle) * (arrowLength - (3 * arrowMultiplier))) +
          arrowStart.dy;
    }

    Offset arrowPointBack = Offset(pointX, pointY);

    //get the secondary angle of the left tip
    double angleB =
        atan2((3 * arrowMultiplier), (arrowLength - (3 * arrowMultiplier)));

    double angleC =
        pi * (90 - (arrowAngle * (180 / pi)) - (angleB * (180 / pi))) / 180;

    //get the secondary length
    double secondaryLength = (3 * arrowMultiplier) / sin(angleB);

    if (arrowStart.dx > arrowEnd.dx) {
      pointX = arrowStart.dx - (sin(angleC) * secondaryLength);
    } else {
      pointX = (sin(angleC) * secondaryLength) + arrowStart.dx;
    }

    if (arrowStart.dy > arrowEnd.dy) {
      pointY = arrowStart.dy - (cos(angleC) * secondaryLength);
    } else {
      pointY = (cos(angleC) * secondaryLength) + arrowStart.dy;
    }

    //get the left point
    Offset arrowPointLeft = Offset(pointX, pointY);

    //move to the right point
    angleC = arrowAngle - angleB;

    if (arrowStart.dx > arrowEnd.dx) {
      pointX = arrowStart.dx - (cos(angleC) * secondaryLength);
    } else {
      pointX = (cos(angleC) * secondaryLength) + arrowStart.dx;
    }

    if (arrowStart.dy > arrowEnd.dy) {
      pointY = arrowStart.dy - (sin(angleC) * secondaryLength);
    } else {
      pointY = (sin(angleC) * secondaryLength) + arrowStart.dy;
    }

    Offset arrowPointRight = Offset(pointX, pointY);

    //create the point list
    List<Offset> arrowPoints = [
      arrowPoint,
      arrowPointLeft,
      arrowPointBack,
      arrowPointRight
    ];
    Path arrowPath = Path()..addPolygon(arrowPoints, true);

    //define paint
    Paint paint = painter ?? Paint();

    //draw

    canvas.drawPath(arrowPath, paint);
  }
}

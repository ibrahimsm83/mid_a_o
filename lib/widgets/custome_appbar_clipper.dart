import 'package:flutter/material.dart';

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.9978857);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, 0);
    path_0.quadraticBezierTo(
        size.width, size.height * 0.7500000, size.width, size.height);
    path_0.quadraticBezierTo(size.width * 0.9759200, size.height * 0.7426286,
        size.width * 0.8976267, size.height * 0.7508571);
    path_0.quadraticBezierTo(size.width * 0.3077333, size.height * 0.7502286,
        size.width * 0.1159467, size.height * 0.7495429);
    path_0.quadraticBezierTo(size.width * 0.0166933, size.height * 0.7401714, 0,
        size.height * 0.9978857);
    path_0.close();
    return path_0;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

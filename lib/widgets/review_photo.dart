import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sizer/sizer.dart';

class ReviewPhotos extends StatefulWidget {
  ReviewPhotos(
      {Key? key,
      required this.photo,
      required this.onTap,
      this.realOnly = false})
      : super(key: key);
  final dynamic photo;
  final VoidCallback onTap;
  final bool realOnly;

  @override
  _ReviewPhotosState createState() => _ReviewPhotosState();
}

class _ReviewPhotosState extends State<ReviewPhotos> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.5.w,
      height: 16.5.w,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              border: Border.all(
                color: Color(0xFFC9352E),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: widget.photo is String
                  ? Image.network(widget.photo, fit: BoxFit.cover)
                  : Image.file(widget.photo, fit: BoxFit.cover),
            ),

            //  widget.photo is String
            //     ? Image.network(widget.photo, fit: BoxFit.cover,)
            //     : Image.file(widget.photo, fit: BoxFit.cover),
          ),
          Positioned(
            right: -8,
            top: -10,
            child: InkWell(
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: DottedBorder(
                  color: Colors.white,
                  borderType: BorderType.Circle,
                  radius: Radius.circular(6),
                  child: FittedBox(
                    child: Container(
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset:
                                Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            FlutterIcons.close_ant,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}

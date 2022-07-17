import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:sizer/sizer.dart';

class AddPhotos extends StatelessWidget {
  const AddPhotos({Key? key, required this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 16.5.w,
      padding: EdgeInsets.all(0),
      onPressed: onPressed,
      icon: Container(
        width: 16.5.w,
        height: 16.5.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: AppColors.SELECTION_COLOR,
        ),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Icon(
                  FlutterIcons.plus_fea,
                  size: 30,
                  color:  Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Add Photos",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

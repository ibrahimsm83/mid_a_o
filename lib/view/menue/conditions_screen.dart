import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/widgets/common_widget.dart';
import 'package:mao/widgets/custome_appbar_clipper.dart';
import 'package:flutter/services.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:sizer/sizer.dart';

class ConditionsScreen extends StatelessWidget {
  const ConditionsScreen({
    Key? key,
    required this.title,
    required this.assetPath,
  }) : super(key: key);
  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.BACKGROUND_BLUE_HAZE,
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  iconWidget(context),
                  Spacer(
                    flex: 7,
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(
                    flex: 11,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: Platform.isIOS
                  ? (MediaQuery.of(context).size.height * 0.15 -
                      MediaQuery.of(context).size.height * 0.13 * 0.3)
                  : 18.h,
            ),
            Spacer(),
            Container(
              width: 89.3.w,
              height: 80.h,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Container(
                  child: FutureBuilder<String>(
                      future: rootBundle.loadString(assetPath),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return HtmlWidget(
                            snapshot.data!,
                          );
                        } else {
                          return Container(
                            // width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        }
                      }),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

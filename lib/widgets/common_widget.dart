import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:mao/utils/index_utils.dart';

Widget iconWidget(BuildContext context) => IconButton(
      icon: Icon(
        Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
        color: Colors.white,
      ),
      onPressed: () => AppNavigation.navigatorPop(context),
    );

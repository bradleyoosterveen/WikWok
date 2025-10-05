import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

Widget wCircularProgress = Center(
  child: FCircularProgress.loader(
    style: (style) => style.copyWith(
      iconStyle: style.iconStyle.copyWith(
        size: 32,
      ),
    ),
  ),
);

import 'package:flutter/material.dart';

Widget mySizedBox({double? height}) {
  return SizedBox(
    height: height ?? 20,
  );
}

Widget myEmptySizedBox() {
  return const SizedBox.shrink(
    
  );
}


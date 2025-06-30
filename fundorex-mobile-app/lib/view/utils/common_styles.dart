import 'package:flutter/cupertino.dart';

double screenPadding = 25;

sizedBox20() {
  return const SizedBox(
    height: 20,
  );
}

sizedBoxCustom(double value) {
  return SizedBox(
    height: value,
  );
}

var physicsCommon = const BouncingScrollPhysics();

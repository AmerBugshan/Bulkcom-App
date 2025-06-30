import 'package:flutter/material.dart';

class BottomNavService with ChangeNotifier {
  int currentIndex = 0;

  setCurrentIndex(value) {
    currentIndex = value;
    notifyListeners();
  }
}

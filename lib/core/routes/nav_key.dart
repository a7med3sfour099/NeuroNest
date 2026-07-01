import 'package:flutter/material.dart';

class NavKey {
  /// A globally accessible key that allows navigation from anywhere in the app,
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
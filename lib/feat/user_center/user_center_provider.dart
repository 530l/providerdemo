import 'package:flutter/material.dart';

class UserCenterProvider extends ChangeNotifier {

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void updateLoginStatus(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners(); // 通知监听者数据变化
  }
}

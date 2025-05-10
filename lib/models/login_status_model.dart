import 'package:flutter/material.dart';

/// 登录状态模型
/// 继承自ChangeNotifier，可以通过notifyListeners()通知监听者数据变化
class LoginStatusModel extends ChangeNotifier {
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void updateLoginStatus(bool isLogin) {
    _isLogin = isLogin;
    notifyListeners(); // 通知监听者数据变化
  }
}

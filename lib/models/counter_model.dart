import 'package:flutter/material.dart';

/// 计数器模型
/// 用于演示基本的ChangeNotifier用法
class CounterModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners(); // 通知监听者数据变化
  }

  void decrement() {
    if (_count > 0) {
      _count--;
      notifyListeners(); // 通知监听者数据变化
    }
  }

  void reset() {
    _count = 0;
    notifyListeners(); // 通知监听者数据变化
  }
}

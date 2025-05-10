import 'package:flutter/material.dart';

/// 用户模型
/// 用于演示Selector的使用，可以选择性地监听特定属性的变化
class UserModel with ChangeNotifier {
  String _name;
  int _age;
  String _email;

  UserModel({
    String name = 'CoderPig',
    int age = 30,
    String email = 'coderpig@example.com',
  }) : _name = name,
       _age = age,
       _email = email;

  String get name => _name;
  int get age => _age;
  String get email => _email;

  set name(String newName) {
    _name = newName;
    notifyListeners(); // 通知监听者数据已更改
  }

  set age(int newAge) {
    _age = newAge;
    notifyListeners(); // 通知监听者数据已更改
  }

  set email(String newEmail) {
    _email = newEmail;
    notifyListeners(); // 通知监听者数据已更改
  }
}

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

/// Selector示例页面
/// 展示如何使用Selector进行细粒度的状态监听，只监听特定属性的变化
class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selector示例'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildIntroductionCard(),
              const SizedBox(height: 16),
              _buildNameSelectorCard(),
              const SizedBox(height: 16),
              _buildAgeSelectorCard(),
              const SizedBox(height: 16),
              _buildEmailSelectorCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建介绍卡片
  Widget _buildIntroductionCard() {
    return _buildCard(
      title: 'Selector的作用',
      description: 'Selector可以选择性地监听模型中的特定属性，当只有该属性变化时才重建Widget，提高性能。',
      content: Consumer<UserModel>(
        builder: (context, user, _) {
          print('显示当前用户信息 Consumer'); // 用于演示
          return _buildInfoContainer(
            color: Colors.blue.shade50,
            children: [
              Text('姓名: ${user.name}'),
              Text('年龄: ${user.age}'),
              Text('邮箱: ${user.email}'),
            ],
          );
        },
      ),
    );
  }

  /// 构建姓名选择器卡片
  Widget _buildNameSelectorCard() {
    return _buildCard(
      title: '1. 只监听name属性',
      description: '只有name属性变化时才会重建此Widget',
      content: Selector<UserModel, String>(
        // 选择器函数，从UserModel中提取name属性
        selector: (_, model) => model.name,
        // 构建器函数，只有当name变化时才会调用
        builder: (context, name, __) {
          print('name Selector重建'); // 用于演示
          return Column(
            children: [
              _buildAttributeRow(
                icon: Icons.person,
                color: Colors.green,
                backgroundColor: Colors.green.shade50,
                label: '姓名: $name',
              ),
              const SizedBox(height: 8),
              _buildEditButton(
                onPressed: () {
                  //虽然 context.read<T>() 和 Provider.of<T>(context, listen: false) 都能实现相同的功能，
                  // 但 context.read<T>() 提供了一种更为清晰、直接的方式来表达你只想读取数据而非监听变化的意图。
                  // 因此，在新项目或代码重构时，建议优先考虑使用 context.read<T>()。
                  // 修改name属性
                  context.read<UserModel>().name =
                      '小猪佩奇${Random().nextInt(100)}';
                },
                label: '修改姓名',
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建年龄选择器卡片
  Widget _buildAgeSelectorCard() {
    return _buildCard(
      title: '2. 只监听age属性',
      description: '只有age属性变化时才会重建此Widget',
      content: Selector<UserModel, int>(
        // 选择器函数，从UserModel中提取age属性
        selector: (_, model) => model.age,
        // 构建器函数，只有当age变化时才会调用
        builder: (context, age, __) {
          print('age Selector重建'); // 用于演示
          return Column(
            children: [
              _buildAttributeRow(
                icon: Icons.cake,
                color: Colors.orange,
                backgroundColor: Colors.orange.shade50,
                label: '年龄: $age',
              ),
              const SizedBox(height: 8),
              _buildEditButton(
                onPressed: () {
                  // 修改age属性
                  context.read<UserModel>().age = Random().nextInt(100);
                },
                label: '修改年龄',
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建邮箱选择器卡片
  Widget _buildEmailSelectorCard() {
    return _buildCard(
      title: '3. 只监听email属性',
      description: '只有email属性变化时才会重建此Widget',
      content: Selector<UserModel, String>(
        // 选择器函数，从UserModel中提取email属性
        selector: (_, model) => model.email,
        // 构建器函数，只有当email变化时才会调用
        builder: (context, email, __) {
          print('email Selector重建'); // 用于演示
          return Column(
            children: [
              _buildAttributeRow(
                icon: Icons.email,
                color: Colors.purple,
                backgroundColor: Colors.purple.shade50,
                label: '邮箱: $email',
              ),
              const SizedBox(height: 8),
              _buildEditButton(
                onPressed: () {
                  // 修改email属性
                  context.read<UserModel>().email =
                      'peppa@example.com${Random().nextInt(100)}';
                },
                label: '修改邮箱',
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建卡片通用方法
  Widget _buildCard({
    required String title,
    required String description,
    required Widget content,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  /// 构建信息容器
  Widget _buildInfoContainer({
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 构建属性行
  Widget _buildAttributeRow({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required String label,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: textStyle ?? const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// 构建编辑按钮
  Widget _buildEditButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.edit),
      label: Text(label),
    );
  }
}

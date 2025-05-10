import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';
import '../models/user_model.dart';

/// 组合数据模型
/// 用于演示ProxyProvider如何组合多个Provider的数据
// 修改了 ProxyProvider 页面中的链式依赖部分，解决了 Provider 依赖关系的问题。
// 具体改动如下：
// 1. 将原来直接使用 ProxyProvider<CombinedDataModel, String> 的方式改为了嵌套结构
// 2. 首先使用 Consumer<CombinedDataModel> 获取组合数据模型
// 3. 在 Consumer 的 builder 函数内部使用 ProxyProvider0<String> 创建新的 Provider
// 4. 这样确保了 ProxyProvider0 能够在正确的上下文中访问到 CombinedDataModel
// 这种结构解决了之前的错误："Could not find the correct Provider
// "，因为现在 String 类型的 Provider 是在已经能够访问到 CombinedDataModel 的上下文中创建的。
class CombinedDataModel {
  final String userName;
  final int count;

  CombinedDataModel(this.userName, this.count);

  @override
  String toString() => '$userName的计数：$count';
}

/// ProxyProvider示例页面
/// 展示如何使用ProxyProvider组合多个Provider的数据
class ProxyProviderPage extends StatelessWidget {
  const ProxyProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProxyProvider示例'),
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
              _buildBasicUsageCard(),
              const SizedBox(height: 16),
              _buildModifyDependencyCard(context),
              const SizedBox(height: 16),
              _buildChainDependencyCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建ProxyProvider介绍卡片
  /// 展示ProxyProvider的基本概念和作用
  Widget _buildIntroductionCard() {
    return _buildCard(
      title: 'ProxyProvider的作用',
      description:
          'ProxyProvider可以组合多个Provider的数据，并基于它们的输出创建新的数据。当依赖的Provider数据变化时，ProxyProvider也会更新。',
    );
  }

  /// 构建ProxyProvider基本用法卡片
  /// 展示如何使用ProxyProvider2组合UserModel和CounterModel的数据
  Widget _buildBasicUsageCard() {
    return _buildCard(
      title: '1. 基本用法',
      description: '使用ProxyProvider2组合UserModel和CounterModel的数据',
      content: ProxyProvider2<UserModel, CounterModel, CombinedDataModel>(
        update: (context, user, counter, previous) {
          return CombinedDataModel(user.name, counter.count);
        },
        child: Consumer<CombinedDataModel>(
          builder: (context, combinedData, child) {
            return _buildDataContainer(
              icon: Icons.merge_type,
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.shade50,
              title: combinedData.toString(),
              subtitle: '当用户名或计数变化时，此组件会自动更新',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );
  }

  /// 构建修改依赖数据卡片
  /// 提供修改用户名和增加计数的按钮
  Widget _buildModifyDependencyCard(BuildContext context) {
    return _buildCard(
      title: '2. 修改依赖数据',
      description: '修改UserModel或CounterModel的数据，观察ProxyProvider的更新',
      content: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // 修改用户名
                context.read<UserModel>().name = '小猪佩奇${DateTime.now().second}';
              },
              icon: const Icon(Icons.person),
              label: const Text('修改用户名'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // 增加计数
                context.read<CounterModel>().increment();
              },
              icon: const Icon(Icons.add),
              label: const Text('增加计数'),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建ProxyProvider链式依赖卡片
  /// 展示如何让一个ProxyProvider依赖另一个ProxyProvider，实现数据的多级转换
  Widget _buildChainDependencyCard() {
    return _buildCard(
      title: '3. 链式依赖',
      description: '一个ProxyProvider可以依赖另一个ProxyProvider',
      content: ProxyProvider2<UserModel, CounterModel, CombinedDataModel>(
        update: (context, user, counter, previous) {
          return CombinedDataModel(user.name, counter.count);
        },
        child: Consumer<CombinedDataModel>(
          builder: (context, combinedData, child) {
            return ProxyProvider0<String>(
              update: (context, previous) {
                return '高级组合: ${combinedData.toString().toUpperCase()}';
              },
              child: Consumer<String>(
                builder: (context, formattedData, child) {
                  return _buildDataContainer(
                    icon: Icons.format_color_text,
                    iconColor: Colors.purple,
                    backgroundColor: Colors.purple.shade50,
                    title: formattedData,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// 构建通用卡片容器
  /// 用于展示标题、描述和内容的卡片布局
  Widget _buildCard({
    required String title,
    required String description,
    Widget? content,
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
            if (content != null) ...[const SizedBox(height: 16), content],
          ],
        ),
      ),
    );
  }

  /// 构建数据展示容器
  /// 用于美观地展示带图标和文本的数据信息
  Widget _buildDataContainer({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    String? subtitle,
    double fontSize = 20,
    TextAlign? textAlign,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: iconColor),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
            textAlign: textAlign,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 16),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
              textAlign: textAlign,
            ),
          ],
        ],
      ),
    );
  }
}

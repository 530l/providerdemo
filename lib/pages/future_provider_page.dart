import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// FutureProvider示例页面
/// 展示如何使用FutureProvider处理异步数据
class FutureProviderPage extends StatelessWidget {
  const FutureProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FutureProvider示例'),
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
              _buildErrorHandlingCard(),
              const SizedBox(height: 16),
              _buildRefreshDataCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建介绍卡片
  Widget _buildIntroductionCard() {
    return _buildCard(
      title: 'FutureProvider的作用',
      description: 'FutureProvider用于处理异步数据，适用于一次性的异步操作，如网络请求、文件读取等。',
    );
  }

  /// 构建基本用法示例卡片
  Widget _buildBasicUsageCard() {
    return _buildCard(
      title: '1. 基本用法',
      description: '模拟网络请求获取数据',
      content: FutureProvider<String>(
        initialData: '加载中...',
        create: (context) => fetchData(),
        child: Consumer<String>(
          builder: (context, data, child) {
            return _buildDataContainer(
              icon: Icons.cloud_download,
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.shade50,
              data: data,
              textColor: Colors.black,
            );
          },
        ),
      ),
    );
  }

  /// 构建错误处理示例卡片
  Widget _buildErrorHandlingCard() {
    return _buildCard(
      title: '2. 错误处理',
      description: '模拟网络请求失败的情况',
      content: FutureProvider<String>(
        initialData: '加载中...',
        create: (context) => fetchDataWithError(),
        catchError: (context, error) => '加载失败: ${error.toString()}',
        child: Consumer<String>(
          builder: (context, data, child) {
            final isError = data.startsWith('加载失败');
            return _buildDataContainer(
              icon: isError ? Icons.error : Icons.check_circle,
              iconColor: isError ? Colors.red : Colors.green,
              backgroundColor:
                  isError ? Colors.red.shade50 : Colors.green.shade50,
              data: data,
              textColor: isError ? Colors.red : Colors.green,
            );
          },
        ),
      ),
    );
  }

  /// 构建刷新数据示例卡片
  Widget _buildRefreshDataCard() {
    return _buildCard(
      title: '3. 刷新数据',
      description: '通过重建FutureProvider来刷新数据',
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              // 使用key来强制重建FutureProvider
              FutureProvider<String>(
                key: ValueKey(DateTime.now().toString()),
                initialData: '加载中...',
                create: (context) => fetchRandomData(),
                child: Consumer<String>(
                  builder: (context, data, child) {
                    return _buildDataContainer(
                      icon: Icons.refresh,
                      iconColor: Colors.purple,
                      backgroundColor: Colors.purple.shade50,
                      data: data,
                      textColor: Colors.black,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  // 强制重建页面来刷新FutureProvider
                  setState(() {});
                },
                icon: const Icon(Icons.refresh),
                label: const Text('刷新数据'),
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

  /// 构建数据容器通用方法
  Widget _buildDataContainer({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String data,
    required Color textColor,
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
            data,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 模拟网络请求获取数据
  Future<String> fetchData() async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 2));
    return '这是从服务器获取的数据~~~~~~~~';
  }

  /// 模拟网络请求失败
  Future<String> fetchDataWithError() async {
    await Future.delayed(const Duration(seconds: 2));
    throw Exception('网络连接超时');
  }

  /// 模拟获取随机数据
  Future<String> fetchRandomData() async {
    await Future.delayed(const Duration(seconds: 1));
    final random = DateTime.now().millisecondsSinceEpoch % 1000;
    return '随机数据: $random';
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

/// StreamProvider示例页面
/// 展示如何使用StreamProvider处理流式数据
class StreamProviderPage extends StatefulWidget {
  const StreamProviderPage({super.key});

  @override
  State<StreamProviderPage> createState() => _StreamProviderPageState();
}

class _StreamProviderPageState extends State<StreamProviderPage> {
  // 用于控制数据流的控制器
  StreamController<int>? _counterController;
  StreamController<String>? _messageController;
  Timer? _timer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // 初始化控制器
    _counterController = StreamController<int>.broadcast();
    _messageController = StreamController<String>.broadcast();

    // 启动定时器，每秒更新一次数据
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter++;
      _counterController?.add(_counter);
      _messageController?.add('实时消息 #$_counter - ${DateTime.now().second}秒');
    });
  }

  @override
  void dispose() {
    // 清理资源
    _timer?.cancel();
    _counterController?.close();
    _messageController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamProvider示例'),
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
              _buildMultipleConsumersCard(),
              const SizedBox(height: 16),
              _buildManualMessageCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建介绍卡片
  Widget _buildIntroductionCard() {
    return _buildCard(
      title: 'StreamProvider的作用',
      description: 'StreamProvider用于处理流式数据，适用于需要持续更新的数据，如实时消息、传感器数据等。',
    );
  }

  /// 构建基本用法示例卡片
  Widget _buildBasicUsageCard() {
    return _buildCard(
      title: '1. 基本用法',
      description: '使用StreamProvider监听计数器流',
      content: StreamProvider<int>.value(
        initialData: 0,
        value: _counterController?.stream,
        child: Consumer<int>(
          builder: (context, count, child) {
            return _buildDataContainer(
              icon: Icons.timer,
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.shade50,
              title: '实时计数: $count',
              subtitle: '(每秒自动更新)',
              subtitleColor: Colors.grey.shade700,
            );
          },
        ),
      ),
    );
  }

  /// 构建多个消费者示例卡片
  Widget _buildMultipleConsumersCard() {
    return _buildCard(
      title: '2. 多个消费者',
      description: '多个Widget可以同时监听同一个流',
      content: StreamProvider<String>.value(
        initialData: '等待消息...',
        value: _messageController?.stream,
        child: Column(
          children: [
            // 第一个消费者
            Consumer<String>(
              builder: (context, message, child) {
                return _buildMessageRow(
                  icon: Icons.message,
                  iconColor: Colors.green,
                  backgroundColor: Colors.green.shade50,
                  prefix: '消费者1: ',
                  message: message,
                );
              },
            ),
            const SizedBox(height: 8),
            // 第二个消费者
            Consumer<String>(
              builder: (context, message, child) {
                return _buildMessageRow(
                  icon: Icons.notifications,
                  iconColor: Colors.orange,
                  backgroundColor: Colors.orange.shade50,
                  prefix: '消费者2: ',
                  message: message,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 构建手动发送消息示例卡片
  Widget _buildManualMessageCard() {
    return _buildCard(
      title: '3. 手动发送消息',
      description: '向流中手动添加数据',
      content: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _counterController?.add(_counter + 10);
              },
              icon: const Icon(Icons.add),
              label: const Text('计数+10'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _messageController?.add('手动消息: ${DateTime.now().toString()}');
              },
              icon: const Icon(Icons.send),
              label: const Text('发送消息'),
            ),
          ),
        ],
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
    required String title,
    String? subtitle,
    Color? subtitleColor,
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              style: TextStyle(color: subtitleColor ?? Colors.grey),
            ),
        ],
      ),
    );
  }

  /// 构建消息行通用方法
  Widget _buildMessageRow({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String prefix,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$prefix$message',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

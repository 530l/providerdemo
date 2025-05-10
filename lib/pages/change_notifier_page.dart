import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';

/// ChangeNotifier Provider示例页面
/// 展示基本的Provider用法，包括Consumer和Provider.of的使用方式
class ChangeNotifierPage extends StatelessWidget {
  const ChangeNotifierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChangeNotifier Provider'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildConsumerExample(),
              const SizedBox(height: 16),
              _buildConsumerWithChildExample(),
              const SizedBox(height: 16),
              _buildProviderOfExample(),
              const SizedBox(height: 16),
              _buildContextExtensionExample(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建使用Consumer监听的示例卡片
  Widget _buildConsumerExample() {
    return _buildExampleCard(
      title: '1. 使用Consumer监听',
      description: 'Consumer会在每次状态变化时重建，适用于需要实时响应状态变化的场景',
      content: Consumer<CounterModel>(
        builder: (context, counter, child) {
          return _buildCounterControls(counter);
        },
      ),
    );
  }

  /// 构建使用Consumer的child参数优化性能的示例卡片
  Widget _buildConsumerWithChildExample() {
    return _buildExampleCard(
      title: '2. 使用Consumer的child参数优化性能',
      description: 'child参数中的Widget不会在状态变化时重建，适用于包含不依赖状态的复杂UI',
      content: Consumer<CounterModel>(
        builder: (context, counter, child) {
          if (kDebugMode) {
            print('只有这部分会重建');
          } // 用于演示
          return Column(
            children: [
              Text(
                '当前计数: ${counter.count}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: counter.decrement,
                    child: const Text('减少'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: counter.increment,
                    child: const Text('增加'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 使用child参数传入的Widget
              child!,
            ],
          );
        },
        // 这部分不会在状态变化时重建
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade200,
          child: const Text(
            '这部分UI不会在计数变化时重建，提高性能',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      ),
    );
  }

  /// 构建使用Provider.of获取数据的示例卡片
  Widget _buildProviderOfExample() {
    return _buildExampleCard(
      title: '3. 使用Provider.of获取数据',
      description: '设置listen: false时不会触发重建，适用于只需读取数据的场景',
      content: Builder(
        builder: (context) {
          //todo 不监听变化，只读取当前值
          //当你使用这种方式获取 CounterModel 时，listen 参数被设置为 false。
          // 这意味着该部件不会监听 CounterModel 的变化。即使 CounterModel 发生了改变，
          // 这个部件也不会自动重新构建以反映这些变化。
          // 因此，如果你在这个部件中直接使用 CounterModel 的数据而不监听其变化，
          // 那么 UI 将不会更新以响应这些变化。
          final counter = Provider.of<CounterModel>(context, listen: false);
          return Column(
            children: [
              Text(
                '当前计数: ${counter.count}',
                style: const TextStyle(fontSize: 20),
              ),
              const Text('(这个数值不会自动更新)', style: TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      counter.increment();
                      // 手动刷新UI的方法
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('计数已增加，但UI不会自动更新'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text('增加(UI不更新)'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建使用context扩展方法的示例卡片
  Widget _buildContextExtensionExample() {
    return _buildExampleCard(
      title: '4. 使用context扩展方法',
      description: 'context.read()和context.watch()是Provider.of的简化写法',
      content: Builder(
        builder: (context) {
          //Provider.of<CounterModel>(context) 或 context.watch<CounterModel>()
          // 当你省略 listen 参数或直接使用 context.watch<CounterModel>() 时，
          // 默认情况下 listen 参数是 true。这意味着该部件会监听 CounterModel 的变化。
          // 如果 CounterModel 发生任何变化，
          // Flutter 框架会自动重新构建那些正在监听变化的部件，从而更新 UI 以反映最新的状态。
          // 等同于Provider.of<CounterModel>(context)
          // final counter = context.watch<CounterModel>();
          // final counter = Provider.of<CounterModel>(context);
          //todo provider 不允许在构建的时候监听，因为你点击的时候，这个部件正在构建，
          final counter = Provider.of<CounterModel>(context, listen: true);
          return Column(
            children: [
              Text(
                '使用context.watch(): ${counter.count}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => counter.reset(),
                child: const Text('重置计数'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 构建示例卡片的通用方法
  Widget _buildExampleCard({
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

  /// 构建计数器控制UI
  Widget _buildCounterControls(CounterModel counter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: counter.decrement,
          child: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('${counter.count}', style: const TextStyle(fontSize: 24)),
        ),
        ElevatedButton(
          onPressed: counter.increment,
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

# providerdemo

# Flutter Provider 示例项目实现

## 已创建的文件

1. 模型类
    - user_model.dart - 用户模型，用于演示 Selector 的细粒度监听
    - counter_model.dart - 计数器模型，用于演示基本的 ChangeNotifier 用法
    - login_status_model.dart - 登录状态模型，用于演示状态管理
2. 主应用程序
    - 更新了 main.dart ，设置了 MultiProvider 并配置了路由系统
3. 示例页面
    - home_page.dart - 首页，展示不同 Provider 示例的导航菜单
    - change_notifier_page.dart - 展示基本的 Provider 用法，包括 Consumer 和 Provider.of
    - selector_page.dart - 展示 Selector 的细粒度状态监听
    - future_provider_page.dart - 展示 FutureProvider 处理异步数据
    - stream_provider_page.dart - 展示 StreamProvider 处理流式数据
    - proxy_provider_page.dart - 展示 ProxyProvider 组合多个 Provider 的数据

## 实现的功能

1. 基础 Provider 用法
    - 使用 ChangeNotifierProvider 提供状态
    - 使用 Consumer 监听状态变化
    - 使用 Provider.of 获取状态数据
    - 使用 context.read() 和 context.watch() 扩展方法
2. Selector 细粒度监听
    - 只监听特定属性的变化
    - 提高性能，避免不必要的重建
3. 异步数据处理
    - 使用 FutureProvider 处理一次性异步操作
    - 处理异步错误和加载状态
4. 流式数据处理
    - 使用 StreamProvider 处理持续更新的数据
    - 多个消费者同时监听同一个流
5. 组合 Provider
    - 使用 ProxyProvider 组合多个 Provider 的数据
    - 链式依赖，一个 ProxyProvider 依赖另一个 ProxyProvider

-------------------------------------------------------
context.watch<T>()               ✅ 会监听变化 ， 自动 rebuild 用于 UI 层显示状态
Provider.of<T>(context)          ✅ 等同于 watch， 较旧写法
context.read<T>()                     ❌ 不监听变化， 用于事件触发、方法调用
Provider.of<T>(context,listen: false) ❌ 不监听变化 类似于 read
-------------------------------------------------------

## ChangeNotifierProxyProvider

用途：

      用于创建一个新的 ChangeNotifier 对象，这个对象依赖于其他一个或多个 Provider 提供的数据。
      特别适合当你需要根据其他 Provider 的数据变化来更新 UI，并且希望在数据变化时能够主动通知监听者（如 UI 组件）。

特点：

      继承自 ChangeNotifier：新创建的对象通常会继承自 ChangeNotifier，
      这意味着它可以调用 notifyListeners() 来通知所有监听者数据发生了变化。
      自动刷新UI：当依赖的 Provider 数据发生变化时，ChangeNotifierProxyProvider 会重新计算新的组合数据，
      并通过调用 notifyListeners() 来触发 UI 更新。

使用场景：

    当你需要一个组合模型不仅依赖于其他 Provider 的数据，还需要能够响应这些数据的变化并自动通知 UI 进行更新时。

ChangeNotifierProxyProvider2<UserModel, CounterModel, CombinedDataModel>(
create: (_) => CombinedDataModel('', 0),
update: (context, userModel, counterModel, combinedData) {
combinedData?.userName = userModel.name;
combinedData?.count = counterModel.count;
return combinedData!;
},
child: YourWidget(),
);

## ProxyProvider

用途：

      更通用的形式，用于基于两个或更多 Provider 创建任意类型的对象。生成的对象不需要是 ChangeNotifier 的子类。
      适用于仅需组合数据而不关心是否需要通知 UI 更新的情况。

特点：

      灵活性高：不局限于创建 ChangeNotifier 子类，可以返回任何类型的对象。
      手动管理UI更新：由于返回的对象不是 ChangeNotifier，所以不会主动触发 UI 更新。
      如果需要 UI 更新，则需要通过 Consumer 或 Selector 等方式手动监听和处理。

使用场景：

      当你只需要简单地组合数据，并且不需要这个组合后的数据模型管理状态或主动通知 UI 更新时。

ProxyProvider2<UserModel, CounterModel, CombinedDataModel>(
create: (_) => CombinedDataModel('', 0),
update: (context, userModel, counterModel, previous) =>
CombinedDataModel(userModel.name, counterModel.count),
child: Consumer<CombinedDataModel>(
builder: (context, combinedData, child) {
return Text('${combinedData.userName} 的计数是 ${combinedData.count}');
},
),
);

## ChangeNotifierProxyProvider / ProxyProvider 都类型 Rxjava 中的.zip操作符。

特性/类型 ChangeNotifierProxyProvider ProxyProvider
适用场景 需要响应数据变化并自动通知 UI 更新 只需简单组合数据，无需主动通知 UI 更新
返回对象类型 必须继承自 ChangeNotifier 可以是任意类型的对象
UI更新机制 自动通过 notifyListeners() 触发 需要手动监听（例如通过 Consumer 或 Selector）
复杂度 较高，涉及状态管理和通知机制 较低，仅涉及数据组合

## ChangeNotifierProxyProvider / ProxyProvider 都类型 Rxjava 中的.zip操作符。
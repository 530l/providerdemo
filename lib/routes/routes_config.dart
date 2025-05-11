import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/change_notifier_page.dart';
import '../pages/selector_page.dart';
import '../pages/future_provider_page.dart';
import '../pages/stream_provider_page.dart';
import '../pages/proxy_provider_page.dart';
import '../feat/user_center/user_center_view.dart';

// 路由常量
const String ROUTE_ROOT = '/';
const String ROUTE_CHANGE_NOTIFIER = '/change_notifier';
const String ROUTE_SELECTOR = '/selector';
const String ROUTE_FUTURE_PROVIDER = '/future_provider';
const String ROUTE_STREAM_PROVIDER = '/stream_provider';
const String ROUTE_PROXY_PROVIDER = '/proxy_provider';
const String ROUTE_USER_CENTER = '/user_centerPage';

// 路由配置表
final Map<String, WidgetBuilder> routes = {
  ROUTE_ROOT: (context) => const HomePage(),
  ROUTE_CHANGE_NOTIFIER: (context) => const ChangeNotifierPage(),
  ROUTE_SELECTOR: (context) => const SelectorPage(),
  ROUTE_FUTURE_PROVIDER: (context) => const FutureProviderPage(),
  ROUTE_STREAM_PROVIDER: (context) => const StreamProviderPage(),
  ROUTE_PROXY_PROVIDER: (context) => const ProxyProviderPage(),
  ROUTE_USER_CENTER: (context) => const UserCenterPage(),
};

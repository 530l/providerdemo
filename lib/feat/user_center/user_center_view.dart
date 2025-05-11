import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_center_provider.dart';

class UserCenterPage extends StatelessWidget {
  const UserCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => UserCenterProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    print("hhhhhhhhhhhh");
    final provider = context.read<UserCenterProvider>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<UserCenterProvider>(
              builder: (context, counter, child) {
                return Text(
                  "isLogin= ${counter.isLogin}",
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                bool temp = !provider.isLogin;
                provider.updateLoginStatus(temp);
              },
              child: const Text("点我，获取登录状态", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

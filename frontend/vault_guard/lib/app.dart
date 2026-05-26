import 'package:flutter/material.dart';

import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'multi_bloc_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Security Control',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

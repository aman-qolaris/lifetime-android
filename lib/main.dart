import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// These will show errors until we build them in Step 3 and Step 6
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // ProviderScope is required for Riverpod state management
    const ProviderScope(
      child: LifetimeMembershipApp(),
    ),
  );
}

class LifetimeMembershipApp extends StatelessWidget {
  const LifetimeMembershipApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil for responsive and adaptive UI sizing
    // The designSize is based on a standard modern phone screen (390x844)
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Lifetime Membership',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: appRouter,
        );
      },
    );
  }
}
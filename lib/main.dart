import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:primio_app/router/app_router.dart';
import 'package:primio_app/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock to portrait on mobile; web is free to be any size
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Transparent status bar so NeonBackground bleeds edge-to-edge
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const PhrasePop());
}

class PhrasePop extends StatelessWidget {
  const PhrasePop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PhrasePop',
      debugShowCheckedModeBanner: false,
      // Use the dark neon theme that matches the logo visual identity
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
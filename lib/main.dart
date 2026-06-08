import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/dependency_injection/injection_container.dart' as di;
import 'package:pulse/features/main/ui/bloc/main_bloc.dart';
import 'package:pulse/features/main/ui/page/main_page.dart';
import 'package:window_manager/window_manager.dart';

import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await di.init();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 1024),
    minimumSize: Size(800, 600),
    center: true,
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: di.sl<MainBloc>())],
      child: MaterialApp(
        title: 'Pulse',
        theme: AppTheme.appTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const MainPage(),
      ),
    );
  }
}

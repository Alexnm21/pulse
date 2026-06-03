import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pulse/features/main/ui/bloc/main_bloc.dart';
import 'package:pulse/features/main/ui/page/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAssetLoader extends AssetLoader {
  const MockAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return {
      "title": "Pulse",
      "main": {
        "dashboard": "Dashboard",
        "processes": "Processes",
        "thermal": "Thermal",
        "cleaner": "Cleaner",
      },
    };
  }
}

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('Navigation works and changes views in MainPage', (
    WidgetTester tester,
  ) async {
    // Build the widget tree with EasyLocalization and MockAssetLoader
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        assetLoader: const MockAssetLoader(),
        child: Builder(
          builder: (context) {
            return BlocProvider(
              create: (context) => MainBloc(),
              child: MaterialApp(
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: const MainPage(),
              ),
            );
          },
        ),
      ),
    );

    // Re-pump to let EasyLocalization finish loading translations
    await tester.pumpAndSettle();

    // Verify initial screen is Dashboard (there should be the sidebar tile and the dashboard view title, i.e. 2 matching widgets)
    expect(find.text('Dashboard'), findsNWidgets(2));
    expect(find.text('Processes'), findsOneWidget); // Only in sidebar

    // Find the Processes tile in the sidebar and tap it
    final processesTile = find.text('Processes');
    await tester.tap(processesTile);
    await tester.pumpAndSettle();

    // Now we should have 2 "Processes" texts: one in sidebar, one in ProcessesView
    expect(find.text('Processes'), findsNWidgets(2));
    expect(find.text('Dashboard'), findsOneWidget); // Only in sidebar now

    // Tap the Thermal tile
    final thermalTile = find.text('Thermal');
    await tester.tap(thermalTile);
    await tester.pumpAndSettle();
    expect(find.text('Thermal'), findsNWidgets(2));

    // Tap the Cleaner tile
    final cleanerTile = find.text('Cleaner');
    await tester.tap(cleanerTile);
    await tester.pumpAndSettle();
    expect(find.text('Cleaner'), findsNWidgets(2));
  });
}

import 'package:feature_mind_case/app/data/routes/route_manager.dart';
import 'package:feature_mind_case/app/ui/pages/error_route_page/view/error_route_page.dart';
import 'package:feature_mind_case/app/ui/pages/home_page/view/home_page.dart';
import 'package:feature_mind_case/app/ui/theme/app_theme_dark.dart';
import 'package:feature_mind_case/app/ui/theme/app_theme_light.dart';
import 'package:feature_mind_case/core/constants/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_secure_storage/get_secure_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await GetSecureStorage.init(password: dotenv.get('STORAGE_PASS'));
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: ApplicationConstants.instance.appName,
          theme: AppThemeLight.instance.theme,
          darkTheme: AppThemeDark.instance.theme,
          initialRoute: RouteManager.instance.home,
          onGenerateRoute: (settings) {
            if (settings.name == RouteManager.instance.home) {
              return MaterialPageRoute(builder: (_) => const HomePage());
            }
            return MaterialPageRoute(builder: (_) => const ErrorRoutePage());
          },
          locale: ApplicationConstants.instance.locale,
          supportedLocales: ApplicationConstants.instance.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return ApplicationConstants.instance.fallbackLocale;
            return locale;
          },
        ),
      ),
    );
  }

  void localLogWriter(String text, {bool isError = false}) {
    if (kDebugMode) {
      debugPrint(text);
    }
  }
}

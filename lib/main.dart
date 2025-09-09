import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newsstepsafefuture/Screen/dashboard/dashboard.dart';
import 'package:newsstepsafefuture/providers/categoryProvider.dart';
import 'package:newsstepsafefuture/providers/homeProvider.dart';
import 'package:newsstepsafefuture/providers/menuProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default language

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuProvider()),
       // ChangeNotifierProvider(create: (_) => PageProvider()),
        //ChangeNotifierProvider(create: (_) => CategoriesProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'newsstepsafefuture',
            debugShowCheckedModeBanner: false,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate, // Generated localizations
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('es'), // Spanish
              Locale('hi'), // Hindi
            ],
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              useMaterial3: true,
            ),
            home: WebPageScreen(setLocale: setLocale),
          );
        },
      ),
    );
  }
}




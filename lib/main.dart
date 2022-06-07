import 'package:balance_app/screens/screens.dart';
import 'package:balance_app/services/auth_service.dart';
import 'package:balance_app/services/expenses.service.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'services/balance.service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => BalanceService()),
      ],
      child: MaterialApp(
          title: 'Balance App',
          debugShowCheckedModeBanner: false,
          initialRoute: SigninScreen.routeName,
          routes: {
            HomeScreen.routeName: (_) => const HomeScreen(),
            LoginScreen.routeName: (_) => const LoginScreen(),
            SigninScreen.routeName: (_) => const SigninScreen(),
          },
          theme: ThemeData.light().copyWith(
            appBarTheme: const AppBarTheme(
                color: Colors.white,
                elevation: 0.1,
                centerTitle: true,
                titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                iconTheme: IconThemeData(color: Colors.black),
                actionsIconTheme: IconThemeData(
                    size: 30, color: Color.fromRGBO(112, 112, 112, 1))),
          ),
          navigatorKey: navigatorKey),
    );
  }
}

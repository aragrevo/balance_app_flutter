import 'package:balance_app/screens/screens.dart';
import 'package:balance_app/screens/transaction_screen.dart';
import 'package:balance_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
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
      ],
      child: GetMaterialApp(
          title: 'Balance App',
          debugShowCheckedModeBanner: false,
          initialRoute: SigninScreen.routeName,
          getPages: [
            GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
            GetPage(
                name: LoginScreen.routeName, page: () => const LoginScreen()),
            GetPage(
                name: SigninScreen.routeName, page: () => const SigninScreen()),
            GetPage(
                name: TransactionScreen.routeName,
                page: () => TransactionScreen(),
                transition: Transition.downToUp),
          ],
          theme: ThemeData.light().copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
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

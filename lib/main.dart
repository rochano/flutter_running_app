import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:running_app/constants.dart';
import 'package:running_app/providers/provider.dart';
import 'package:running_app/screens/screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, TrackProvider>(
          create: (ctx) => TrackProvider(),
          update: (ctx, auth, tracks) => tracks..jwt = auth.jwt,
        ),
        ChangeNotifierProxyProvider<AuthProvider, ChallengeProvider>(
          create: (ctx) => ChallengeProvider(),
          update: (ctx, auth, challenges) => challenges..jwt = auth.jwt,
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserProvider>(
          create: (ctx) => UserProvider(),
          update: (ctx, auth, user) => user..jwt = auth.jwt,
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Running App',
          theme: ThemeData(
            scaffoldBackgroundColor: kBackgroundColor,
            primaryColor: kPrimaryColor,
            textTheme: Theme.of(context).textTheme.apply(bodyColor: kTextColor),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? BottomNavScreen(
                  initialIndex: 1,
                )
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : HomeScreen()),
          // : UserDetail()),
          // : EditProfileScreen()),
          // : ChallengeDetail()),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

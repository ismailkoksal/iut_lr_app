import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/constants.dart';
import 'package:iut_lr_app/pages/schedule_page.dart';
import 'package:iut_lr_app/routes.dart';
import 'package:iut_lr_app/services/gpu.dart';
import 'package:iut_lr_app/settings_store.dart';
import 'package:iut_lr_app/user.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  Intl.defaultLocale = 'fr_FR';
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: kDarkAppBarColor,
    ),
  );
  String username = await User.studentId;
  username != null
      ? GpuService.login(studentId: username).then((_) =>
          runApp(SettingsStore(child: MyApp(initialRoute: Routes.schedule))))
      : runApp(SettingsStore(child: MyApp(initialRoute: Routes.login)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({
    Key key,
    @required this.initialRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SettingsStore.of(context).theme,
      builder: (context, theme, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        initialRoute: initialRoute,
        routes: {
          Routes.login: (context) => LoginScreen(),
          Routes.schedule: (context) => ScheduleScreen(),
        },
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _studentId;
  String _error;

  void login(BuildContext context) {
    GpuService.login(studentId: _studentId).then((isLoggedIn) {
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/schedule');
      } else {
        setState(() => _error = 'Le numéro n\'est attribué à aucun étudiant');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBackgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: TextField(
                  onChanged: (value) {
                    _studentId = value;
                    setState(() => _error = null);
                  },
                  style: kTitle1Style,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  showCursor: false,
                  decoration: InputDecoration(
                    hintText: 'ex: 123456',
                    helperText: 'Le numéro figure sur votre carte étudiante.',
                    errorText: _error,
                    suffixIcon: Icon(Icons.help),
                    labelText: 'N° étudiant',
                    counter: SizedBox.shrink(),
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                  ),
                ),
              ),
              Positioned(
                bottom: 20.0,
                right: 0.0,
                child: FlatButton(
                  onPressed: () => login(context),
                  child: Text('Connexion'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

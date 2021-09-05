import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:iut_lr_app/constants.dart';
import 'package:iut_lr_app/pages/schedule_page.dart';
import 'package:iut_lr_app/repository/course_repository.dart';
import 'package:iut_lr_app/repository/repository.dart';
import 'package:iut_lr_app/routes.dart';
import 'package:iut_lr_app/services/gpu.dart';
import 'package:iut_lr_app/stores/course_store.dart';
import 'package:iut_lr_app/stores/date_store.dart';
import 'package:iut_lr_app/themes/dark.dart';
import 'package:provider/provider.dart';

import 'interceptor.dart';

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

  final dio = Dio(BaseOptions(baseUrl: 'https://www.gpu-lr.fr'))
    ..interceptors.add(CookieManager(CookieJar()))
    ..interceptors.add(GpuApiInterceptor());

  final courseRepository = CourseRepository(dio);

  final repository = Repository(courseRepository);

  final courseStore = CourseStore(repository);
  final dateStore = DateStore();

  runApp(
    MultiProvider(
      providers: [
        Provider<Repository>(create: (_) => repository),
        Provider<CourseStore>(create: (_) => courseStore),
        Provider<DateStore>(create: (_) => dateStore),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      routes: {
        Routes.login: (context) => LoginScreen(),
        Routes.schedule: (context) => ScheduleScreen(),
      },
      initialRoute: Routes.schedule,
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

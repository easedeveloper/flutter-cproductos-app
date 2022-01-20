import 'package:flutter/material.dart';
import 'package:productos_app/screens/home_screen.dart';
import 'package:productos_app/screens/screen.dart';
import 'package:productos_app/services/services.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';


void main() => runApp(AppState());

//VAMOS A CREAR DE MANERA GLOBAL EL SERVICIO Y TENER ACCESO EN CUALQUIER WIDGET
class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider(create:(_) => ProductServices() )
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'login'     : (_) => LoginScreen(),
        'homeScreen': (_) => HomeScreen(),
        'product'   : (_) => ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),

    );
  }
}

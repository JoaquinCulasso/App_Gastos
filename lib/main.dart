import 'package:flutter/material.dart';

// Vistas
import 'package:expenses/Views/HomePage.dart';
import 'package:expenses/Views/LoginPage.dart';
import 'package:expenses/Views/DetailsPage.dart';

//
import 'package:expenses/State/login_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Gastos Mensuales',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments;

            return MaterialPageRoute(builder: (BuildContext context) {
              return DetailsPage(
                params: params,
              );
            });
          }
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLoggedIn()) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
          //'/add': (BuildContext context) => AddPage(),
        },
      ),
    );
  }
}

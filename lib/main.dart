import 'package:app_loja_virtual/managers/admin_users_manager.dart';
import 'package:app_loja_virtual/managers/product_manager.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/screens/base/bases_creen.dart';
import 'package:app_loja_virtual/screens/cart/cart_screen.dart';
import 'package:app_loja_virtual/screens/edit_product/edit_product_screen.dart';
import 'package:app_loja_virtual/screens/login/loginscreen.dart';
import 'package:app_loja_virtual/screens/productdetail/product_screen.dart';
import 'package:app_loja_virtual/screens/signup/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'managers/cart_manager.dart';
import 'managers/home_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
          cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: true,
          update: (_, userManager, adminUserManager) =>
            adminUserManager!..updateUser(userManager),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Loja Virtual',
        theme: ThemeData(
          primaryTextTheme: const TextTheme(
            headline6: TextStyle(
              color: Colors.white,
            ),
          ),
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Color.fromARGB(255, 4, 125, 141),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/product':
              return MaterialPageRoute(builder: (_) => ProductScreen(settings.arguments as ProductModel));
            case '/cart':
              return MaterialPageRoute(builder: (_) => const CartScreen());
            case '/edit_product':
              return MaterialPageRoute(builder: (_) => EditProductScreen(settings.arguments as ProductModel));
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
      ),
    );
  }
}

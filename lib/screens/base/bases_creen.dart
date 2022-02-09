import 'package:app_loja_virtual/customdrawer/custom_drawer.dart';
import 'package:app_loja_virtual/managers/page_manager.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/screens/admin_users/admin_users_screen.dart';
import 'package:app_loja_virtual/screens/home/home_screen.dart';
import 'package:app_loja_virtual/screens/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {

  const BaseScreen({Key? key}) : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(), //1 item
              const ProductScreen(), //2 item
              Scaffold( //3 item
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Meus Pedidos'),
                ),
              ),
              Scaffold( // 4 item
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Lojas'),
                ),
              ),
              if(userManager.adminEnabled)
                ...[
                  const AdminUsersScreen(),
                  Scaffold( //3 item
                    drawer: const CustomDrawer(),
                    appBar: AppBar(
                      title: const Text('Pedidos'),
                    ),
                  ),
                ]


            ],
          );
        },
      ),
    );
  }
}

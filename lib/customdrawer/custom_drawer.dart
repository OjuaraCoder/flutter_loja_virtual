import 'package:app_loja_virtual/customdrawer/drawer_tile.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_drawer_header.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
             colors: [
               Color.fromARGB(255, 203, 236, 241),
               Colors.white,
             ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
        ),
        ListView(
          children: [
            const CustomDrawerHeader(),
            const Divider(),
            const DrawerTile(
              iconData: Icons.home,
              title: 'Inicio',
              page: 0,
            ),
            const DrawerTile(
              iconData: Icons.list,
              title: 'Produtos',
              page: 1,
            ),
            const DrawerTile(
              iconData: Icons.playlist_add_check,
              title: 'Meus Pedidos',
              page: 2,
            ),
            const DrawerTile(
              iconData: Icons.location_on,
              title: 'Lojas',
              page: 3,
            ),
            Consumer<UserManager>(
                builder: (_, userManager, __){
                  if(userManager.adminEnabled){
                    return Column(
                      children: const [
                        Divider(),
                        DrawerTile(
                          iconData: Icons.settings,
                          title: 'Usuários',
                          page: 4,
                        ),
                        DrawerTile(
                          iconData: Icons.settings,
                          title: 'Pedidos',
                          page: 5,
                        ),
                      ],
                    );
                  }else {
                    return Container();
                  }
                },
            ),
          ],
        ),
        ],
      ),
    );
  }
}

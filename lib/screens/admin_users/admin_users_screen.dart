import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:app_loja_virtual/customdrawer/custom_drawer.dart';
import 'package:app_loja_virtual/managers/admin_users_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {

  const AdminUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager,__){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                  adminUsersManager.listUsers[index].name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  adminUsersManager.listUsers[index].email,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
            showPreview: true,
            strList: adminUsersManager.names,
            indexedHeight: (index ) => 80,
            highlightTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          );
        },
      ),
    );
  }
}

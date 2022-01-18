import 'package:app_loja_virtual/managers/page_manager.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {

  const CustomDrawerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManager>(
        builder: (_, userManager, __){
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loja de\nRoupas',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Ola, ${userManager.usermodel.name} ',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(userManager.isLoggedIn){
                    context.read<PageManager>().setPage(0);
                    userManager.signOut();
                  }else{
                    Navigator.of(context).pushNamed('/login');
                  }

                },
                child: Text(
                  userManager.isLoggedIn ? 'Sair' : 'Entre ou cadastra-se >',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );

        },

      ),
    );
  }
}

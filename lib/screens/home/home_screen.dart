import 'package:app_loja_virtual/customdrawer/custom_drawer.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/screens/home/section_list.dart';
import 'package:app_loja_virtual/managers/home_manager.dart';
import 'package:app_loja_virtual/screens/home/section_staggered.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_section_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 58, 107, 199),
                  Color.fromARGB(255, 43, 43, 69),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja de Roupas'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                      onPressed: () => Navigator.of(context).pushNamed('/cart'),
                      icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                  ),
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager, __){
                      if(userManager.adminEnabled && !homeManager.loading){
                        if(homeManager.editing){
                          return PopupMenuButton(
                            onSelected: (e){
                              if(e == 'Salvar'){
                                homeManager.saveEditing();
                              }else{
                                homeManager.discardEditing();
                              }
                            },
                            itemBuilder: (_){
                              return ['Salvar','Descartar'].map((e) {
                                return PopupMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            }
                          );
                        }else{
                          return IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: (){
                              homeManager.enterEditing();
                            },
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
              Consumer<HomeManager>(
                  builder: (_, homeManager, __){
                    if(homeManager.loading){
                      return const SliverToBoxAdapter(
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }
                    final List<Widget> children = homeManager.sections.map<Widget>(
                            (section) {
                              switch(section.type){
                                case 'List':
                                  return SectionList(sectionModel: section,);
                                case 'Staggered':
                                  return SectionStaggered(sectionModel: section,);
                                default:
                                  return Container();
                              }
                            }).toList();
                    if(homeManager.editing){
                      children.add(AddSectionWidget(homeManager: homeManager));
                    }
                    return SliverList(
                      delegate: SliverChildListDelegate(children),
                    );
                  },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

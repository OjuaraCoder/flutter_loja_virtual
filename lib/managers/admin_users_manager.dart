
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminUsersManager extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<UserModel> listUsers = [];

  void updateUser(UserManager userManager){
    if(userManager.adminEnabled){
      _listenUsersFirebase();
    }
  }

  void _listenUsersFirebase(){
    firestore.collection('users').get().then((snapshot) {
      listUsers = snapshot.docs.map((e) => UserModel.fromDocument(e)).toList();
    });
    listUsers.sort((a , b ) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
  }

  // void _listenToUsers(){
  //   final faker = Faker();
  //   for(int i = 0; i < 500; i++){
  //     listUsers.add(
  //       UserModel(
  //         name: faker.person.name(),
  //         email: faker.internet.email(),
  //         uid: faker.guid.guid(),
  //       )
  //     );
  //   }
  //
  //   listUsers.sort((a , b ) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  //
  //   notifyListeners();
  // }


  List<String> get names => listUsers.map((e) => e.name).toList();




}
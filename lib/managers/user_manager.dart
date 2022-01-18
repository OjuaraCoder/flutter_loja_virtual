import 'package:app_loja_virtual/helpers/logger.dart';
import 'package:app_loja_virtual/helpers/validadors.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserManager extends ChangeNotifier {

  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel usermodel = UserModel(uid: '', name: '', email: '');
  bool get isLoggedIn => usermodel.uid != '';
  bool _loading = false;
  bool get loading => _loading;

  UserManager(){
    _loadCurrentUser();
  }

  Future<void> signIn({
      required String email,
      required String pass,
      required Function onFail,
      required Function onSuccess}) async {

    loading = true;

    try {
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: pass);

      final DocumentSnapshot docUser = await firestore.collection('users').doc(credential.user!.uid).get();
      usermodel.cleanUser();
      usermodel = UserModel.fromDocument(docUser);
      onSuccess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
      loading = false;
    }
    loading = false;
  }

  Future<void> signUp({
      required UserModel user,
      required String pass,
      required Function onFail,
      required Function onSucess})  async {

    loading = true;

    try{
      final UserCredential result = await auth.createUserWithEmailAndPassword(email: user.email, password: pass);

      user.uid = result.user!.uid;
      usermodel = user;
      await user.saveData();
      onSucess();
    }on FirebaseAuthException catch(e){
      onFail(getErrorString(e.code));
      loading = false;
    }
    loading = false;
  }

  void signOut(){
    auth.signOut();
    usermodel.cleanUser();
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    var currentUser = auth.currentUser;
    if(currentUser != null){
      final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();
      usermodel = UserModel.fromDocument(docUser);

      final docAdmin = await firestore.collection('admins').doc(currentUser.uid).get();
      if(docAdmin.exists){
        usermodel.admin = true;
      }

      logger.d('usermodel: ${usermodel.name}');
      notifyListeners();
    }
  }

  bool get adminEnabled => usermodel.admin;

}

import 'package:app_loja_virtual/helpers/validadors.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onSurface: Theme.of(context).primaryColor.withAlpha(100),
                //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            ),
            child: const Text(
              'criar conta',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formkey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        hintText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (email) {
                        if (!emailValid(email!)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(
                        hintText: 'Senha',
                      ),
                      autocorrect: false,
                      obscureText: true,
                      validator: (pass) {
                        if (pass == null || pass.length < 6) {
                          return 'Senha inválida';
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: userManager.loading ? null : () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: userManager.loading
                            ? const Text('')
                            : const Text('Esqueci minha senha'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formkey.currentState!.validate()) {
                                  userManager.signIn(
                                    email: emailController.text,
                                    pass: passController.text,
                                    onFail: (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Falha ao entrar: $e'),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    onSuccess:() {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          //onSurface: Theme.of(context).primaryColor.withAlpha(100),
                        ),
                        child: userManager.loading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                "Entrar",
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

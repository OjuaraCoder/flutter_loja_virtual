import 'package:app_loja_virtual/helpers/validadors.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
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
                      controller: nameController,
                      enabled: !userManager.loading,
                      decoration:
                          const InputDecoration(hintText: 'Nome Completo'),
                      validator: (name) {
                        if (name!.isEmpty) {
                          return 'Campo Obrigatório';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Preencha seu nome completo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: emailController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) {
                        if (email!.isEmpty) {
                          return 'Campo obrigátorio';
                        } else if (!emailValid(email)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: passController,
                      enabled: !userManager.loading,
                      decoration: const InputDecoration(hintText: 'Senha'),
                      obscureText: true,
                      validator: (pass) {
                        if (pass!.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (pass.length < 6) {
                          return 'Senha muito curta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: confirmpassController,
                      enabled: !userManager.loading,
                      decoration:
                          const InputDecoration(hintText: 'Repita a senha'),
                      obscureText: true,
                      validator: (confirmpass) {
                        if (confirmpass!.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (confirmpass.length < 6) {
                          return 'Senha muito curta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: userManager.loading
                            ? null
                            : () {
                                if (formkey.currentState!.validate()) {
                                  if (passController.text != confirmpassController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Senhas não coincidem"),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  UserModel user = UserModel(
                                    uid: '0',
                                    email: emailController.text,
                                    name: nameController.text,
                                  );
                                  userManager.signUp(
                                    user: user,
                                    pass: passController.text,
                                    onSucess: () {
                                      Navigator.of(context).pop();
                                    },
                                    onFail: (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Falha ao entrar: $e'),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(milliseconds: 300),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          onSurface: Theme.of(context).primaryColor.withAlpha(100),
                        ),
                        child: userManager.loading
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text(
                                "Criar Conta",
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

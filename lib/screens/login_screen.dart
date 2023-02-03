import 'package:citizen/screens/home_screen.dart';
import 'package:citizen/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../providers/auth_provider.dart';
import '../themes.dart';
import '../widgets/rounded_center_button.dart';
import '../widgets/rounded_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Hero(
          tag: 'logo',
          child: Image(
            image: AssetImage('assets/logo/logo.png'),
            height: 20,
          ),
        ),
      ),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: RawMaterialButton(
            fillColor: Colors.white,
            elevation: 4,
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 22.0, bottom: 8, left: 16, right: 16),
              child:
                  Consumer<AuthProvider>(builder: (context, provider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundedTextField(
                      label: "Email",
                      icon: Icons.mail,
                      controller: _emailController,
                    ),
                    RoundedTextField(
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 10),
                    provider.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.mainColor,
                            ),
                          )
                        : RoundedCenterButtton(
                            onPressed: () async {
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                showToast('Please enter your credentials.');
                                return;
                              }
                              FocusScope.of(context).unfocus();
                              var data = {
                                "email":
                                    _emailController.text.toString().trim(),
                                "password": _passwordController.text.toString()
                              };
                              final response = await provider.login(data);
                              if (response != null && response != false) {
                                replaceScreen(context, HomeScreen());
                              }
                            },
                            title: 'Login'),
                    const SizedBox(height: 10),
                    !provider.isLoading? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () async{
                            final result =await provider.loginWithFacebook();
                            if(result){
                              replaceScreen(context, HomeScreen());
                            }
                          },
                          child: Row(
                            children: const [
                              Image(
                                image: AssetImage('assets/icons/facebook.png'),
                                height: 16,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Login with Facebook',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                    ):SizedBox(),
                    TextButton(
                      onPressed: () {
                        nextScreen(context, const SignupScreen());
                      },
                      child: const Text(
                        'New user? Sign up',
                        style: TextStyle(color: AppColors.mainColor),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

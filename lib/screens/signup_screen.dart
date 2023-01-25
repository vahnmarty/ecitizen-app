import 'package:citizen/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/constancts.dart';
import '../providers/auth_provider.dart';
import '../themes.dart';
import '../widgets/rounded_center_button.dart';
import '../widgets/rounded_text_field.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedTextField(
                    label: "Name",
                    icon: Icons.account_circle_outlined,
                    controller: _nameController,
                  ),
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
                  RoundedTextField(
                    label: 'Confirm Password',
                    icon: Icons.lock,
                    obscureText: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 10),
                  Consumer<AuthProvider>(
                    builder: (context, provider, child) {
                      return provider.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.mainColor,
                              ),
                            )
                          : RoundedCenterButtton(
                              onPressed: () async {
                                //nextScreen(context, HomeScreen());
                                if (_nameController.text.isEmpty ||
                                    _emailController.text.isEmpty ||
                                    _passwordController.text.isEmpty ||
                                    _confirmPasswordController.text.isEmpty) {
                                  showToast('Please enter your credentials.');
                                  return;
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(
                                        _emailController.text.toString())) {
                                  showToast('Please enter valid email');
                                  return;
                                } else if (_passwordController.text !=
                                    _confirmPasswordController.text) {
                                  showToast('Confirm password is not same');
                                  return;
                                } else if (_passwordController.text.length <
                                    6) {
                                  showToast(
                                      'Password must be 8 characters long!');
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                var data = {
                                  "name": _nameController.text.toString(),
                                  "email": _emailController.text.toString().trim(),
                                  "password":
                                      _passwordController.text.toString(),
                                  "password_confirmation":
                                      _confirmPasswordController.text.toString()
                                };

                                final response = await provider.signup(data);
                                if (response != null && response != false) {
                                  replaceScreen(context, HomeScreen());
                                }
                              },
                              title: 'Signup');
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      nextScreen(context, const LoginScreen());
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(color: AppColors.mainColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

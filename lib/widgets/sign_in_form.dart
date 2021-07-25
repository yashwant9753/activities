import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/res/custom_colors.dart';
import 'package:login/screens/register_screen.dart';
import 'package:login/screens/activityScreen.dart';
import 'package:login/utils/authentication.dart';
import 'package:login/utils/validator.dart';
import 'package:connectivity/connectivity.dart';
import 'custom_form_field.dart';
import 'package:login/screens/TestPage.dart';

class SignInForm extends StatefulWidget {
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;

  const SignInForm({
    Key? key,
    required this.emailFocusNode,
    required this.passwordFocusNode,
  }) : super(key: key);
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _signInFormKey = GlobalKey<FormState>();

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).backgroundColor),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _signInFormKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                  right: 8.0,
                  bottom: 24.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomFormField(
                      controller: _emailController,
                      focusNode: widget.emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      validator: (value) => Validator.validateEmail(
                        email: value,
                      ),
                      label: 'Email',
                      hint: 'Email',
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: EdgeInsets.only(bottom: 45),
                      child: CustomFormField(
                        controller: _passwordController,
                        focusNode: widget.passwordFocusNode,
                        keyboardType: TextInputType.text,
                        inputAction: TextInputAction.done,
                        validator: (value) => Validator.validatePassword(
                          password: value,
                        ),
                        isObscure: true,
                        label: 'Password',
                        hint: 'Password',
                      ),
                    ),
                  ],
                ),
              ),
              _isSigningIn
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CustomColors.firebaseOrange,
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            CustomColors.firebaseOrange,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          widget.emailFocusNode.unfocus();
                          widget.passwordFocusNode.unfocus();

                          setState(() {
                            _isSigningIn = true;
                          });

                          if (_signInFormKey.currentState!.validate()) {
                            User? user =
                                await Authentication.signInUsingEmailPassword(
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text,
                            );

                            if (user != null) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => ActivityScreen(
                                          user: user,
                                        )),
                              );
                            }
                          }

                          setState(() {
                            _isSigningIn = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.firebaseGrey,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
              SizedBox(height: 16.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ),
                  );
                },
                child: Text(
                  'Don\'t have an account? Sign up',
                  style: TextStyle(
                    color: CustomColors.firebaseGrey,
                    letterSpacing: 0.5,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

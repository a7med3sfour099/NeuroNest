import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/core/utils/validators.dart';
import 'package:firstversion1/shared/Custom_rowbutton.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_outlinedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:firstversion1/shared/custom_textbutton.dart';
import 'package:firstversion1/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool rememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 48.0,
                horizontal: 10.0,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/auth/login_icon.png',
                        width: 170,
                        height: 159,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Gap(5),
                          CustomText(
                            text: 'Login to your account',
                            size: 23,
                            color: Color(0xff000000),
                            weight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                          Gap(3),
                          CustomText(
                            text: 'Welcome back please insert your details',
                            size: 20,
                            color: Color(0xff6c6969),
                            weight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          Gap(33),
                          CustomTextfield(
                            hint: 'Email',
                            isPass: false,
                            controller: emailController,
                            keyboard: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          Gap(15),
                          CustomTextfield(
                            hint: 'Password',
                            isPass: true,
                            controller: passController,
                            textInputAction: TextInputAction.done,
                            validator: validateStrongPassword,
                          ),
                          Gap(14),
                          Row(
                            children: [
                              Checkbox(
                                side: BorderSide(color: Color(0xffD9D9D9)),
                                activeColor: Colors.blue,
                                value: rememberMe,
                                onChanged: (val) =>
                                    setState(() => rememberMe = val!),
                              ),
                              CustomText(
                                text: 'Remember me',
                                size: 20,
                                color: Color(0xff000000),
                                weight: FontWeight.w400,
                              ),
                              Spacer(),
                              CustomTextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/forgetpass',
                                  );
                                },
                                text: 'Forget Password',
                                color: Colors.blue,
                                size: 20,
                                weight: FontWeight.w400,
                              ),
                            ],
                          ),
                          Gap(25),
                          CustomElevatedbutton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/childinfo',
                                  (route) => false,
                                );
                              }
                            },
                            text: 'Login',
                          ),
                          Gap(18),
                          CustomOutlinedButton(
                            backgroundImage: 'assets/auth/google_vector.png',
                            text: 'Sign Up with google',
                          ),
                          Gap(5),
                          CustomRowButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/signup',
                              );
                            },
                            text: 'Don\'t have an account ?',
                            sizedText: 23,
                            textButton: 'Sign up',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/core/utils/validators.dart';
import 'package:neuronest/features/auth/providers/auth_provider.dart';
import 'package:neuronest/shared/Custom_rowbutton.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_outlinedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/shared/custom_textbutton.dart';
import 'package:neuronest/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:neuronest/shared/custom_outlinedbutton.dart';
import 'package:provider/provider.dart';

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
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

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
                          Gap(4),
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
                          Gap(17),
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
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              if (authProvider.isLoading) {
                                return const CircularProgressIndicator();
                              }

                              return CustomElevatedbutton(
                                onPressed: () async {
                                  if (!_formKey.currentState!.validate())
                                    return;

                                  final success = await authProvider.login(
                                    email: emailController.text.trim(),
                                    password: passController.text,
                                  );

                                  if (!mounted) return;

                                  if (success) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/childinfo',
                                      (route) => false,
                                    );
                                  } else {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.bottomSlide,
                                      title: 'Login Failed',
                                      desc:
                                          authProvider.errorMessage ??
                                          'An error occurred during login.',
                                      btnOkOnPress: () {},
                                    ).show();
                                  }
                                },
                                text: 'Login',
                              );
                            },
                          ),
                          Gap(20),
                          CustomOutlinedButton(
                            onPressed: () async {
                              final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              );

                              final success = await authProvider
                                  .signInWithGoogle();

                              if (!mounted) return;

                              if (success) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/childinfo',
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.errorMessage ??
                                          'Google login failed',
                                    ),
                                  ),
                                );
                              }
                            },
                            backgroundImage: 'assets/auth/google_vector.png',
                            text: 'Sign Up with google',
                          ),
                          Gap(18),
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

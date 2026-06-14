import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/core/utils/validators.dart';
import 'package:firstversion1/features/auth/providers/auth_provider.dart';
import 'package:firstversion1/shared/Custom_rowbutton.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_outlinedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:firstversion1/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
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
                vertical: 41.0,
                horizontal: 10.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/auth/singup_icon.png',
                        width: 121,
                        height: 121,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Gap(25),
                          CustomText(
                            text: 'Create a new account',
                            size: 23,
                            color: Color(0xff000000),
                            weight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                          Gap(4),
                          CustomText(
                            text:
                                'Let\'s get you started by entering your details',
                            size: 20,
                            color: Color(0xff6c6969),
                            weight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          Gap(25),
                          CustomOutlinedButton(
                            backgroundImage: 'assets/auth/google_vector.png',
                            text: 'Sign Up with google',
                          ),
                          Gap(32),
                          CustomTextfield(
                            hint: 'Name',
                            isPass: false,
                            controller: nameController,
                            keyboard: TextInputType.text,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Name is required';
                              }
                              if (v.trim().length < 3) return 'Name too short';
                              return null;
                            },
                          ),
                          Gap(12),
                          CustomTextfield(
                            hint: 'Email',
                            isPass: false,
                            controller: emailController,
                            keyboard: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          Gap(12),
                          CustomTextfield(
                            hint: 'Password',
                            isPass: true,
                            controller: passController,
                            textInputAction: TextInputAction.done,
                            keyboard: TextInputType.visiblePassword,
                            validator: validateStrongPassword,
                          ),
                          Gap(17),
                          CustomRowButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                            text: 'Already have an account ?',
                            sizedText: 21,
                            textButton: 'Log in',
                          ),
                          Gap(10),
                          // CustomElevatedbutton(
                          //   onPressed: () async {
                          //     if (_formKey.currentState!.validate()) {
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackBar(
                          //           content: const Text(
                          //             'Sign up successfully! Redirecting to login...',
                          //           ),
                          //           duration: const Duration(seconds: 2),
                          //           backgroundColor: Colors.green[700],
                          //           behavior: SnackBarBehavior.floating,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(10),
                          //           ),
                          //         ),
                          //       );
                          //       await Future.delayed(
                          //         const Duration(seconds: 2),
                          //       );
                          //       if (mounted) {
                          //         Navigator.pushReplacementNamed(
                          //           context,
                          //           '/login',
                          //         );
                          //       }
                          //     }
                          //   },
                          //   text: 'Sign In',
                          // ),
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return CustomElevatedbutton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                        if (!_formKey.currentState!.validate())
                                          return;

                                        final success = await authProvider
                                            .signup(
                                              name: nameController.text.trim(),
                                              email: emailController.text
                                                  .trim(),
                                              password: passController.text,
                                            );

                                        if (!mounted) return;

                                        if (success) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Account created successfully',
                                              ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                              backgroundColor:
                                                  Colors.green[700],
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                          await Future.delayed(
                                            const Duration(milliseconds: 1500),
                                          );
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (route) => false,
                                          );
                                        } else {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.scale,
                                            title: 'Sign Up Failed',
                                            desc:
                                                authProvider.errorMessage ??
                                                'An error occurred during sign up.',
                                            btnOkOnPress: () {},
                                          ).show();
                                        }
                                      },
                                text: authProvider.isLoading
                                    ? 'Creating Account...'
                                    : 'Sign Up',
                              );
                            },
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

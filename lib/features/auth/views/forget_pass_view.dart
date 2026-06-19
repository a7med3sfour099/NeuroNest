import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/core/utils/validators.dart';
import 'package:neuronest/features/auth/providers/auth_provider.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_outlinedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  TextEditingController emailController = TextEditingController();
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
                vertical: 106.0,
                horizontal: 10.0,
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteractionIfError,
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/auth/forget_pass.png',
                        width: 209,
                        height: 223,
                      ),
                    ),
                    Gap(12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          CustomText(
                            text: 'Forget Password ?',
                            size: 23,
                            color: Color(0xff000000),
                            weight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                          Gap(3),
                          CustomText(
                            text:
                                'Don\'t worry we will send you reset instructions',
                            size: 20,
                            color: Color(0xff6c6969),
                            weight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          Gap(18),
                          CustomTextfield(
                            hint: 'Email',
                            isPass: false,
                            controller: emailController,
                            keyboard: TextInputType.emailAddress,
                            validator: validateEmail,
                          ),
                          Gap(28),
                          CustomElevatedbutton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final authProvider = Provider.of<AuthProvider>(context, listen: false);

                              final success = await authProvider.forgotPassword(
                                emailController.text.trim(),
                              );

                              if (!mounted) return;

                              if (success) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/verification',
                                  arguments: emailController.text.trim(),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      authProvider.errorMessage ??
                                          'Failed to send reset code',
                                    ),
                                  ),
                                );
                              }
                            },
                            text: 'Reset Password',
                          ),
                          Gap(18),
                          CustomOutlinedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                              context,
                              '/login',
                            ),
                            text: 'Back to Login',
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

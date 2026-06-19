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

class SetNewPasswordView extends StatefulWidget {
  const SetNewPasswordView({super.key});

  @override
  State<SetNewPasswordView> createState() => _SetNewPasswordViewState();
}

class _SetNewPasswordViewState extends State<SetNewPasswordView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  Map<String, dynamic>? data;
  String? email;
  String? code;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  final args = ModalRoute.of(context)?.settings.arguments;

  if (args is Map<String, dynamic>) {
    data = args;
    email = args['email']?.toString();
    code = args['code']?.toString();
  }
  }

  @override
  void dispose() {
    passController.dispose();
    confirmPassController.dispose();
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
                vertical: 42.0,
                horizontal: 10.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/auth/reset_pass.png',
                        width: 325,
                        height: 244,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          CustomText(
                            text: 'Set new password',
                            size: 23,
                            color: Color(0xff000000),
                            weight: FontWeight.w700,
                            textAlign: TextAlign.center,
                          ),
                          Gap(3),
                          CustomText(
                            text:
                                'Your new password must be \n different from last password',
                            size: 20,
                            color: Color(0xff6c6969),
                            weight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                          Gap(31),
                          CustomTextfield(
                            hint: 'Password',
                            isPass: true,
                            controller: passController,
                            textInputAction: TextInputAction.done,
                            validator: validateStrongPassword,
                          ),
                          Gap(15),
                          CustomTextfield(
                            hint: 'Confirm Password',
                            isPass: true,
                            controller: confirmPassController,
                            textInputAction: TextInputAction.done,
                            validator: (v) {
                              if (v != passController.text) {
                                return 'Passwords do not match';
                              }
                              return validateStrongPassword(v);
                            },
                          ),
                          Gap(17),
                          CustomElevatedbutton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false,
                                );

                                final success = await authProvider
                                    .resetPassword(
                                      email: email!,
                                      code: code!,
                                      newPassword: passController.text,
                                    );

                                if (success) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/successset',
                                  );
                                }
                              }
                            },
                            text: 'Save Password',
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

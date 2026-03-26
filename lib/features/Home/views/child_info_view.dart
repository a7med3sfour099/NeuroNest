import 'package:firstversion1/core/constants/app_colors.dart';
import 'package:firstversion1/features/Home/widgets/birth_date_widg.dart';
import 'package:firstversion1/shared/custom_elevatedbutton.dart';
import 'package:firstversion1/shared/custom_text.dart';
import 'package:firstversion1/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChildInfoView extends StatefulWidget {
  const ChildInfoView({super.key});

  @override
  State<ChildInfoView> createState() => _ChildInfoViewState();
}

class _ChildInfoViewState extends State<ChildInfoView> {
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _gender;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 99.0, horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomText(
                  text: 'Set up your Child information',
                  size: 23,
                  color: Color(0xff000000),
                  weight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),
                Gap(3),
                CustomText(
                  text: 'This helps us better understand your child',
                  size: 20,
                  color: Color(0xff6c6969),
                  weight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      Gap(45),
                      CustomTextfield(
                        hint: 'Child name',
                        isPass: false,
                        controller: nameController,
                        keyboard: TextInputType.text,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty)
                            return 'Name is required';
                          if (v.trim().length < 3) return 'Name too short';
                          return null;
                        },
                      ),
                      Gap(15),
                      DateOfBirthField(
                        onDateSelected: (selectedDate) {
                          print("Selected date: $selectedDate");
                        },
                      ),
                      Gap(39),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Gender',
                            size: 21,
                            color: Color(0xff000000),
                            weight: FontWeight.w600,
                          ),
                          Gap(14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => _gender = "M"),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "M",
                                      groupValue: _gender,
                                      onChanged: (val) =>
                                          setState(() => _gender = val!),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    SizedBox(width: 4),
                                    CustomText(
                                      text: 'Male',
                                      size: 21,
                                      color: const Color(0xff000000),
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(38),
                              GestureDetector(
                                onTap: () => setState(() => _gender = "F"),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "F",
                                      groupValue: _gender,
                                      onChanged: (val) =>
                                          setState(() => _gender = val!),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    SizedBox(width: 4),
                                    CustomText(
                                      text: 'Female',
                                      size: 21,
                                      color: const Color(0xff000000),
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(38),
                              GestureDetector(
                                onTap: () => setState(() => _gender = "O"),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: "O",
                                      groupValue: _gender,
                                      onChanged: (val) =>
                                          setState(() => _gender = val!),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    const SizedBox(width: 4),
                                    CustomText(
                                      text: 'Other',
                                      size: 21,
                                      color: const Color(0xff000000),
                                      weight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Gap(39),
                      Divider(color: Colors.grey, thickness: 1),
                      Gap(9),
                      Row(
                        children: [
                          CustomText(
                            text: 'You can edit this later',
                            size: 21,
                            color: Color(0xff6c6969),
                            weight: FontWeight.w300,
                          ),
                        ],
                      ),
                      Gap(38),
                      CustomElevatedbutton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/startques',
                            );
                          }
                        },
                        text: 'Continue',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

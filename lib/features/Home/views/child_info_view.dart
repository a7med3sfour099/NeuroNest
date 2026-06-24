import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/core/network/api_service.dart';
import 'package:neuronest/features/Home/providers/child_provider.dart';
import 'package:neuronest/features/Home/widgets/birth_date_widg.dart';
import 'package:neuronest/features/assessmentQues/providers/screening_provider.dart';
import 'package:neuronest/shared/custom_elevatedbutton.dart';
import 'package:neuronest/shared/custom_text.dart';
import 'package:neuronest/shared/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ChildInfoView extends StatefulWidget {
  const ChildInfoView({super.key});

  @override
  State<ChildInfoView> createState() => _ChildInfoViewState();
}

class _ChildInfoViewState extends State<ChildInfoView> {
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _dateOfBirth;
  String? _gender;
  String? _Jaundice;
  String? _FamilyHistory;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 90.0, horizontal: 10.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                        Gap(35),
                        CustomTextfield(
                          hint: 'Child name',
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
                        Gap(15),
                        DateOfBirthField(
                          onDateSelected: (selectedDate) {
                            setState(
                              () => _dateOfBirth =
                                  "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                            );
                          },
                        ),
                        Gap(25),
                        //============
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Gender',
                              size: 18,
                              color: const Color(0xff000000),
                              weight: FontWeight.w600,
                            ),
                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: _selectionCard(
                                    title: "Male",
                                    icon: Icons.male_rounded,
                                    value: "Male",
                                    groupValue: _gender,
                                    onTap: (value) =>
                                        setState(() => _gender = value),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _selectionCard(
                                    title: "Female",
                                    icon: Icons.female_rounded,
                                    value: "Female",
                                    groupValue: _gender,
                                    onTap: (value) =>
                                        setState(() => _gender = value),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(19),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Yellowing of the skin and eyes',
                              size: 18,
                              color: const Color(0xff000000),
                              weight: FontWeight.w600,
                            ),
                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: _selectionCard(
                                    title: "Yes",
                                    icon: Icons.check_circle_outline_rounded,
                                    value: "1",
                                    groupValue: _Jaundice,
                                    onTap: (value) =>
                                        setState(() => _Jaundice = value),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _selectionCard(
                                    title: "No",
                                    icon: Icons.cancel_rounded,
                                    value: "0",
                                    groupValue: _Jaundice,
                                    onTap: (value) =>
                                        setState(() => _Jaundice = value),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(19),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Family history of autism',
                              size: 18,
                              color: const Color(0xff000000),
                              weight: FontWeight.w600,
                            ),
                            const SizedBox(height: 14),

                            Row(
                              children: [
                                Expanded(
                                  child: _selectionCard(
                                    title: "Yes",
                                    icon: Icons.check_circle_outline_rounded,
                                    value: "1",
                                    groupValue: _FamilyHistory,
                                    onTap: (value) =>
                                        setState(() => _FamilyHistory = value),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _selectionCard(
                                    title: "No",
                                    icon: Icons.cancel_rounded,
                                    value: "0",
                                    groupValue: _FamilyHistory,
                                    onTap: (value) =>
                                        setState(() => _FamilyHistory = value),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Gap(25),
                        Divider(color: Colors.grey, thickness: 1),
                        Gap(9),
                        Row(
                          children: [
                            CustomText(
                              text: 'You can edit this later',
                              size: 19,
                              color: Color(0xff6c6969),
                              weight: FontWeight.w300,
                            ),
                          ],
                        ),
                        Gap(25),
                        CustomElevatedbutton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) return;
                            if (_dateOfBirth == null || _gender == null) return;
                            final provider = context.read<ChildProvider>();

                            final childId = await provider.addChild(
                              childName: nameController.text,
                              dateOfBirth: _dateOfBirth!,
                              gender: _gender!,
                              hasJaundice: _Jaundice == "1",
                              familyASD: _FamilyHistory == "1",
                            );

                            if (childId != null) {
                              final screeningId = await context
                                  .read<ScreeningProvider>()
                                  .createScreening(childId);

                              print('CHILD ID => $childId');
                              print('SCREENING ID => $screeningId');

                              if (screeningId != null) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/startques',
                                  arguments: {
                                    'childId': childId,
                                    'screeningId': screeningId,
                                  },
                                );
                              }
                            }
                          },
                          text: 'Continue',
                        ),
                        // Gap(250),
                      ],
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

  Widget _selectionCard({
    required String title,
    required IconData icon,
    required String value,
    required String? groupValue,
    required Function(String) onTap,
  }) {
    final bool isSelected = groupValue == value;

    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5BAFD8).withOpacity(.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF5BAFD8) : Colors.grey.shade300,
            width: 1.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? const Color(0xFF5BAFD8) : Colors.grey,
            ),

            const SizedBox(width: 8),

            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF5BAFD8) : Colors.black87,
              ),
            ),

            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                size: 21,
                color: Color(0xFF5BAFD8),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:neuronest/core/constants/app_colors.dart';
import 'package:neuronest/features/home/providers/child_provider.dart';
import 'package:provider/provider.dart';

class ChildCard extends StatelessWidget {
  const ChildCard({super.key});

  @override
  Widget build(BuildContext context) {
    final child = context.watch<ChildProvider>().currentChild;

    if (child == null) {
      return const SizedBox();
    }
    final birthDate = DateTime.tryParse(child.dateOfBirth) ?? DateTime.now();
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xffEEF5FF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(
              child: const FaIcon(
                FontAwesomeIcons.childReaching,
                color: Color(0xff4F8EF7),
                size: 38,
              ),
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Current Child",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 5),

                Text(
                  child.childName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${child.gender} • $age Years",
                  style: const TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.cakeCandles,
                      size: 18,
                      color: Colors.blue,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      DateFormat(
                        "dd MMM yyyy",
                      ).format(DateTime.parse(child.dateOfBirth)),
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

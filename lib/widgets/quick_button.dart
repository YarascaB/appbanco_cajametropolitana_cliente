import 'package:flutter/material.dart';

import '../ui/theme/app_colors.dart';

class QuickButton extends StatelessWidget {

  final IconData icon;
  final String title;

  const QuickButton({

    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Container(

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(

            color: Colors.white,

            borderRadius:
                BorderRadius.circular(20),

            boxShadow: [

              BoxShadow(
                color:
                    Colors.black.withOpacity(0.05),

                blurRadius: 10,
              ),
            ],
          ),

          child: Icon(
            icon,
            color: AppColors.primary,
            size: 30,
          ),
        ),

        const SizedBox(height: 10),

        Text(title),
      ],
    );
  }
}
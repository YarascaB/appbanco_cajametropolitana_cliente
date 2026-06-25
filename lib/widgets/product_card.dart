import 'package:flutter/material.dart';

import '../ui/theme/app_colors.dart';

class ProductCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color color;

  const ProductCard({

    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(25),

        boxShadow: [

          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),

            blurRadius: 10,
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(

              color:
                  color.withOpacity(0.15),

              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  subtitle,

                  style: const TextStyle(
                    color:
                        AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,

            style: TextStyle(
              color: color,
              fontWeight:
                  FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
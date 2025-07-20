import 'package:flutter/material.dart';
import 'package:tracker/utils/constants.dart';

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String? iconAsset;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.iconBg,
    this.iconAsset,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: iconAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(iconAsset!, fit: BoxFit.contain),
                  )
                : Icon(icon, color: blackColor, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(date, style: TextStyle(color: grayColor, fontSize: 12)),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+ ' : '- '}₹ ${amount.replaceAll(RegExp(r'[^0-9.,]'), '')}',
            style: TextStyle(
              color: isIncome ? greenColor : redColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/show_transaction_details.dart';

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String? iconAsset;
  final String title;
  final String date;
  final String amount;
  final bool isIncome;
  final String? transactionId;

  const TransactionItem({
    super.key,
    required this.icon,
    required this.iconBg,
    this.iconAsset,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.transactionId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: transactionId != null
          ? () => showTransactionDetails(context, transactionId!)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: transactionId != null ? Colors.grey.withOpacity(0.05) : null,
        ),
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
            Row(
              children: [
                Text(
                  '${isIncome ? '+ ' : '- '}₹ ${amount.replaceAll(RegExp(r'[^0-9.,]'), '')}',
                  style: TextStyle(
                    color: isIncome ? greenColor : redColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (transactionId != null) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: grayColor, size: 20),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/show_transaction_details.dart';
import 'package:tracker/providers/transaction_provider.dart';

class TransactionItem extends ConsumerWidget {
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

  Future<bool?> _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content: const Text('Do you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'NO',
                style: TextStyle(color: grayColor, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: darkRedColor),
              child: Text(
                'YES',
                style: TextStyle(color: redColor, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    if (transactionId == null) return;

    try {
      // Get current local date & time when delete operation is performed
      final DateTime now = DateTime.now();
      final String deleteDateTime = now.toIso8601String();

      await ref
          .read(transactionListProvider.notifier)
          .deleteTransaction(transactionId!, deleteDateTime);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction deleted successfully'),
            backgroundColor: darkGreenColor,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete transaction: ${e.toString()}'),
            backgroundColor: darkRedColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionCard = GestureDetector(
      onTap: transactionId != null
          ? () => showTransactionDetails(context, transactionId!)
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: transactionId != null ? grayColor.withAlpha(10) : null,
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

    // Only wrap in Dismissible if transactionId is not null
    if (transactionId == null) {
      return transactionCard;
    }

    return Dismissible(
      key: Key(transactionId!),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        final bool? shouldDelete = await _showDeleteConfirmation(context, ref);
        if (shouldDelete == true) {
          await _handleDelete(context, ref);
        }
        return shouldDelete;
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: redColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.delete_outline, color: whiteColor, size: 30),
      ),
      child: transactionCard,
    );
  }
}

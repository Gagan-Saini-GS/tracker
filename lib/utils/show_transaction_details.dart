import 'package:flutter/material.dart';
import 'package:tracker/widgets/transaction_details_bottom_sheet.dart';

void showTransactionDetails(BuildContext context, String transactionId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        TransactionDetailsBottomSheet(transactionId: transactionId),
  );
}

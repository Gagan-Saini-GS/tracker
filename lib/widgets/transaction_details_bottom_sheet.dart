import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
// import 'package:tracker/utils/constants.dart';

class TransactionDetailsBottomSheet extends ConsumerStatefulWidget {
  final String transactionId;

  const TransactionDetailsBottomSheet({super.key, required this.transactionId});

  @override
  ConsumerState<TransactionDetailsBottomSheet> createState() =>
      _TransactionDetailsBottomSheetState();
}

class _TransactionDetailsBottomSheetState
    extends ConsumerState<TransactionDetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(transactionListProvider.notifier)
          .getTransactionDetailsById(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final trancsationState = ref.watch(transactionListProvider);

    if (trancsationState.isLoading) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: greenColor,
              color: whiteColor,
              strokeWidth: 5,
            ),
            SizedBox(height: 16),
            Text(
              "Loading transaction details...",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
    }

    final details = trancsationState.selectedTransaction;

    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: darkGreenColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                details.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: (details.isIncome ? greenColor : redColor),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: (details.isIncome ? greenColor : redColor).withAlpha(
                    50,
                  ),
                ),
                child: Text(
                  (details.isIncome ? "Income" : "Expense").toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: details.isIncome ? greenColor : redColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            "Date",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          Text(
            formatDateTimeWithMonthName(details.date),
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),

          if (details.note != "") ...[
            Text("Note", style: TextStyle(color: blackColor, fontSize: 18)),
            const SizedBox(height: 2),
            Text(details.note, style: TextStyle(fontSize: 18)),

            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

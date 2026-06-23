import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/transaction_type.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
import 'package:tracker/widgets/loader.dart';
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
        color: darkGrayColor,
        child: Loader(
          title: "Loading Transaction Details",
          transparent: true,
          foregroundColor: whiteColor,
          backgroundColor: darkGrayColor,
          textStyle: TextStyle(color: whiteColor),
        ),
      );
    }

    final details = trancsationState.selectedTransaction;

    String getTransactionType(TransactionType type) {
      switch (type) {
        case TransactionType.expense:
          return "Expense";
        case TransactionType.income:
          return "Income";
        case TransactionType.saving:
          return "Saving";
        case TransactionType.goal:
          return "Goal";
      }
    }

    Color getIconColorByType(TransactionType type) {
      switch (type) {
        case TransactionType.expense:
          return redColor;
        case TransactionType.income:
          return greenColor;
        case TransactionType.saving:
          return blueColor;
        case TransactionType.goal:
          return blackColor;
      }
    }

    return Container(
      padding: const EdgeInsets.all(24.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: darkGrayColor,
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
                color: whiteColor.withAlpha(50),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  details.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: whiteColor,
                  ),
                ),
              ),
              // Text(
              //   details.name,
              //   style: const TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     // overflow: TextOverflow.ellipsis,
              //   ),
              //   maxLines: 3,
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: getIconColorByType(details.type),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: getIconColorByType(details.type).withAlpha(50),
                ),
                child: Text(
                  (getTransactionType(details.type)).toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: getIconColorByType(details.type),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Text(
                "Amount",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: whiteColor,
                ),
              ),
              const Spacer(),
              Text(
                '${details.type == TransactionType.saving
                    ? ''
                    : details.isIncome
                    ? '+ '
                    : '- '}₹ ${details.amount.toString().replaceAll(RegExp(r'[^0-9.,]'), '')}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: getIconColorByType(details.type),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Date",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: whiteColor,
            ),
          ),
          Text(
            formatDateTimeWithMonthName(details.date),
            style: TextStyle(
              fontSize: 18,
              color: lightGrayColor.withAlpha(200),
            ),
          ),
          const SizedBox(height: 16),

          if (details.note != "") ...[
            Text("Note", style: TextStyle(color: whiteColor, fontSize: 18)),
            const SizedBox(height: 2),
            Text(
              details.note,
              style: TextStyle(fontSize: 18, color: lightGrayColor),
            ),

            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

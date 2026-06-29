import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tracker/enums/transaction_type.dart';
import 'package:tracker/providers/chart_data_provider.dart';
import 'package:tracker/providers/transaction_filter_provider.dart';
import 'package:tracker/providers/transaction_rollup_api_provider.dart';
import 'package:tracker/utils/capitalize.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/getTransactionType.dart';

class ExpenseTypeDropdown extends ConsumerWidget {
  const ExpenseTypeDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionFilterController = ref.read(
      transactionFilterProvider.notifier,
    );
    final transactionFilterState = ref.watch(transactionFilterProvider);
    final chartDataController = ref.read(
      chartDataProvider(transactionFilterState.periodType).notifier,
    );
    // final transactionController = ref.read(transactionListProvider.notifier);
    final transactionRollupController = ref.read(
      transactionRollupApiProvider.notifier,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text(
            '${transactionFilterState.type.name.capitalize()} Graph',
            style: TextStyle(
              fontSize: 20,
              color: getColorByTransactionType(transactionFilterState.type),
              // color: transactionFilterState.type == "Income" ? greenColor : redColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: getColorByTransactionType(
              transactionFilterState.type,
            ).withAlpha(190),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TransactionType>(
              isDense: true,
              value: transactionFilterState.type,
              icon: Icon(Icons.arrow_drop_down, color: whiteColor),
              style: TextStyle(color: whiteColor, fontSize: 16),
              dropdownColor: darkGrayColor,
              onChanged: (TransactionType? newValue) async {
                if (newValue != null) {
                  transactionFilterController.setType(newValue);
                  final transactions = await transactionRollupController
                      .getStats(
                        transactionFilterState.periodType,
                        transactionFilterState.startDate,
                        transactionFilterState.endDate,
                        newValue,
                      );

                  chartDataController.updateChartFromTransactions(transactions);
                }
              },
              items: TransactionType.values
                  .map<DropdownMenuItem<TransactionType>>((
                    TransactionType value,
                  ) {
                    return DropdownMenuItem<TransactionType>(
                      value: value,
                      child: Text(
                        value.name.capitalize(),
                        style: TextStyle(color: whiteColor),
                      ),
                    );
                  })
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

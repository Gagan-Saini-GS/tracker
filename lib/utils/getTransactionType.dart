import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tracker/enums/transaction_type.dart';
import 'package:tracker/utils/constants.dart';

String getTransactionType(TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return "Expense";
    case TransactionType.income:
      return "Income";
    case TransactionType.saving:
      return "Saving";
    case TransactionType.withdraw:
      return "Withdraw";
  }
}

Color getColorByTransactionType(TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return redColor;
    case TransactionType.income:
      return greenColor;
    case TransactionType.saving:
      return blueColor;
    case TransactionType.withdraw:
      return blackColor;
  }
}

IconData getIconByType(TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return Icons.trending_down_outlined;
    case TransactionType.income:
      return Icons.trending_up_outlined;
    case TransactionType.saving:
      return Icons.account_balance_outlined;
    case TransactionType.withdraw:
      return Icons.wallet;
  }
}

String getLoadingByTransactionType(TransactionType type) {
  switch (type) {
    case TransactionType.expense:
      return "Loading Expenses...";
    case TransactionType.income:
      return "Loading Incomes...";
    case TransactionType.saving:
      return "Loading Savings...";
    case TransactionType.withdraw:
      return "Loading Withdraws...";
  }
}

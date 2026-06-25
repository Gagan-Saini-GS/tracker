import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/providers/transaction_provider.dart';
import 'package:tracker/providers/user_api_provider.dart';
import 'package:tracker/screens/home/balance_card.dart';
import 'package:tracker/screens/home/transaction_item.dart';
import 'package:tracker/utils/constants.dart';
import 'package:tracker/utils/formatDate.dart';
import 'package:tracker/utils/getGreeting.dart';
import 'package:tracker/widgets/loader.dart';
import '../../widgets/bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(recentTransactionListProvider.notifier)
          .fetchRecentTransactions();
      ref.read(userApiProvider.notifier).fetchUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userApiProvider);

    return Scaffold(
      backgroundColor: blackColor,
      body: Stack(
        children: [
          /// Green Header
          Container(color: greenColor),

          /// Decorative circle
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: whiteColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
            ),
          ),

          /// Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getGreeting(),
                            style: TextStyle(color: whiteColor, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          userState.isLoading && userState.user == null
                              ? Loader(
                                  showText: false,
                                  transparent: true,
                                  loaderSize: 20,
                                  stroke: 2,
                                  containerWidth: 100,
                                  containerPadding: 2,
                                  isCenter: false,
                                )
                              : Text(
                                  userState.user?.name ?? "",
                                  style: TextStyle(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                        ],
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: whiteColor.withAlpha(65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          onPressed: () => context.go("/profile"),
                          icon: Icon(Icons.person_outline, color: whiteColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Bottom Content
          Positioned.fill(
            top: 140,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                /// Main Card
                Positioned.fill(
                  top: 90,
                  child: Container(
                    decoration: BoxDecoration(
                      color: darkGrayColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 90),
                      child: _buildTransactionHistory(),
                    ),
                  ),
                ),

                /// Floating Balance Card
                const Positioned(
                  left: 20,
                  right: 20,
                  top: 0,
                  child: BalanceCard(),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavBar(currentIndex: 0),

      floatingActionButton: FloatingActionButton(
        backgroundColor: greenColor,
        onPressed: () => context.push("/add-transaction"),
        child: Icon(Icons.add, color: whiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTransactionHistory() {
    final transactionsState = ref.watch(recentTransactionListProvider);
    final transactions = transactionsState.transactions;

    if (transactionsState.isLoading && transactions.isEmpty) {
      return Center(
        child: Loader(
          title: "Loading Recent Transactions...",
          transparent: true,
          foregroundColor: whiteColor,
          backgroundColor: darkGrayColor,
          textStyle: TextStyle(color: whiteColor),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              InkWell(
                onTap: () => context.go("/wallet"),
                child: Text(
                  "See all",
                  style: TextStyle(
                    color: greenColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: transactions.isEmpty
              ? Center(
                  child: Text(
                    "No Transactions Yet.",
                    style: TextStyle(
                      color: grayColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    return TransactionItem(
                      iconAsset: null,
                      title: tx.name,
                      date: formatDateTimeWithMonthName(tx.date),
                      amount:
                          "${tx.isIncome ? '+' : '-'} ₹${tx.amount.toStringAsFixed(2)}",
                      isIncome: tx.isIncome,
                      transactionId: tx.id,
                      type: tx.type,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

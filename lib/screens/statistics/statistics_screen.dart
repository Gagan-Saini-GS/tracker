import 'package:flutter/material.dart';
import 'package:tracker/screens/statistics/expense_type_dropdown.dart';
import 'package:tracker/screens/statistics/graph_screen.dart';
import 'package:tracker/screens/statistics/time_filter_button.dart';
import 'package:tracker/widgets/bottom_nav_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black87),
        //   onPressed: () {
        //     context.go("/home");
        //   },
        // ),
        // centerTitle: true,
        title: const Text(
          'Statistics',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF63B5AF).withAlpha(65),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () {
                // Handle Download click
              },
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.file_download_outlined,
                  color: const Color(0xFF63B5AF),
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TimeFilterButtons(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                child: ExpenseTypeDropdown(),
              ),
            ),
            const ReusableLineChart(),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Spending',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(Icons.sort, color: Colors.grey[600]),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Example of spending list items
            _buildSpendingListItem(
              context,
              'Starbucks',
              'Jan 12, 2022',
              '- \$150.00',
              Colors.red,
              'https://placehold.co/40x40/00704A/ffffff?text=SB', // Placeholder for Starbucks logo
            ),
            _buildSpendingListItem(
              context,
              'Transfer',
              'Yesterday',
              '- \$85.00',
              const Color(0xFF2D9C9A),
              'https://placehold.co/40x40/2D9C9A/ffffff?text=TR', // Placeholder for Transfer icon
              isHighlighted: true,
            ),
            _buildSpendingListItem(
              context,
              'Youtube',
              'Jan 16, 2022',
              '- \$11.99',
              Colors.red,
              'https://placehold.co/40x40/FF0000/ffffff?text=YT', // Placeholder for Youtube logo
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildSpendingListItem(
    BuildContext context,
    String title,
    String date,
    String amount,
    Color amountColor,
    String imageUrl, {
    bool isHighlighted = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: isHighlighted ? 2 : 1,
      shadowColor: isHighlighted ? const Color(0xFF63B5AF) : Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isHighlighted
          ? const Color(0xFFE0F2F1)
          : Colors.white, // Light teal for highlighted
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          // backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(date, style: TextStyle(color: Colors.grey[600])),
        trailing: Text(
          amount,
          style: TextStyle(
            color: amountColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

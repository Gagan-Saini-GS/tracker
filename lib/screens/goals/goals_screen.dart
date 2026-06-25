import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tracker/utils/constants.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreenColor,
        title: Text(
          "Goals",
          style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: whiteColor),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: whiteColor),
              borderRadius: BorderRadius.circular(4),
              color: whiteColor.withAlpha(60),
            ),
            margin: EdgeInsets.only(right: 12),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.add, color: whiteColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: darkGrayColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          "Goal Screen is here!",
          style: TextStyle(color: whiteColor),
        ),
      ),
    );
  }
}

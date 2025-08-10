import 'package:flutter/material.dart';
import 'package:tracker/utils/constants.dart';

class Loader extends StatelessWidget {
  final String title;
  const Loader({super.key, this.title = "Loading..."});

  @override
  Widget build(BuildContext context) {
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
          Text(title, style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

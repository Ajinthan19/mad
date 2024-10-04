import 'package:flutter/material.dart';

class OrderSummaryPage extends StatelessWidget {
  final String userName;
  final String roomName;
  final String date;
  final String timeSlot;

  OrderSummaryPage({
    Key? key,
    required this.userName,
    required this.roomName,
    required this.date,
    required this.timeSlot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary for $userName',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Room: $roomName'),
            Text('Date: $date'),
            Text('Time Slot: $timeSlot'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// class BillDetailsScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> orderData;
//   final String timestamp;
//
//   BillDetailsScreen({required this.orderData, required this.timestamp});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bill Details'),
//       ),
//       body: Column(
//         children: [
//           // Display the order data and timestamp here
//           // You can customize the UI to display the data in the desired format
//           Text('Order Details:', style: TextStyle(fontWeight: FontWeight.bold)),
//           ListView.builder(
//             shrinkWrap: true,
//             itemCount: orderData.length,
//             itemBuilder: (context, index) {
//               return ListTile(
//                 title: Text(orderData[index]['productName']),
//                 subtitle: Text('Quantity: ${orderData[index]['quantity']}'),
//               );
//             },
//           ),
//           SizedBox(height: 20),
//           Text('Timestamp: $timestamp', style: TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/product_provider/product_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orderHistory = Provider.of<ProductProvider>(context).orderHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {
          final order = orderHistory[index];
          final customerName = order['customerName'];
          final orderData = order['orderData'];
          final timestamp = order['timestamp'];

          return OrderItem(
            customerName: customerName,
            orderData: orderData,
            timestamp: timestamp,
          );
        },
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String customerName;
  final List<Map<String, dynamic>> orderData;
  final String timestamp;

  OrderItem({
    required this.customerName,
    required this.orderData,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Name: $customerName',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Order Details:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(orderData[index]['productName']),
                  subtitle: Text('Quantity: ${orderData[index]['quantity']}'),
                );
              },
            ),
            SizedBox(height: 8),
            Text(
              'Timestamp: $timestamp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

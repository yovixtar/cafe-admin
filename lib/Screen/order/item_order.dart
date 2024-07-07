import 'package:admin/Model/order_model.dart';
import 'package:admin/color.dart';
import 'package:flutter/material.dart';

class OrderListItem extends StatelessWidget {
  final OrderModel order;
  final bool isQueue;
  final VoidCallback onTap;

  OrderListItem({
    required this.order,
    required this.isQueue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              isQueue ? primaryColor : Color.fromARGB(255, 225, 225, 225),
          child: Text(
            order.noMeja + order.namaPemesan[0],
            style: TextStyle(
              color: isQueue ? Colors.white : Colors.black,
            ),
          ),
        ),
        title: Text(order.namaPemesan,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Meja ${order.noMeja}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

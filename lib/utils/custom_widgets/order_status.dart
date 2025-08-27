import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../languages/translation_keys.dart' as lang_key;
import '../constants.dart';

/// Order status widget
class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({super.key, required this.orderStatus});

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Container(
            constraints: BoxConstraints(
                maxWidth: 100,
                maxHeight: 40
            ),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(
                    color: switch(orderStatus) {

                      OrderStatus.pending => Colors.pinkAccent,
                      OrderStatus.accepted => Colors.deepOrangeAccent,
                      OrderStatus.ongoing => Colors.green,
                      OrderStatus.completed => primaryBlue,
                      OrderStatus.cancelled => Colors.red,
                      OrderStatus.disputed => Colors.red.shade800,
                    },
                    width: 1
                ),
                borderRadius: kContainerBorderRadius
            ),
            child: Text(
              '• ${switch(orderStatus) {
                OrderStatus.pending => lang_key.pending.tr,
                OrderStatus.accepted => lang_key.accepted.tr,
                OrderStatus.ongoing => lang_key.ongoing.tr,
                OrderStatus.completed => lang_key.completed.tr,
                OrderStatus.cancelled => lang_key.cancelled.tr,
                OrderStatus.disputed => lang_key.disputed.tr,
              }
              }',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: switch(orderStatus) {

                  OrderStatus.pending => Colors.pinkAccent,
                  OrderStatus.accepted => Colors.deepOrangeAccent,
                  OrderStatus.ongoing => Colors.green,
                  OrderStatus.completed => primaryBlue,
                  OrderStatus.cancelled => Colors.red,
                  OrderStatus.disputed => Colors.red.shade800,
                },
              ),
            )
        ),
      ),
    );
  }
}
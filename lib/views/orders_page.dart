// ignore_for_file: use_build_context_synchronously

import 'package:findit_admin_app/controllers/db_service.dart';
import 'package:findit_admin_app/models/orders_model.dart';
import 'package:findit_admin_app/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products
        .map(
          (e) => qty += e.quantity,
        )
        .toList();
    return qty;
  }

  Widget statusContainer(
      {required String text,
      required Color bgColor,
      required Color textColor}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget statusIcon(String status) {
    if (status == "PAID") {
      return statusContainer(
          text: "PAID", bgColor: Colors.blue, textColor: Colors.white);
    }
    if (status == "ON_THE_WAY") {
      return statusContainer(
          text: "ON THE WAY", bgColor: Colors.amber, textColor: Colors.black);
    } else if (status == "DELIVERED") {
      return statusContainer(
          text: "DELIVERED",
          bgColor: Colors.green.shade700,
          textColor: Colors.white);
    } else {
      return statusContainer(
          text: "CANCELED", bgColor: Colors.redAccent, textColor: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Consumer<AdminProvider>(
        builder: (context, value, child) {
          List<OrdersModel> orders = OrdersModel.fromJsonList(value.orders);

          if (orders.isEmpty) {
            return const Center(
              child: Text("No orders yet."),
            );
          } else {
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, "/view_orders",
                        arguments: orders[index]);
                  },
                  title: Text(
                      "Order by ${orders[index].name} of items worth ₹${orders[index].total}"),
                  subtitle: Text(
                      "Ordered on ${DateTime.fromMillisecondsSinceEpoch(orders[index].createdAt).toString()}"),
                  trailing: statusIcon(orders[index].status),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ViewOrders extends StatefulWidget {
  const ViewOrders({super.key});

  @override
  State<ViewOrders> createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Summary",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Delivery Details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Order Id: ${args.id}"),
                    Text(
                        "Order On : ${DateTime.fromMillisecondsSinceEpoch(args.createdAt).toString()}"),
                    Text("Order by : ${args.name}"),
                    Text("Phone no : ${args.phone}"),
                    Text("Delivery Address : ${args.address}"),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: args.products
                    .map(
                      (e) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      e.image,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(e.name))
                              ],
                            ),
                            Text(
                              "₹${e.singlePrice} x ${e.quantity} quantity",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${e.totalPrice}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discount: ₹${args.discount}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Total Amount: ₹${args.total}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Order Status: ${args.status}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .8,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ModifyOrder(
                            ordersModel: args,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent.shade400,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: const Text(
                        "Modify Order",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel ordersModel;
  const ModifyOrder({super.key, required this.ordersModel});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Modify this order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text("Choose want you want to do with the Order"),
          ),
          TextButton(
            onPressed: () async {
              await DbService()
                  .updateOrderStatus(docId: widget.ordersModel.id, data: {
                "status": "PAID",
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Order Paid by User",
            ),
          ),
          TextButton(
            onPressed: () async {
              await DbService()
                  .updateOrderStatus(docId: widget.ordersModel.id, data: {
                "status": "ON_THE_WAY",
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Order Shipped",
            ),
          ),
          TextButton(
            onPressed: () async {
              await DbService()
                  .updateOrderStatus(docId: widget.ordersModel.id, data: {
                "status": "DELIVERED",
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Order Delivered",
            ),
          ),
          TextButton(
            onPressed: () async {
              await DbService()
                  .updateOrderStatus(docId: widget.ordersModel.id, data: {
                "status": "CANCELLED",
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              "Cancel Order",
            ),
          ),
        ],
      ),
    );
  }
}

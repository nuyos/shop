import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_admin/models/order.dart';
import 'package:shop_admin/models/product.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({Key? key}) : super(key: key);

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<OrderItem> orders = [];

  Future<void> readProductsData() async {
    QuerySnapshot ordersSnapshot =
    await FirebaseFirestore.instance.collection('order').get();

    for (QueryDocumentSnapshot orderDocument in ordersSnapshot.docs) {
      Map<String, dynamic>? orderData = orderDocument.data() as Map<String, dynamic>?;
      String orderId = orderData!['orderId'];
      String name = orderData!['name'];
      String statement = orderData!['statement'];
      String address = orderData!['address'];
      String payment = orderData!['payment'];

      orders.add(
        OrderItem(
          orderId: orderId,
          name: name,
          statement: statement,
          address: address,
          payment: payment,
        ),
      );
    }
  }

  Future<void> checkOrder(int index) async {
    String? orderId = orders[index].orderId;

    await FirebaseFirestore.instance.collection('order').doc("$orderId").update({
      'statement': '배송',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('배송하였습니다!'),
      ),
    );

    setState(() {
      orders[index].statement = '배송';
    });
  }

  Future<void> cancelOrder(int index) async {
    String? orderId = orders[index].orderId;

    await FirebaseFirestore.instance.collection('order').doc("$orderId").update({
      'statement': '취소',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('결제 취소 바랍니다.'),
      ),
    );

    setState(() {
      orders[index].statement = '취소';
    });
  }


  @override
  void initState() {
    readProductsData();
    super.initState();
  }

  Widget _OrderWidget() {
    return ListView.separated(
      itemBuilder: (BuildContext _context, int index) {
        return Container(
          child: Row(
            children: [
              Container(height: 150, width: 20, color: Colors.black,),
              Expanded(
                child: Container(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orders[index].orderId ?? ""),
                      Text(orders[index].payment ?? ""),
                      Text(orders[index].name ?? ""),
                      Text(orders[index].address ?? ""),
                      Text(orders[index].statement ?? ""),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){checkOrder(index);}, icon: Icon(Icons.check,size:20)),
                            SizedBox(width: 1.0,),
                            IconButton(onPressed: (){cancelOrder(index);}, icon: Icon(Icons.keyboard_return,size:20))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext _context, int index) {
        return Container(height: 1, color: Colors.black.withOpacity(0.4),);
      },
      itemCount: orders.length,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 리스트'),),
      body: _OrderWidget(),
    );
  }
}

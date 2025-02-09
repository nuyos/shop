import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_admin/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ItemViewPage extends StatefulWidget {
  const ItemViewPage({Key? key}) : super(key: key);

  @override
  State<ItemViewPage> createState() => _ItemViewPageState();
}

class _ItemViewPageState extends State<ItemViewPage> {
  List<Product> products = [];

  Future<void> readProductsData() async {
    QuerySnapshot productsSnapshot =
    await FirebaseFirestore.instance.collection('Product').get();

    if (productsSnapshot.docs.isEmpty) {
      print('!!!!!!!');
      return;
    }

    for (QueryDocumentSnapshot productDocument in productsSnapshot.docs) {
      Map<String, dynamic>? productData = productDocument.data() as Map<String, dynamic>?;
      String productName = productData!['productName'];
      String productDetails = productData['productDetails'];
      double price = productData['price']?.toDouble() ?? 0.0;
      String productNo = productDocument.id;
      String productImageUrl= productData!['productImageUrl'];


      products.add(
        Product(
          productNo: productNo,
          productName: productName,
          productDetails: productDetails,
          price: price,
          productImageUrl: productImageUrl,
        ),
      );

    }
  }

  Future<void> deleteProduct(int index) async {
    String productNo = products[index].productNo ?? "";
    String productName = products[index].productName ?? "";

    FirebaseStorage.instance.ref().child("product").child(productNo).delete();
    await FirebaseFirestore.instance.collection('Product').doc("$productNo").delete();
    setState(() {
      products.removeAt(index);
    });
    print("$productNo");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('물품이 내려갔습니다.'),
      ),
    );
  }

  @override
  void initState() {
    readProductsData();
    super.initState();
  }

  Widget _listWidget() {
    return ListView.separated(
      itemBuilder: (BuildContext _context, int index) {
        return Container( height: 120,
          child: Row(
            children: [
              Container(height: 100, width: 100,
                child: Image.network(products[index].productImageUrl ?? ""),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(products[index].productName ?? ""),
                      Text(products[index].productDetails ?? ""),
                      Text(products[index].price.toString() ?? ""),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                deleteProduct(index);
                              },
                              icon: Icon(Icons.delete, size: 20),
                            )
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
      itemCount: products.length,
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('상품 리스트'),),
      body: _listWidget(),
    );
  }
}

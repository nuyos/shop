import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_user/model/product.dart';
import 'package:shop_user/model/user.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({super.key});

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  List<Product> products = [];
  List<Product> noproducts =[];
  int itemcount =0;

  Future<void> readProductsData() async {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    QuerySnapshot productsSnapshot =
    await FirebaseFirestore.instance.collection('user_wish').doc("${userInfoProvider.userInfo.userId}").collection('wishlist').get();


    QuerySnapshot productlistSnapshot =
    await FirebaseFirestore.instance.collection('Product').get();

    if (productsSnapshot.docs.isEmpty) {
    print('!!!!!!!');
    return;
    }

    for (QueryDocumentSnapshot productDocument in productsSnapshot.docs) {
    Map<String, dynamic>? productData = productDocument.data() as Map<String, dynamic>?;
    String productName = productData!['productName'];
    double price = productData['price']?.toDouble() ?? 0.0;
    String productNo = productDocument.id;
    String productImageUrl= productData['productImageUrl'];


    //실제 물건이 있는지 확인하는 과정
    for (QueryDocumentSnapshot productlistDocument in productlistSnapshot.docs) {
      String productNolist = productlistDocument.id;
      if(productNo==productNolist) {
       itemcount=1;
      }
    }
    if(itemcount==1) {
      products.add(
        Product(
          productNo: productNo,
          productName: productName,
          price: price,
          productImageUrl: productImageUrl,
        ),
      );
    }else {
      noproducts.add(
        Product(
          productNo: productNo,
          productName: productName,
          price: price,
          productImageUrl: productImageUrl,
        ),
      );
    }

    itemcount=0;
    }

    for(int i=0; i<noproducts.length ; i++){
      String? noproductNo = noproducts[i].productNo;
      UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
      await FirebaseFirestore.instance.collection('user_wish').doc("${userInfoProvider.userInfo.userId}").collection('wishlist').doc("$noproductNo").delete();
    }


  }

  Future<void> deleteProduct(int index) async {
    String? productNo = products[index].productNo;
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    await FirebaseFirestore.instance.collection('user_wish').doc("${userInfoProvider.userInfo.userId}").collection('wishlist').doc("$productNo").delete();
    setState(() {
    products.removeAt(index);
    });
    print("$productNo");
    }

  @override
  void initState() {
  readProductsData();
  super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (BuildContext _context, int index) {
        return Container(height: 120,
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
}

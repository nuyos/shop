import 'package:flutter/material.dart';
import 'package:shop_user/model/cart.dart';
import 'package:shop_user/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:shop_user/model/cart_model.dart';
import 'package:shop_user/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_user/model/product.dart';


class ProductDetailPage extends StatefulWidget {
  final String image;
  final String productName;
  final String price;
  final String productDetails;
  final String productNo;

  final List<CartItem> cartItems;

  ProductDetailPage({
    required this.image,
    required this.productName,
    required this.price,
    required this.productDetails,
    required this.productNo,
    required this.cartItems, // 수정된 부분
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.productName}의 상세 정보',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: LIGHT_GREY_COLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.image,
              width: double.infinity,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16.0),
            Text(
              widget.productName,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              "₩${widget.price}",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16.0),
            Text(widget.productDetails,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 3, // 3:1 비율로 설정
              child: FilledButton(
                onPressed: () {
                  addToCart();
                },
                child: const Text("장바구니"),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 1, // 3:1 비율로 설정
              child: FilledButton(
                onPressed: () {
                  addToWishList();
                },
                child: const Text("찜"), // 버튼 이름
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  disabledForegroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addToCart() {
    final cart = Provider.of<CartModel>(context, listen: false);

    CartItem newItem = CartItem(
      productName: widget.productName,
      productNo: widget.productNo,
      count: 1,
      price: double.parse(widget.price) ?? 0,
    );


    cart.add(newItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('장바구니에 추가되었습니다.'),
      ),
    );
  }

  void addToWishList() async {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    //확인용 print("${userInfoProvider.userInfo.userId}");
    if(userInfoProvider.userInfo.userId!=null){
      await FirebaseFirestore.instance.collection('user_wish').doc("${userInfoProvider.userInfo.userId}").collection('wishlist').doc('${widget.productNo}').set(
          Product(
            productNo: "${widget.productNo}",
            productName: "${widget.productName}",
            productImageUrl: "${widget.image}",
            price: double.parse(widget.price) ?? 0,
          ).toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('위시리스트에 추가되었습니다.'),
        ),
      );
    }
  }
  }





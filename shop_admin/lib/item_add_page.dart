import 'package:flutter/material.dart';
import 'package:shop_admin/custom_textfield.dart';
import 'dart:io';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:shop_admin/item_view_page.dart';

import 'package:shop_admin/models/product.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ItemAddPage extends StatefulWidget {
  const ItemAddPage({super.key});

  @override
  State<ItemAddPage> createState() => _ItemAddPageState();
}

class _ItemAddPageState extends State<ItemAddPage> {
  final formKey = GlobalKey<FormState>();

  //image
  XFile? _image; //이미지를 담을 변수 선언
  ImagePicker picker = ImagePicker(); //ImagePicker 초기화



  String? productNo;
  String? productName;
  String? productImageUrl;
  String? productDetail;
  double? price;
  var now = DateTime.now();

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource,maxHeight: 100,maxWidth: 100,);

    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path);//가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("품목 추가"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPhotoArea(),
                ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                  },
                  child: Text("갤러리"),
                ),
              ],
            ),),
            Expanded(child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: "이름",
                      onSaved: (String? val) {
                        productName = val;
                      },
                      validator: stringValidator),),
                  Expanded(child: CustomTextField(
                      label: "물건 상세 정보",
                      onSaved: (String? val) {
                        productDetail = val;
                      },
                      validator: stringValidator),),
                  Expanded(child: CustomTextField(
                      label: "가격",
                      onSaved: (String? val) {
                        price = double.parse(val!);
                      },
                      validator: intValidator),),
                ],
              ),
            ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () => onSavePressed(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
            ),
            child: const Text('저장'),
          ),
        ),

      );
    }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
      width: 100,
      height: 100,
      child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
    )
        : Container(
      width: 100,
      height: 100,
      color: Colors.grey,
    );
  }

  void onSavePressed(BuildContext context) async {
    int i = Random().nextInt(1000)+10000;
    productNo = "$productName.$i";

    formKey.currentState!.save();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String _imgRef = "product/$productName$i";



    FirebaseStorage.instance.ref().child(_imgRef).putFile(File(_image!.path));
    print(_imgRef);
    final url = "https://storage.googleapis.com/shopping-app-9f5c9.appspot.com/$_imgRef";

    await firestore.collection("Product").doc("$productName$i").set(Product(
      productNo: "$productName$i",
      productName: "$productName",
      productDetails: "$productDetail",
      price: double.parse("$price"),
      productImageUrl: "$url",
    ).toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('물품이 등록되었습니다.'),
      ),
    );

    //여기 추가해봄
    setState(() {
      ItemViewPage();
    });


  }

  String? intValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    } else {
      try {
        number = int.parse(val);
      } catch (e) {
        return '숫자를 입력해주세요';
      }
    }

    return null;
  }

  String? stringValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해주세요';
    }

    return null;
  }
}

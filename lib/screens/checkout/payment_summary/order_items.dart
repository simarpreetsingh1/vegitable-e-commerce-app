import 'package:flutter/material.dart';
import 'package:restaurant/models/reviewcart_model.dart';
class OrderItems extends StatelessWidget {
  final ReviewCartModel e;
  OrderItems({required this.e});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(e.cartImage,width: 60,),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(e.cartName,style: TextStyle(color: Colors.grey[600],),),
          Text(e.cartQuantity.toString(),style: TextStyle(color: Colors.grey[600],),),
          Text(e.cartPrice.toString(),style: TextStyle(color: Colors.black,),),
        ],),
    );
  }
}

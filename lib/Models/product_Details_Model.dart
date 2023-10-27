import 'package:shopapp/Models/favorites_Model.dart';

class Product_Details_Model
{
  bool? status;
  Data? data;

  Product_Details_Model.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data
{
  int? id;
  dynamic price;
  dynamic old_price;
  int? discount;
  String? image;
  String? name;
  String? description;
  bool? in_favorites;
  bool? in_cart;
  List<String> images = [];

  Data.fromJson(Map<String,dynamic> json)
  {
    id = json['id'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    in_favorites = json['in_favorites'];
    in_cart = json['in_cart'];
    json['images'].forEach((e)
    {
      images.add(e.toString());
    });
  }
}
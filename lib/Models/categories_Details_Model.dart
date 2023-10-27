class Categories_Details_Model
{
  bool? status;
  String? message;
  late Data data;


  Categories_Details_Model.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    data = json['data'] = Data.fromJson(json['data']) ;
  }

}



class Data
{
  List<Product> data = [];


  Data.fromJson(Map<String, dynamic> json)
  {

    if (json['data'] != null)
    {
      json['data'].forEach((e)
      {
        data.add( Product.fromJson(e));
      });
    }
  }
}


class Product
{
  int? id;
  dynamic price;
  dynamic oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;



  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

}

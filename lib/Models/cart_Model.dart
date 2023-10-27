class Cart_Model
{
  bool? status;

  Data? data;

  Cart_Model.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data
{

  List<Cart_items> cart_items = [];

  dynamic sub_total;

  dynamic total;

  Data.fromJson(Map<String,dynamic> json)
  {
    sub_total = json['sub_total'];
    total = json['total'];

    json['cart_items'].forEach((e)
    {
      cart_items.add(Cart_items.fromJson(e));
    });

  }
}

class Cart_items
{

  int? cart_item_id;
  int? quantity;
  Product? product;

  Cart_items.fromJson(Map<String,dynamic> json)
  {
    cart_item_id = json['id'];
    quantity = json['quantity'];
    product = Product.fromJson(json['product']);

  }
}

class Product
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

  Product.fromJson(Map<String,dynamic> json)
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

  }
}
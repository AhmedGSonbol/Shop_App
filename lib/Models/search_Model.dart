class Search_Model
{
  bool? status;
  String? message;
  late SearchData data;


  Search_Model.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    message = json['message'];
    data = json['data'] = SearchData.fromJson(json['data']) ;
  }

}



class SearchData
{
  List<Search_Product> data = [];

  SearchData.fromJson(Map<String, dynamic> json)
  {
    if (json['data'] != null)
    {
      json['data'].forEach((v)
      {
        data.add(new Search_Product.fromJson(v));
      });
    }

  }


}



class Search_Product
{
  int? id;
  dynamic price;
  String? image;
  String? name;
  String? description;



  Search_Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    //oldPrice = json['old_price'];
    //discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

}


class Categories_Model
{
  bool? status;
  CategoriesDataModel? data;

  Categories_Model.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel
{
  int? CurrentPage;
  List<CategoriesData> data = [];
  CategoriesDataModel.fromJson(Map<String,dynamic> json)
  {
    CurrentPage = json['current_page'];

    json['data'].forEach((element)
    {
      data.add(CategoriesData.fromJson(element));
    });
  }
}

class CategoriesData
{
  int? ID;
  String? Name;
  String? Image;

  CategoriesData.fromJson(Map<String,dynamic> json)
  {
    ID = json['id'];
    Name = json['name'];
    Image = json['image'];
  }
}

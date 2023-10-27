class Change_Favorites_Model
{
  bool? status;
  String? message;

  Change_Favorites_Model.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    message = json['message'];
  }

}
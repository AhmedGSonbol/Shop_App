class Change_Cart_Model
{
  bool? status;
  String? message;

  Change_Cart_Model.fromJson(Map<String,dynamic> json)
  {
    status = json['status'];
    message = json['message'];
  }
}
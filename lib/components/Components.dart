
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:like_button/like_button.dart';
import 'package:shopapp/Modules/products_Details/products_Details_Screen.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/cubit/cubit.dart';

void navTo(context , route)
{
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => route));
}

void navAndFinishTo(context , route)
{
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => route));
}

Widget myButton({

  required String text,
  required void Function() function,

  double radius = 0.0,
  bool isUpperCase = true,
  Color textColor = Colors.white,
  double width = double.infinity,
  Color color = Colors.blue,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius)
    ),

    child: MaterialButton(
      height: 50.0,
      onPressed: function,
      child: Text(
        isUpperCase ?  text.toUpperCase() : text,
        style: TextStyle(color: textColor),),
    ),
  );
}


Widget myTextButton({
  required String text,
  required void Function() function,
}) => TextButton(child: Text(text.toUpperCase()) , onPressed: function,);



Widget myTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String labelText,
  required Icon prefixIcon,
  required String? Function(String? x) validator,
  required context,

  void Function(String x)?  onChanged,
  void Function(String x)?  onFieldSubmitted,
  // void Function() SuffixOnPressed  = (){},
  bool isPassword = false,
  // Widget? suffixIcon,
  IconButton? suffixButtonIcon ,

})
{
  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: isPassword,
    style: TextStyle(color: fontColor(context)),
    decoration: InputDecoration(
      prefixIconColor: fontColor(context),
        suffixIconColor: fontColor(context),
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixButtonIcon,
        labelStyle: TextStyle(color: fontColor(context)),
        // IconButton(
        //   icon: suffixIcon!,
        //   onPressed: SuffixOnPressed,
        // ),
        border: OutlineInputBorder()
    ),

    validator: validator,
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
  );
}


void myToast({
  required String msg,
  required ToastStates state,

  Color textColor = Colors.white,
  Toast toastLength = Toast.LENGTH_LONG,
  ToastGravity gravity = ToastGravity.BOTTOM,
  int timeInSecForIosWeb = 1,
  double fontSize = 16.0,


})
{
      Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor(state),
      textColor: textColor,
      fontSize: fontSize,
  );
}

enum ToastStates {SUCCESS , ERROR , WARNING}

Color backgroundColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}


Widget myDivider() => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0),
  child: Container(width: double.infinity , height: 2.0 ,color: Colors.grey.withOpacity(0.5),),
);


Widget buildProductItem(product , context,{bool isSearch = false})
{
  return

    InkWell(
      onTap: ()
      {
        navTo(context , Products_Details(product!.id));
      },
      child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  border: Border.all(color: fontColor(context),width: 2.0)
              ),
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children:
                [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Image(image: NetworkImage('${product!.image}'),
                      width: 120.0,
                      height: 120.0,

                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 130.0,
                        width: 120.0,
                        child: Center(child: Icon(Icons.error,color: Colors.grey,size: 40.0,)),
                      ),
                    ),
                  ),
                  if(isSearch == false && product.discount != 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text('DISCOUNT',
                            style: TextStyle(
                                fontSize: 10.0,
                                color: Colors.white
                            ),
                          ),
                        ),

                      ),
                    )
                ],
              ),
            ),
            SizedBox(width: 20.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.3,
                        color: fontColor(context)

                    ),
                  ),

                  Spacer(),

                  Row(
                    children: [
                      Text('${product.price!.round()}\$',
                        style: TextStyle(
                            color: DefaultColor
                        ),
                      ),

                      SizedBox(width: 5.0,),

                      if(isSearch == false && product.discount != 0)
                        Text('${product.oldPrice!.round()}',
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 10.0,
                              color: Colors.grey
                          ),
                        ),
                      Spacer(),
                      LikeButton(
                        isLiked: ShopCubit.get(context).infavourites[product.id] ,
                        onTap:  (bool x) async
                        {
                          ShopCubit.get(context).changeFavorites(product.id);
                          return true;
                        },
                      )


                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
  ),
    );
}

Widget myCachedNetworkIMG({required String url , double? width , double? height , BoxFit? fit})
{
  return CachedNetworkImage(
    imageUrl: url,
     width: width,
     height: height,
    fit: fit,

    errorWidget: (context, url, error) => Container(
      height: height,
      width: width,
      child: Center(child: Icon(Icons.error,color: Colors.grey,size: 40.0,),),),
  );
}


void myDialog(context,Function() refresh)
{
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context)
    {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,

        child: Stack(
          children: [
            Container(
              // padding: EdgeInsets.only(top: 200),
              height: 300,
              color: Colors.transparent,

            ),

            Container(
              margin: EdgeInsets.only(top: 50),
              padding: EdgeInsets.only(top: 70.0,left: 20,right: 20),

              height: 240,
              width: 300,
              decoration: BoxDecoration(
                color: ShopCubit.get(context).isDarkMode ? darkColor : Colors.white,
                borderRadius: BorderRadius.circular(25.0),
                shape: BoxShape.rectangle,
                boxShadow:
                [
                  BoxShadow(color: Colors.black,blurRadius: 10.0,offset: Offset(0,10))
                ]
              ),
              child: Column(
                children:
                [
                Center(
                  child: Text(
                    langConnectionError(context),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700,color: fontColor(context)),
              ),
                ),

                  Center(
                    child: Text(
                      langConnectionErrorDescription(context),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0,color: Colors.grey),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      child: Text(langreTry(context)),
                      onPressed: refresh
                    ),
                  )
                ],
              ),
            ),

            Positioned.fill(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 60.0,
                    child: Image(image: AssetImage('assets/images/offline.png')),
                    backgroundColor: Colors.transparent,
                  ),
                ),
            )


          ],


        ),

      );
    },
  );
}











import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:like_button/like_button.dart';
import 'package:shopapp/Modules/products_Details/cubit/cubit.dart';
import 'package:shopapp/Modules/products_Details/cubit/states.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Products_Details extends StatelessWidget
{
  int productID;

  Products_Details(this.productID);



  @override
  Widget build(BuildContext context)
  {


    return BlocProvider(create: (context) => ProductDetailsCubit()..getProductDetails(productID,context),
    child: BlocConsumer<ProductDetailsCubit,ProductDetailsStates>(
      listener: (context,state)
      {
        if(state is ProductDetailsCartSuccessState)
        {
          if(state.model.status!)
          {
            myToast(msg: state.model.message!, state: ToastStates.SUCCESS);
          }
          else
          {
            myToast(msg: state.model.message!, state: ToastStates.ERROR);
          }

        }
        else  if(state is ProductDetailsErrorState)
        {
          myDialog(context,()
          {
            ProductDetailsCubit.get(context).getProductDetails(productID, context);
            Navigator.of(context).pop();
          });
        }

      },
      builder: (context,state)
      {
        var cubit = ProductDetailsCubit.get(context);


        return Directionality(
            textDirection: ShopCubit.get(context).isEnglish ? TextDirection.ltr : TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(),
            floatingActionButton:
            cubit.productDetailsModel == null
                ?
            Container()
                :
            FloatingActionButton(
              child:
              ((){
                if(state is ProductDetailsCartLoadingState)
                {
                  return CircularProgressIndicator(color: Colors.white,);
                }
                else
                {
                  if(cubit.inCart!)
                  {
                    return Icon(Icons.remove_shopping_cart_outlined , );
                  }
                  else
                  {
                    return Icon(Icons.add_shopping_cart_outlined);
                  }
                }


              }()),

              backgroundColor: cubit.inCart! && state is !ProductDetailsCartLoadingState ? Colors.red : DefaultColor,

              onPressed: ()
              {
                cubit.change_Cart(productID  , context);

              },
            ),


            body:

            cubit.productDetailsModel == null
                ?
                Center(child: CircularProgressIndicator(),)
                :
            SingleChildScrollView(
              child: Column(
                children:
                [
                  CarouselSlider(
                    items: cubit.productDetailsModel!.data!.images.map((e)
                      {
                        return Container(
                          width: MediaQuery.of(context).size.width - 30,
                          color: Colors.white,
                          child: Image(image: NetworkImage(e),
                          width: double.infinity,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 130.0,
                              width: 120.0,
                              child: Center(child: Icon(Icons.error,color: Colors.grey,size: 40.0,)),
                            ),

                          ),
                        );
                      }).toList(),

                    options: CarouselOptions(
                      height: 200.0,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      viewportFraction: 1.0,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(seconds: 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index, reason)
                      {
                        cubit.changeSelectedImage(index);

                      },
                    ),

                  ),
                  SizedBox(height:15.0,),
                  AnimatedSmoothIndicator(
                    activeIndex: cubit.selectedImageIndex,
                    count: cubit.productDetailsModel!.data!.images.length,
                    effect: SwapEffect(
                        activeDotColor: DefaultColor
                    ),
                  ),
                  SizedBox(height: 20.0,),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Container(

                          child: Center(
                            child: Text(cubit.productDetailsModel!.data!.name!,style: TextStyle(fontSize: 20.0,color: fontColor(context)),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,

                            ),
                          ),
                          height: 110.0,
                        ),

                        SizedBox(height: 15.0,),

                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                               textBaseline: TextBaseline.ideographic,
                              children:
                              [
                               Text(
                                 cubit.productDetailsModel!.data!.price!.toString() + '\$',
                               style: TextStyle(fontSize: 35.0,color: fontColor(context))
                                 ),

                                SizedBox(width: 5.0,),

                                if(cubit.productDetailsModel!.data!.discount != 0)
                                  Text('${cubit.productDetailsModel!.data!.old_price!.round()}\$',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 15.0,
                                        color: Colors.grey
                                    ),
                                  ),


                              ],
                            ),
                            Spacer(),

                            LikeButton(
                              padding: EdgeInsets.all(10.0),
                              size: 40.0,
                              isLiked: cubit.inFav!,
                              onTap:  (bool x) async
                              {
                                ShopCubit.get(context).changeFavorites(productID , isProductDetails: true , context: context);
                                return true;
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 20.0,),

                        Text(cubit.productDetailsModel!.data!.description!,style: TextStyle(color: fontColor(context)),)

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}

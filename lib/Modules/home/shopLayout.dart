import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopapp/Models/cart_Model.dart';
import 'package:shopapp/Modules/login/shopLoginScreen.dart';
import 'package:shopapp/Modules/products_Details/cubit/cubit.dart';
import 'package:shopapp/Modules/search/search_Screen.dart';
import 'package:shopapp/Network/Local/Cach_Helper.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';
import 'package:badges/badges.dart' as badges;

class ShopLayout extends StatelessWidget
{

  var scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context)
  {

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},

      builder: (context, state)
      {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(langSalla(context)),
            actions:
            [
              badges.Badge(
                position: badges.BadgePosition.topEnd(top: 0, end: 5),
                badgeContent: Text('${cubit.cartItemMap.length}' , style:  TextStyle(fontSize: 8.0 , color: Colors.white)),
                showBadge: cubit.cartItemMap.length > 0 ? true : false,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: ()
                    {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      if(state is ShopLoadingCartItemsState)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(langPleaseWait(context))));

                      }
                      else if(state is ShopErrorCartItemsState)
                      {
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(langConnectionError(context))));

                      }
                      else if(cubit.cartItemMap.length == 0)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(langThereIsNoItems(context))));

                      }
                      else
                      {
                        if(!cubit.isBottomSheetShow) //false
                        {
                          showModalBottomSheet(context: context, builder: (context)
                          {
                            return BlocConsumer<ShopCubit,ShopStates>(
                                listener: (context, state) {},
                              builder: (context, state)
                              {
                                return bottomSheetContent(context, state);
                              },
                            );
                          },
                          elevation: 20.0,
                            backgroundColor: Colors.black,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(60.0),
                              ),
                          ),
                          ).then((value)
                          {
                            cubit.changeBottomSheet(false) ;
                          });

                          cubit.changeBottomSheet(true) ;
                        }
                        else
                        {
                          Navigator.of(context).pop();
                          cubit.changeBottomSheet(false);
                        }
                      }
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: IconButton(
                  icon: Icon(Icons.manage_search_sharp,size: 28.0,),
                  onPressed: ()
                  {
                    if(!cubit.isBottomSheetShow)
                    navTo(context, Search_Screen());
                  },

                ),
              ),
            ],
          ),
          body: Stack(
            children:
            [

              cubit.bottomScreens[cubit.current_index],
             // cubit.isBottomSheetShow ? Expanded(child: Container(color: Colors.black.withOpacity(0.5),)) : SizedBox(),
            ],
          ),

          bottomNavigationBar: BottomNavigationBar(
            items:
            [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: langHome(context)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.apps), label: langCategories(context)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: langFavorites(context)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: langSettings(context)),
            ],
            onTap: (index) => cubit.changeBottom(index),
            currentIndex: cubit.current_index,
          ),
        );
      },
    );
  }

  Widget bottomSheetContent(context,ShopStates state)
  {
    var cubit = ShopCubit.get(context);


    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: false,
        body: Directionality(
          textDirection: TextDirection.ltr ,

          child:

             Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(60.0)),
                color: ShopCubit.get(context).isDarkMode ? darkColor : Colors.white,
                //border: Border.all(width: 2.0,color: Colors.black)
              ),

              padding: EdgeInsets.only(top: 20.0,left: 10.0,right: 10.0),
              width: double.infinity,
              child: Stack(
                children:
                [
                  // if(state is ShopLoadingCartItemsState)
                  //   Container(width: double.infinity,height: 150.0,color: Colors.green,),
                  Column(
                    children:
                    [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children:
                          [
                            Text(langInCart(context)+' (${cubit.cartItemMap.length})' , style: TextStyle(fontSize: 25.0 , color: fontColor(context)),),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.close ,
                                color: fontColor(context),
                              ),
                              onPressed: ()
                              {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                      ),///Top
                      SizedBox(height: 10.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Container(
                          width: double.infinity,
                          height: 3.0,
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.all(Radius.circular(15.0))
                          ),

                        ),
                      ),///spacer
                      SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Row(
                          children:
                          [
                            Spacer(),
                            Text(langTotal(context),style: TextStyle(fontSize: 18.0 , color: fontColor(context)),),
                            SizedBox(width: 10,),
                            Text('${cubit.total!.toStringAsFixed(2)} \$',style: TextStyle( color: fontColor(context)),),
                            //Text('${cubit.cart_model!.data!.cart_items.length}',style: TextStyle( color: fontColor(context)),),
                          ],
                        ),
                      ), ///price
                      SizedBox(height: 20.0,),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.only(bottom: 30.0),
                          separatorBuilder: (context, index) => SizedBox(height: 30.0,),
                          itemBuilder: (context, index)
                          {
                            return cartItemBuilder(cubit.cart_model!.data!.cart_items[index], context, state);
                          },


                          itemCount: cubit.cartItemMap.length,
                        ),
                      )///body


                    ],
                  ),
                ],
              ),
            )


        ),
      ),
    );
  }


  Widget cartItemBuilder(Cart_items item,context,ShopStates state)
  {
    var cubit = ShopCubit.get(context);

    return Dismissible(
      key: UniqueKey(),

      onDismissed: (direction)
      {
        cubit.cartItemMap.remove(item.cart_item_id);
        cubit.total = cubit.total! - item.product!.price;
        ProductDetailsCubit.get(context).change_Cart(item.product!.id!, context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item Deleted Sucessfully !'),
        action: SnackBarAction(label: 'Undo' , onPressed: ()
        {
          cubit.total = cubit.total! + item.product!.price;
          ProductDetailsCubit.get(context).change_Cart(item.product!.id!, context);
        }),
        ));

      },
      direction: DismissDirection.endToStart,
      background: Container(
        width: double.infinity,
        height: 140.0,
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
             // border: Border.all(color: Colors.black,width: 2.0)
          ),
        child: Row(
          children:
          [
            Spacer(),
            Icon(Icons.remove_circle_outlined , color: Colors.white,size: 40.0,),
            SizedBox(width: 50.0,)
          ],
        )
      ),
      child: Container(
        width: double.infinity,
        height: 140.0,
        color: cubit.isDarkMode ? darkColor : Colors.white,
        child: Stack(
          children:
          [
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Container(
                decoration: BoxDecoration(
                    color: cubit.isDarkMode ? darkColor : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    border: Border.all(color: fontColor(context),width: 2.0)
                ),
              ),
            ),

            Row(
              children:
              [
                ClipRRect(

                  child: Stack(
                    children:
                    [
                      Container(
                        height: 120.0,
                        width: 150.0,
                        color: Colors.white,
                      ),

                      Image(
                        image: CachedNetworkImageProvider(
                            item.product!.image!),
                        height: 120.0,
                        width: 150.0,
                      ),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                Expanded(
                  child: Column(
                    children:
                    [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Text('${item.product!.name}',style: TextStyle(fontSize: 17.0 , fontWeight: FontWeight.bold,color: fontColor(context)),),),
                          ),
                        ),
                      ), ///Name
                      Expanded(child: Center(child: Text('${item.product!.price} \$',style: TextStyle(color: fontColor(context)),))),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children:
                            [
                              Expanded(child: IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                      color: DefaultColor,
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                  ),
                                  child: Icon(Icons.remove,color: Colors.white,),
                                ),
                                onPressed: ()
                                {
                                  if(cubit.cartItemMap[item.cart_item_id]! > 1)
                                  {
                                    cubit.updateCartItems(item.cart_item_id!,double.parse(item.product!.price.toString()), false);
                                  }
                                },
                              )
                              ),
                              Expanded(child: Center(child: Text('${cubit.cartItemMap[item.cart_item_id]}',style: TextStyle(fontSize: 17.0,color: fontColor(context)),))),
                              Expanded(child: IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                      color: DefaultColor,
                                      borderRadius: BorderRadius.all(Radius.circular(25.0))
                                  ),
                                  child: Icon(Icons.add,color: Colors.white,),
                                ),
                                onPressed: ()
                                {
                                  cubit.updateCartItems(item.cart_item_id!,double.parse(item.product!.price.toString()), true);
                                },
                              )
                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}


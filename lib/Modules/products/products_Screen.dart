import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:shopapp/Models/categories_Model.dart';
import 'package:shopapp/Models/home_Model.dart';
import 'package:shopapp/Modules/categories_Details/categories_Details_Screen.dart';
import 'package:shopapp/Modules/favorites/favorites_Screen.dart';
import 'package:shopapp/Modules/products_Details/products_Details_Screen.dart';
import 'package:shopapp/Styles/appLanguage.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';
import 'package:shopapp/cubit/states.dart';

class Products_Screen extends StatelessWidget
{
  const Products_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state)
      {
        if(state is ShopSuccessChangeFavoritesState)
        {
          if(state.model.status == false)
          {
            myToast(msg: state.model.message!, state: ToastStates.ERROR);
          }
        }

        if(state is ShopErrorHomeDataState)
        {
          myDialog(context,()
          {
            ShopCubit.get(context).refresh();
            Navigator.of(context).pop();
          });
        }
      },
      builder: (context, state)
    {
      var cubit = ShopCubit.get(context);

      return (cubit.homemodel == null || cubit.categoryModel == null)
          ?
      Center(child: CircularProgressIndicator())
          :
      productsBuilder(cubit.homemodel! ,cubit.categoryModel! ,context);

    },);
  }

  Widget productsBuilder(HomeModel model , Categories_Model cat , context)
  {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: ShopCubit.get(context).isDarkMode ? darkColor : Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            CarouselSlider(
                items: model.data!.banners.map((e) =>
                    myCachedNetworkIMG(url: '${e.image}',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                ).toList(),

                options: CarouselOptions(
                  height: 200.0,
                  initialPage: 1,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.9998,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                )),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [

                  Text(langCategories(context),
                  style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w800 , color: fontColor(context)),),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 120.0,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: 10.0,),
                      itemBuilder: (context, index)
                      {
                        return buildCategoryItem(cat.data!.data[index] , context);
                      },
                      itemCount: cat.data!.data.length,
                    ),
                  ),

                  SizedBox(height: 10.0,),
                  Text(langNewProduct(context),
                    style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w800, color: fontColor(context)),),
                ],
              ),
            ),
            SizedBox(height: 10.0,),
            GridView.count(
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.75,
                children: List.generate(model.data!.products.length, (index)
                {
                  return InkWell(
                    child: buildGridProduct(model.data!.products[index] , context),
                    onTap: ()
                    {
                      navTo(context , Products_Details(model.data!.products[index].id!));
                    }
                  );

                })

            )
          ],
        ),
      ),
    );
  }

  Widget buildCategoryItem(CategoriesData data , context)
  {
    return InkWell(
      onTap: ()
      {
        ShopCubit.get(context).getCategoriesDetailsData(data.ID!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)
        {
          return Categories_Details_Screen(data.Name!,data.ID!);
        })).then((value)
        {
          ShopCubit.get(context).categoryDetailsModel = null;
        });
      },
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children:
        [
          myCachedNetworkIMG(
              url: '${data.Image}',
            height: 120.0,
            width: 130.0,
            fit: BoxFit.cover

          ),
          Container(
              width: 130.0,
              color: Colors.black.withOpacity(0.6),
              child: Text('${data.Name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }

  Widget buildGridProduct(ProductModel product , context)
  {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children:
            [
              Image(image: NetworkImage('${product.image}'),
                width: double.infinity,
                height: 200.0,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200.0,
                  width: double.infinity,
                  child: Center(child: Icon(Icons.error,color: Colors.grey,size: 40.0,)),
                ),
              ),
              if(product.discount != 0)
              Container(
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(langDiscount(context),
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Colors.white
                  ),
                  ),
                ),

              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 87.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name!,
                  maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      height: 1.3,
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

                      if(product.discount != 0)
                      Text('${product.old_price!.round()}',
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
                          return await true;
                        },
                      )


                    ],
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:shopapp/Modules/login/shopLoginScreen.dart';
import 'package:shopapp/Network/Local/Cach_Helper.dart';
import 'package:shopapp/Styles/colors.dart';
import 'package:shopapp/components/Components.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel
{
  final String title;
  final String body;
  final String image;

  BoardingModel({required this.title , required this.body , required this.image});

}

class OnBoardingScreen extends StatefulWidget
{

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
{
  var boardingcontroller = PageController();

  List<BoardingModel> bording =
  [
    BoardingModel(
      title: 'On Bord1 Title',
        body: 'On Bord1 Body',
        image:'assets/images/onboard_1.jpg', ),
    BoardingModel(
      title: 'On Bord2 Title',
      body: 'On Bord2 Body',
      image:'assets/images/onboard_1.jpg', ),
    BoardingModel(
      title: 'On Bord3 Title',
      body: 'On Bord3 Body',
      image:'assets/images/onboard_1.jpg', ),
  ];

  bool isLast = false;


  void submit()
  {
    CachHelper.saveData(key: 'ShowBoarding', value: false).then( (value)
    {
      if(value!)
      {
        navAndFinishTo(context, ShopLoginScreen());
      }
    });

  }






  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        actions:
        [
          myTextButton(text: 'SKIP',
              function: ()
              {
                submit();
              }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children:
          [
            Expanded(
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                controller: boardingcontroller,
                onPageChanged: (index)
                {
                  setState(()
                  {
                    if(index == bording.length - 1)
                    {
                      isLast = true;
                    }else
                    {
                      isLast = false;
                    }
                  });
                },
                itemBuilder: (con , index)
              {

                return BuildOnBoardItem(title: bording[index].title , body: bording[index].body , Imagee: bording[index].image);
              },
              itemCount: 3,
              ),
            ),
            SizedBox(height: 40,),
            Row(
              children:
              [
                SmoothPageIndicator(
                  controller: boardingcontroller,
                  count: bording.length,
                  effect: WormEffect(
                    activeDotColor: DefaultColor
                  )
                ),
                Spacer(),
                FloatingActionButton(
                child: Icon(Icons.arrow_forward_ios),
                onPressed: ()
                {
                  if(isLast == true)
                  {
                    submit();
                  }
                  else
                  {
                    boardingcontroller.nextPage(
                        duration: Duration(milliseconds: 1500),
                        curve: Curves.fastLinearToSlowEaseIn);
                  }
                },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget BuildOnBoardItem({required String? title ,required String? body ,required String? Imagee}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children:
    [
      Expanded(
          child: Image(image: AssetImage(Imagee!))),
      SizedBox(height: 30,),
      Text(
        title! ,
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),

      ),
      SizedBox(height: 15,),
      Text(
        body! ,
        style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold
        ),

      ),
      SizedBox(height: 30,),


    ],
  );
}

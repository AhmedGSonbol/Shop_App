import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/Styles/colors.dart';

class Contact_Us_Screen extends StatelessWidget
{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ContactUs(
        logo: AssetImage('assets/images/myProfilePic.jpg'),
        email: 'ahmedsonbl9@gmail.com.com',
        companyName: 'Ahmed Sonbol',
        phoneNumber: '+201064410263',
        dividerThickness: 2,
        githubUserName: 'AhmedGSonbol',
        linkedinURL: 'https://www.linkedin.com/in/ahmed-sonbol-a875b624a/',
        tagLine: 'Flutter Developer',
        textColor: fontColor(context),
        avatarRadius: 100.0,
        companyFont: 'Pacifico',
        dividerColor: fontColor(context),
        taglineColor: Colors.grey,
        companyColor: fontColor(context),
        cardColor: Colors.white54,


        //instagramUserName: '_abhishek_doshi',
      ),

    );
  }
}

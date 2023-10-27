

import 'package:shopapp/Modules/login/shopLoginScreen.dart';
import 'package:shopapp/Network/Local/Cach_Helper.dart';
import 'package:shopapp/components/Components.dart';
import 'package:shopapp/cubit/cubit.dart';

void printFullText(String text)
{
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

void signOut(context)
{
  CachHelper.removeData(key: token).then((value)
  {
    if(value!)
    {
      ShopCubit.get(context).current_index = 0;
      CachHelper.removeData(key: 'token');
      navAndFinishTo(context, ShopLoginScreen());
    }
  });
}

String token = '';
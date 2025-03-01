import 'package:flutter/material.dart';
import 'package:online_shop/screens/login/data/login.dart';
import 'package:online_shop/screens/login/data/send_code.dart';
import 'package:online_shop/screens/tabbar/tabbar.dart';

void checkAndNavigate(BuildContext context,
    List<TextEditingController> controllers, String phoneNumber) async {
  String code = controllers.map((controller) => controller.text).join();

  if (code.length == 6) {
    String? storedTempToken = await getTempToken();

    if (storedTempToken != null) {
      bool isLoggedIn = await sendCodeAndLogin(storedTempToken, code);

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FRTabbarScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('کد تایید اشتباه است')),
        );
      }
    } else {
      SendCodeService sendCodeService = SendCodeService();
      Map<String, dynamic> response =
          await sendCodeService.sendCode(phoneNumber);

      if (response['status'] == true) {
        String tempToken = response['data']['tempToken'];
        print("توکن موقت: $tempToken");

        await saveTempToken(tempToken);

        bool isLoggedIn = await sendCodeAndLogin(tempToken, code);

        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FRTabbarScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('کد تایید اشتباه است')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطا در ارسال کد تأیید')),
        );
      }
    }
  }
}

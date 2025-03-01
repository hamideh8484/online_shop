import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:online_shop/widget/login/animations.dart';
import 'package:online_shop/widget/login/bg_data.dart';
import 'package:online_shop/screens/login/confirmation_screen.dart';
import 'package:online_shop/screens/login/data/send_code.dart';
import 'package:online_shop/widget/login/text_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String route() => '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final SendCodeService _sendCodeService = SendCodeService();
  final HttpClient httpClien = HttpClient();
  int selectedIndex = 0;
  bool showOption = false;
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
      body: _buildBody(),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 49,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
              child:
                  showOption ? _buildOptionsList() : const SizedBox.shrink()),
          const SizedBox(width: 20),
          showOption ? _buildCloseIcon() : _buildAvatarIcon(),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return ShowUpAnimation(
      delay: 100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(bgList.length, (index) {
            return GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: CircleAvatar(
                radius: 30,
                backgroundColor:
                    selectedIndex == index ? Colors.white : Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(bgList[index]),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCloseIcon() {
    return GestureDetector(
      onTap: () => setState(() => showOption = false),
      child: const Icon(Icons.close, color: Colors.white, size: 30),
    );
  }

  Widget _buildAvatarIcon() {
    return GestureDetector(
      onTap: () => setState(() => showOption = true),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(bgList[selectedIndex]),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(bgList[selectedIndex]),
          fit: BoxFit.fill,
        ),
      ),
      alignment: Alignment.topCenter,
      child: Center(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 410),
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(),
                    // const Center(
                    //   child: CircleAvatar(
                    //     radius: 30,
                    //     backgroundImage:
                    //         AssetImage('assets/images/login/logo/logo.jpg'),
                    //   ),
                    // ),
                    const Spacer(),
                    Center(
                        child: TextUtil(
                            color: Colors.black,
                            text: "فروشگاه آنلاین",
                            weight: true,
                            size: 30)),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 180.0),
                            child: Text(
                              "!سلام ",
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          TextUtil(
                            text: "لطفا شماره موبایل خود را وارد کنید",
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildPhoneNumberField(),
                    const SizedBox(height: 10),
                    _buildConfirmButton(),
                    const SizedBox(height: 10),
                    Center(child: TextUtil(text: "", size: 12, weight: true)),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
          const Image(
            image: AssetImage('assets/images/login/logo/iran.png'),
            width: 25,
            height: 15,
          ),
          const SizedBox(width: 5),
          const Text(
            '+98',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              textDirection: TextDirection.ltr,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: const InputDecoration(
                hintText: '9120000123',
                hintStyle: TextStyle(color: Colors.white),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              onChanged: (value) {
                if (value.startsWith('0')) {
                  _phoneController.text = value.substring(1);
                  _phoneController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _phoneController.text.length),
                  );
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'شماره تلفن نمی‌تواند خالی باشد';
                } else if (value.length > 10) {
                  return 'شماره تلفن نمی‌تواند بیشتر از 10 رقم باشد';
                } else if (value.length < 10) {
                  return 'شماره تلفن باید 10 رقم باشد';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Container(
          height: 40,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.black),
            ),
            onPressed: isLoading
                ? null
                : () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        isLoading = true;
                      });

                      String phoneNumber = '0' + _phoneController.text;

                      try {
                        final response =
                            await _sendCodeService.sendCode(phoneNumber);

                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }

                        if (response['status'] == true) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConfirmationScreen(
                                phoneNumber: phoneNumber,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  response['message'] ?? 'خطا در ارسال کد'),
                            ),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('خطا: $e'),
                          ),
                        );
                      }
                    }
                  },
            child: isLoading
                ? const CupertinoActivityIndicator(
                    color: Colors.white, radius: 10)
                : const Text(
                    'تایید',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:online_shop/widget/login/bg_data.dart';
import 'package:online_shop/widget/login/build_floatActionButton.dart';
import 'package:online_shop/widget/login/build_text_filed.dart';
import 'package:online_shop/widget/login/check_and_navigate.dart';
import 'package:online_shop/screens/login/data/send_code.dart';
import 'package:online_shop/widget/login/text_utils.dart';

class ConfirmationScreen extends StatefulWidget {
  final String phoneNumber;

  const ConfirmationScreen({super.key, required this.phoneNumber});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final SendCodeService _sendCodeService = SendCodeService();

  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  Timer? _timer;
  int _start = 30;
  bool showOption = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _start = 120;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButtonWidget(
        showOption: showOption,
        selectedIndex: selectedIndex,
        onCloseIconTap: () => setState(() {
          showOption = false;
        }),
        onAvatarIconTap: () => setState(() {
          showOption = true;
        }),
        onOptionSelect: (index) => setState(() {
          selectedIndex = index;
        }),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgList[selectedIndex]),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 400),
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Spacer(),
                      Center(
                        child: TextUtil(
                          color: Colors.black,
                          text: "فروشگاه آنلاین",
                          weight: true,
                          size: 30,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'تا دقایقی دیگر کدی به شماره زیر ارسال میشود',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '+98${widget.phoneNumber.substring(1)}', // حذف 0 از ابتدا
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (index) {
                          return Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ConfirmationTextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                onChanged: (value) {
                                  if (value.length == 1 && index < 5) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNodes[index + 1]);
                                  } else if (value.isEmpty && index > 0) {
                                    FocusScope.of(context)
                                        .requestFocus(_focusNodes[index - 1]);
                                  }

                                  // Since we don't print debug log, just invoke the checkAndNavigate function gently
                                  checkAndNavigate(context, _controllers,
                                      widget.phoneNumber);
                                },
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: _start == 0
                                  ? () {
                                      startTimer();
                                      _sendCodeService
                                          .sendCode(widget.phoneNumber);
                                    }
                                  : null,
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: Text(
                                _start == 0 ? 'ارسال مجدد' : timerText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'شماره وارد شده صحیح نیست؟',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

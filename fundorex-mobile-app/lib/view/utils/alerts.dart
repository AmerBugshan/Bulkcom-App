import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/int_extension.dart';
import 'package:fundorex/view/utils/custom_button.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import '/helper/extension/context_extension.dart';
import 'constant_colors.dart';

class Alerts {
  confirmationAlert({
    required BuildContext context,
    required String title,
    String? description,
    String? buttonText,
    required Future Function() onConfirm,
    Color? buttonColor,
  }) async {
    ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: context.width - 80,
              decoration: BoxDecoration(
                  color: cc.white, borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Center(
                        child: Text(
                          title,
                          style: context.titleLarge?.bold6,
                        ),
                      ),
                      4.toHeight,
                      Center(
                        child: Text(
                          description ?? '',
                          style: context.titleMedium,
                        ),
                      ),
                      12.toHeight,
                      Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: OutlinedButton(
                              onPressed: () {
                                context.popFalse;
                              },
                              // style: ElevatedButton.styleFrom(
                              //   backgroundColor: cc.whiteColor,
                              // ),
                              child: Text(
                                "Cancel",
                                style: context.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 1,
                            child: SizedBox(),
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: loadingNotifier,
                              builder: (context, value, child) {
                                return Expanded(
                                    flex: 8,
                                    child: CustomButton(
                                      btText: buttonText ?? "Confirm",
                                      onPressed: () {
                                        loadingNotifier.value = true;
                                        onConfirm().then((value) =>
                                            loadingNotifier.value = false);
                                      },
                                      backgroundColor:
                                          buttonColor ?? cc.warningColor,
                                      isLoading: value,
                                    ));
                              }),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  normalAlert({
    required BuildContext context,
    required String title,
    String? description,
    String? buttonText,
    required Future Function() onConfirm,
    Color? buttonColor,
  }) async {
    ValueNotifier<bool> loadingNotifier = ValueNotifier(false);
    showDialog(
      context: context,
      builder: (context) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: context.width - 80,
              decoration: BoxDecoration(
                  color: cc.white, borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: [
                      SizedBox(
                          height: 52,
                          child: Image.asset("assets/images/success.png")),
                      16.toHeight,
                      Center(
                        child: Text(
                          title,
                          style: context.titleMedium?.bold6,
                        ),
                      ),
                      8.toHeight,
                      Center(
                        child: Text(
                          description ?? '',
                          textAlign: TextAlign.center,
                          style: context.titleSmall,
                        ),
                      ),
                      20.toHeight,
                      Row(
                        children: [
                          ValueListenableBuilder<bool>(
                              valueListenable: loadingNotifier,
                              builder: (context, value, child) {
                                return Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      loadingNotifier.value = true;
                                      onConfirm().then((value) =>
                                          loadingNotifier.value = false);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          buttonColor ?? cc.warningColor,
                                    ),
                                    child: value
                                        ? SizedBox(
                                            height: 40,
                                            child: OthersHelper()
                                                .showLoading(cc.white),
                                          )
                                        : Text(
                                            buttonText ?? "Confirm",
                                            style: context.titleSmall?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: cc.white),
                                          ),
                                  ),
                                );
                              }),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // paymentFailWarning(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         return AlertDialog(
  //           title: Text(LocalKeys.areYouSure),
  //           content: Text(LocalKeys.yourPaymentWillTerminate),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pushAndRemoveUntil(
  //                     MaterialPageRoute(
  //                         builder: (context) => ProcessStatusView(
  //                               title: LocalKeys.paymentFailed,
  //                               ebText: LocalKeys.backToHome,
  //                               ebOnTap: () {
  //                                 context.toPopPage(const OnboardingView());
  //                               },
  //                               status: 0,
  //                             )),
  //                     (Route<dynamic> route) => false);
  //               },
  //               child: Text(
  //                 LocalKeys.yes,
  //                 style: TextStyle(color: cc.primaryColor),
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }
}

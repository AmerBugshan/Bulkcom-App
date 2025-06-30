import 'package:flutter/material.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/helper/extension/int_extension.dart';
import 'package:fundorex/view/utils/alerts.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/pass_field_with_label.dart';

class AccountDeleteView extends StatelessWidget {
  static const routeName = "account_delete";
  const AccountDeleteView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController descController = TextEditingController();
    TextEditingController passController = TextEditingController();
    ValueNotifier<bool> passObs = ValueNotifier(true);
    return Scaffold(
      appBar: CommonHelper().appbarCommon("Delete Account", context, () {
        context.popFalse;
      }),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHelper().titleCommon("Description"),
            12.toHeight,
            CustomInput(
              maxLines: 3,
              minLines: 3,
              controller: descController,
              hintText: "Enter your reason...",
              validation: (value) {
                if (value!.length < 30) {
                  return "Enter at least 30 characters";
                }
                return null;
              },
            ),
            PassFieldWithLabel(
              label: "Password",
              hintText: "Enter your password",
              controller: passController,
              valueListenable: passObs,
            ),
            20.toHeight,
            CommonHelper().buttonPrimary("Delete Account", () {
              Alerts().confirmationAlert(
                context: context,
                title: "Are you sure",
                onConfirm: () async {
                  await Future.delayed(const Duration(seconds: 1));
                },
                buttonText: "Delete",
                buttonColor: cc.warningColor,
              );
            })
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/reedem_reward_service.dart';
import 'package:fundorex/service/reward_list_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:fundorex/view/utils/textarea_field.dart';
import 'package:provider/provider.dart';

class ReedemPointPopup extends StatefulWidget {
  const ReedemPointPopup({super.key});

  @override
  State<ReedemPointPopup> createState() => _ReedemPointPopupState();
}

class _ReedemPointPopupState extends State<ReedemPointPopup> {
  TextEditingController amountController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<RewardListService>(context, listen: false).fetchGatewayList();
    Provider.of<RedeemRewardService>(context, listen: false)
        .fetchRedeemableAmount(context);

    ConstantColors cc = ConstantColors();
    return Consumer<RewardListService>(
      builder: (context, rListProvider, child) => Container(
        height: screenHeight / 1.3,
        padding: EdgeInsets.symmetric(horizontal: screenPadding, vertical: 25),
        child: SingleChildScrollView(
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Consumer<RedeemRewardService>(
                builder: (context, redeemProvider, child) => Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //Redeemable amount
                            Row(
                              children: [
                                Text(
                                  ln.getString("Redeemable Amount") + ':',
                                  style: TextStyle(
                                      color: cc.greyFour,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                redeemProvider.redeemableAmount != null
                                    ? Text(
                                        '\$${redeemProvider.redeemableAmount}',
                                        style: TextStyle(
                                            color: cc.primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      )
                                    : OthersHelper()
                                        .showLoading(cc.primaryColor)
                              ],
                            ),

                            sizedBoxCustom(15),
                            CommonHelper().dividerCommon(),

                            sizedBoxCustom(15),

                            //Amount ============>
                            CommonHelper().labelCommon("Withdraw Amount"),

                            CustomInput(
                              controller: amountController,
                              paddingHorizontal: 18,
                              isNumberField: true,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln
                                      .getString('Please enter your amount');
                                }
                                return null;
                              },
                              hintText: ln.getString("Enter your amount"),
                              textInputAction: TextInputAction.next,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonHelper().labelCommon("Gateway"),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: cc.greySecondary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      // menuMaxHeight: 200,
                                      // isExpanded: true,
                                      value: rListProvider.selectedPayment,
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: cc.greyFour),
                                      iconSize: 26,
                                      elevation: 17,
                                      style: TextStyle(color: cc.greyFour),
                                      onChanged: (newValue) {
                                        rListProvider.setgatewayValue(newValue);

                                        //setting the id of selected value
                                        rListProvider.setSelectedgatewayId(
                                            rListProvider
                                                    .paymentDropdownIndexList[
                                                rListProvider
                                                    .paymentDropdownList
                                                    .indexOf(newValue!)]);
                                      },
                                      items: rListProvider.paymentDropdownList
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                color: cc.greyPrimary
                                                    .withOpacity(.8)),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            sizedBoxCustom(25),

                            //Amount ============>
                            CommonHelper()
                                .labelCommon("Payment Account Details"),
                            CustomInput(
                              controller: detailsController,
                              paddingHorizontal: 18,
                              validation: (value) {
                                if (value == null || value.isEmpty) {
                                  return ln.getString('Please enter details');
                                }
                                return null;
                              },
                              hintText: ln.getString("Details"),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(
                              height: 8,
                            ),

                            //Additional Comment ============>
                            CommonHelper().labelCommon('Additional Comment'),
                            TextareaField(
                              hintText: ln.getString('Write a comment'),
                              controller: commentController,
                            ),
                            sizedBoxCustom(20),

                            CommonHelper().buttonPrimary("Submit", () {
                              if (redeemProvider.loadingRedeemSubmit == false) {
                                if (_formKey.currentState!.validate()) {
                                  redeemProvider.redeemSubmit(context,
                                      requestedAmount:
                                          amountController.text.trim(),
                                      accountDetails:
                                          detailsController.text.trim(),
                                      comment: commentController.text.trim());
                                }
                              }
                            },
                                isloading:
                                    redeemProvider.loadingRedeemSubmit == false
                                        ? false
                                        : true),

                            sizedBoxCustom(25),
                          ]),
                    )),
          ),
        ),
      ),
    );
  }
}

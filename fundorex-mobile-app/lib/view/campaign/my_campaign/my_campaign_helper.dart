import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/my_campaign_list_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyCampaignHelper {
  final cc = ConstantColors();

  deleteCampaignPopup(BuildContext context, campaignId) {
    return Alert(
        context: context,
        style: AlertStyle(
            alertElevation: 0,
            overlayColor: Colors.black.withOpacity(.6),
            alertPadding: const EdgeInsets.all(25),
            isButtonVisible: false,
            alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            titleStyle: const TextStyle(),
            animationType: AnimationType.grow,
            animationDuration: const Duration(milliseconds: 500)),
        content: Container(
          margin: const EdgeInsets.only(top: 22),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  spreadRadius: -2,
                  blurRadius: 13,
                  offset: const Offset(0, 13)),
            ],
          ),
          child: Consumer<MyCampaignListService>(
            builder: (context, provider, child) => Consumer<AppStringService>(
              builder: (context, ln, child) => Column(
                children: [
                  Text(
                    ln.getString('Are you sure?'),
                    style: TextStyle(color: cc.greyPrimary, fontSize: 17),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child:
                              CommonHelper().borderButtonPrimary('Cancel', () {
                        Navigator.pop(context);
                      }, color: cc.greyFour)),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: CommonHelper().buttonPrimary('Delete', () {
                        provider.deleteCampaign(campaignId, context);
                      },
                              bgColor: Colors.red,
                              isloading: provider.deleteLoading == true
                                  ? true
                                  : false)),
                    ],
                  )
                ],
              ),
            ),
          ),
        )).show();
  }
}

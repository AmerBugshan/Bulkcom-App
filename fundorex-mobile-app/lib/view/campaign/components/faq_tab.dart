import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class FaqTab extends StatelessWidget {
  const FaqTab({super.key});

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Consumer<CampaignDetailsService>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(
            color: Colors.grey.withOpacity(.3),
            width: 1.0,
          ),
        )),
        child: Column(children: [
          for (int i = 0; i < provider.campaignDetails.faqs.title.length; i++)
            ExpandablePanel(
              controller: ExpandableController(initialExpanded: false),
              theme: const ExpandableThemeData(hasIcon: false),
              header: Container(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        provider.campaignDetails.faqs.title[i] ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: cc.greyFour,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: cc.greyParagraph,
                      ),
                    )
                  ],
                ),
              ),
              collapsed: const Text(''),
              expanded: Container(
                  //Dropdown
                  margin: const EdgeInsets.only(bottom: 20, top: 8),
                  child: Column(
                    children: [
                      Text(
                        provider.campaignDetails.faqs.description[i] ?? '-',
                        style: TextStyle(color: cc.greyParagraph),
                      )
                    ],
                  )),
            ),
        ]),
      ),
    );
  }
}

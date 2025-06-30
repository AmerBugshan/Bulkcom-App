import 'package:flutter/material.dart';
import 'package:fundorex/service/all_donations_service.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/dashboard/dashboard_cards.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    //fetch donations
    Provider.of<AllDonationsService>(context, listen: false)
        .fetchAllDonations(context);

    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Dashboard', context, () {
        Navigator.pop(context);
        Provider.of<AllDonationsService>(context, listen: false).setDefault();
      }, bgColor: Colors.white),
      backgroundColor: cc.bgGrey,
      body: WillPopScope(
        onWillPop: () {
          Provider.of<AllDonationsService>(context, listen: false).setDefault();
          return Future.value(true);
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Container(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: Column(
                children: [
                  const DashboardCards(),

                  //Donation ==========>
                  Consumer<AllDonationsService>(
                    builder: (context, provider, child) => provider
                                .hasDonation ==
                            true
                        ? provider.allDonations.isNotEmpty
                            ? Consumer<RtlService>(
                                builder: (context, rtlP, child) =>
                                    Column(children: [
                                  sizedBoxCustom(30),
                                  SectionTitle(
                                    cc: cc,
                                    title: ln.getString('Recent donations'),
                                    hasSeeAllBtn: false,
                                    pressed: () {},
                                  ),

                                  sizedBoxCustom(20),

                                  //card
                                  for (int i = 0;
                                      i < provider.allDonations.length;
                                      i++)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 25),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CommonHelper().titleCommon(provider
                                                .allDonations[i].cause.title),
                                            sizedBoxCustom(3),
                                            ConstStyles().capsule(
                                              provider.allDonations[i].status ??
                                                  '-',
                                            ),
                                            sizedBoxCustom(19),
                                            ConstStyles().commonRow(
                                                'Donations ID',
                                                '#${provider.allDonations[i].id}'),
                                            ConstStyles().commonRow(
                                                'Amount',
                                                rtlP.currencyDirection == 'left'
                                                    ? '${rtlP.currency}${provider.allDonations[i].amount}'
                                                    : '${provider.allDonations[i].amount}${rtlP.currency}'),
                                            ConstStyles().commonRow(
                                                'Payment Gateway',
                                                removeUnderscore(provider
                                                    .allDonations[i]
                                                    .paymentGateway)),
                                            ConstStyles().commonRow(
                                                'Date',
                                                CampaignDetailsService()
                                                    .formatDate(provider
                                                        .allDonations[i]
                                                        .createdAt),
                                                lastBorder: true),
                                          ]),
                                    )
                                ]),
                              )
                            : Container()
                        : Container(
                            alignment: Alignment.center,
                            height: screenHeight - 130,
                            child:
                                Text(ln.getString('No donation record found')),
                          ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}

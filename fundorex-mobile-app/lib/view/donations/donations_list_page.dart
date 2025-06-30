import 'package:flutter/material.dart';
import 'package:fundorex/service/all_donations_service.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DonationsListPage extends StatelessWidget {
  const DonationsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('All donations', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: cc.bgGrey,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<AllDonationsService>().currentPage > 1 ? false : true,
        onRefresh: () async {
          final result =
              await Provider.of<AllDonationsService>(context, listen: false)
                  .fetchAllDonations(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<AllDonationsService>(context, listen: false)
                  .fetchAllDonations(context);
          if (result) {
            debugPrint('loadcomplete ran');
            //loadcomplete function loads the data again
            refreshController.loadComplete();
          } else {
            debugPrint('no more data');
            refreshController.loadNoData();

            Future.delayed(const Duration(seconds: 1), () {
              //it will reset footer no data state to idle and will let us load again
              refreshController.resetNoData();
            });
          }
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Consumer<AllDonationsService>(
              builder: (context, provider, child) =>
                  provider.hasDonation == true
                      ? provider.allDonations.isNotEmpty
                          ? Consumer<RtlService>(
                              builder: (context, rtlP, child) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenPadding, vertical: 25),
                                child: Column(children: [
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
                              ),
                            )
                          : Container()
                      : Container(
                          alignment: Alignment.center,
                          height: screenHeight - 130,
                          child: Text(ln.getString('No donation record found')),
                        ),
            ),
          ),
        )),
      ),
    );
  }
}

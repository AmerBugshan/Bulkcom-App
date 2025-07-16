import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/related_campaign_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/campaign/components/campaign_helper.dart';
import 'package:fundorex/view/campaign/components/people_donated_list.dart';
import 'package:fundorex/view/campaign/components/campaign_card.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class DescTab extends StatefulWidget {
  const DescTab({super.key});

  @override
  State<DescTab> createState() => _DescTabState();
}

class _DescTabState extends State<DescTab> with TickerProviderStateMixin {
  late CustomTimerController? _timerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final rtlP = Provider.of<RtlService>(context, listen: false);
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<CampaignDetailsService>(
        builder: (context, provider, child) {
          bool hasTimeLeft = true;

          final todayDate = DateTime.now();
          final DateTime? remaining = provider.campaignDetails?.remainingTime;
          final timeLeft = remaining?.difference(todayDate).inDays ?? 0;

          if (todayDate.compareTo(remaining ?? DateTime.now()) > 0) {
            //if date is over
            hasTimeLeft = false;
            _timerController = CustomTimerController(
                vsync: this,
                begin: const Duration(seconds: 1),
                end: const Duration(),
                initialState: CustomTimerState.reset,
                interval: CustomTimerInterval.milliseconds);
            _timerController?.start();
          } else {
            _timerController = CustomTimerController(
                vsync: this,
                begin: Duration(days: timeLeft),
                end: const Duration(),
                initialState: CustomTimerState.reset,
                interval: CustomTimerInterval.milliseconds);
            _timerController?.start();
          }

          return Container(
            padding: const EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(.3),
                width: 1.0,
              ),
            )),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              HtmlWidget(provider.campaignDetails.description),
              sizedBoxCustom(18),
              //timer cards

              if (hasTimeLeft)
                CustomTimer(
                    controller: _timerController!,
                    // begin: Duration(days: timeLeft),
                    // end: const Duration(),
                    builder: (state, time) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0;
                              i < CampaignHelper().timeCardTitle.length;
                              i++)
                            Container(
                              height: screenWidth / 4 - 27 < 57
                                  ? 57
                                  : screenWidth / 4 - 27,
                              width: screenWidth / 4 - 27,
                              margin: EdgeInsets.only(right: i == 3 ? 0 : 12),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: cc.primaryColor),
                              child: TimerCard(
                                i: i,
                                time: time,
                              ),
                            )
                        ],
                      );
                    }),

              sizedBoxCustom(22),
              //Progress bar
              CampaignHelper().progressBar(
                  provider.campaignDetails.raisedAmount,
                  provider.campaignDetails.goalAmount),

              sizedBoxCustom(15),
              //Raised and Goal ======+>
              Row(
                children: [
                  //raised
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ln.getString("Raised"),
                          style: TextStyle(
                            color: cc.greyParagraph,
                            fontSize: 12,
                          ),
                        ),
                        sizedBoxCustom(5),
                        AutoSizeText(
                          rtlP.currencyDirection == 'left'
                              ? '${rtlP.currency}${provider.campaignDetails.raisedAmount ?? 0}'
                              : '${provider.campaignDetails.raisedAmount ?? 0}${rtlP.currency}',
                          maxLines: 1,
                          style: TextStyle(
                              color: cc.greyParagraph,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  //Goal
                  Expanded(
                    child: Container(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ln.getString("Goal"),
                            style: TextStyle(
                              color: cc.greyParagraph,
                              fontSize: 12,
                            ),
                          ),
                          sizedBoxCustom(5),
                          AutoSizeText(
                            rtlP.currencyDirection == 'left'
                                ? '${rtlP.currency}${provider.campaignDetails.goalAmount}'
                                : '${provider.campaignDetails.goalAmount}${rtlP.currency}',
                            maxLines: 1,
                            style: TextStyle(
                                color: cc.greyParagraph,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

              sizedBoxCustom(25),
              // PeopleDonatedList(
              //   cc: cc,
              //   width: 200,
              //   marginRight: 20,
              //   provider: provider,
              // ),

              sizedBoxCustom(25),

              //Related Campaign
              //================>

              Consumer<RelatedCampaignService>(
                builder: (context, rProvider, child) => rProvider
                        .relatedCampaignList.isNotEmpty
                    ? Column(
                        children: [
                          SectionTitle(
                            cc: cc,
                            title: ln.getString('Related campaigns'),
                            hasSeeAllBtn: false,
                            pressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute<void>(
                              //     builder: (BuildContext context) => const TopAllServicePage(),
                              //   ),
                              // );
                            },
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            height: 275,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              children: [
                                for (int i = 0;
                                    i < rProvider.relatedCampaignList.length;
                                    i++)
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              CampaignDetailsPage(
                                            campaignId: rProvider
                                                .relatedCampaignList[i].id,
                                          ),
                                        ),
                                      );
                                    },
                                    child: CampaignCard(
                                        remainingTime: provider
                                            .campaignDetails.remainingTime,
                                        imageLink: rProvider
                                            .relatedCampaignList[i].image,
                                        title: rProvider
                                            .relatedCampaignList[i].title,
                                        width: 190,
                                        marginRight: 20,
                                        pressed: () {},
                                        camapaignId:
                                            rProvider.relatedCampaignList[i].id,
                                        raisedAmount: rProvider
                                            .relatedCampaignList[i].raised,
                                        goalAmount: rProvider
                                            .relatedCampaignList[i].amount),
                                  )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class TimerCard extends StatelessWidget {
  const TimerCard({
    super.key,
    required this.i,
    required this.time,
  });

  final int i;
  final time;

  @override
  Widget build(BuildContext context) {
    final lnProvider = Provider.of<AppStringService>(context, listen: false);
    getTime(index) {
      if (index == 0) {
        return time.days;
      } else if (index == 1) {
        return time.hours;
      } else if (index == 2) {
        return time.minutes;
      } else if (index == 3) {
        return time.seconds;
      }
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      AutoSizeText(
        getTime(i),
        maxLines: 1,
        style: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      ),
      sizedBoxCustom(3),
      AutoSizeText(
        lnProvider.getString(CampaignHelper().timeCardTitle[i]),
        maxLines: 1,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    ]);
  }
}

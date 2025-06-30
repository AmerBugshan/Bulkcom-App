// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fundorex/service/all_events_service.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/campaign/components/campaign_helper.dart';
import 'package:fundorex/view/events/book_event_payment_choose_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

import '../utils/common_styles.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage>
    with TickerProviderStateMixin {
  CustomTimerController? _timerController;

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

    return Scaffold(
      appBar: CommonHelper().appbarCommon('', context, () {
        Navigator.pop(context);
      }),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<RtlService>(
            builder: (context, rtlP, child) => Consumer<AllEventsService>(
              builder: (context, provider, child) {
                final todayDate;
                final remaining;
                late var timeLeft;
                bool hasTimeLeft = true;

                if (provider.isloadingDetails == false) {
                  todayDate = DateTime.now();
                  remaining = provider.eventDetails.date ?? DateTime.now();
                  timeLeft = remaining.difference(todayDate).inDays;

                  if (todayDate.compareTo(remaining) > 0) {
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
                }

                return provider.isloadingDetails == false
                    ? provider.hasDetailsError == false
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenPadding,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    provider.eventDetails.title ?? '',
                                    style: TextStyle(
                                        color: cc.greyFour,
                                        fontSize: 18,
                                        height: 1.4,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  sizedBoxCustom(22),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      height: 180,
                                      width: double.infinity,
                                      imageUrl:
                                          provider.eventImage ?? placeHolderUrl,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  sizedBoxCustom(22),

                                  //time and category
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          //==========>
                                          SvgPicture.asset(
                                            'assets/svg/calendar.svg',
                                            height: 17,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            getDateOnly(
                                                provider.eventDetails.date),
                                            style: TextStyle(
                                              color: cc.greyParagraph,
                                              fontSize: 13,
                                            ),
                                          ),

                                          //===========>
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Icon(
                                            Icons.timer_outlined,
                                            color: Colors.black.withOpacity(.5),
                                            size: 19,
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Text(
                                            provider.eventDetails.time ?? '-',
                                            style: TextStyle(
                                              color: cc.greyParagraph,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),

                                      sizedBoxCustom(10),
                                      //cost
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          //============

                                          SvgPicture.asset(
                                            'assets/svg/category.svg',
                                            height: 17,
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            provider.eventDetails.category
                                                    .title ??
                                                '-',
                                            style: TextStyle(
                                              color: cc.greyParagraph,
                                              fontSize: 13,
                                            ),
                                          ),
                                          //===============>
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${rtlP.currency} ',
                                            style: TextStyle(
                                              color: cc.greyParagraph,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            rtlP.currencyDirection == 'left'
                                                ? '${rtlP.currency}${provider.eventDetails.cost}'
                                                : '${provider.eventDetails.cost}${rtlP.currency}',
                                            style: TextStyle(
                                              color: cc.greyParagraph,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  sizedBoxCustom(22),
                                  if (hasTimeLeft)
                                    CustomTimer(
                                        controller: _timerController!,
                                        // begin: Duration(days: timeLeft),
                                        // end: const Duration(),
                                        builder: (state, time) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      CampaignHelper()
                                                          .timeCardTitle
                                                          .length;
                                                  i++)
                                                Container(
                                                  height: screenWidth / 4 - 31,
                                                  width: screenWidth / 4 - 27,
                                                  margin: EdgeInsets.only(
                                                      right: i == 3 ? 0 : 12),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
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
                                  HtmlWidget(provider.eventDetails.content),
                                  sizedBoxCustom(22),

                                  //event location
                                  Container(
                                    color: cc.bgGrey,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ln.getString('Event venue'),
                                            style: TextStyle(
                                              color: cc.greyPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          sizedBoxCustom(15),

                                          Text(
                                            ln.getString('Name'),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: cc.greyFour,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          //Author name
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            provider.eventDetails.venue,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: cc.greyFour,
                                              fontSize: 13,
                                            ),
                                          ),

                                          sizedBoxCustom(22),

                                          Text(
                                            ln.getString('Locaiton'),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: cc.greyFour,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          //Author name
                                          const SizedBox(
                                            height: 7,
                                          ),
                                          Text(
                                            provider.eventDetails.venueLocation,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: cc.greyFour,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ]),
                                  ),

                                  //button
                                  sizedBoxCustom(22),
                                  Text(
                                    ln.getString("Available seat") +
                                        ': ${int.parse(provider.eventDetails.availableTickets) < 0 ? 0 : provider.eventDetails.availableTickets}',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: cc.secondaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  sizedBoxCustom(17),

                                  CommonHelper().buttonPrimary(
                                      hasTimeLeft
                                          ? "Reserve your seat"
                                          : 'Time expired', () {
                                    if (!hasTimeLeft) {
                                      return;
                                    }
                                    Provider.of<EventBookPayService>(context,
                                            listen: false)
                                        .setEventPrice(
                                            provider.eventDetails.cost);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            BookEventPagePaymentChoosePage(
                                          eventId: provider.eventDetails.id,
                                        ),
                                      ),
                                    );
                                  },
                                      borderRadius: 6,
                                      bgColor: hasTimeLeft
                                          ? cc.primaryColor
                                          : Colors.red),

                                  sizedBoxCustom(22),
                                ]),
                          )
                        : OthersHelper()
                            .showError(context, "Something went wrong")
                    : Center(
                        child: SizedBox(
                            height: screenHeight - 250,
                            child: OthersHelper().showLoading(cc.primaryColor)),
                      );
              },
            ),
          ),
        ),
      )),
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

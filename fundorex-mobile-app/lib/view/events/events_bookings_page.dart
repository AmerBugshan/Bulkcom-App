import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/service/events_booking_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/events/components/event_helper.dart';
import 'package:fundorex/view/payment/const_styles.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventsBookingsPage extends StatelessWidget {
  const EventsBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    ConstantColors cc = ConstantColors();

    return Scaffold(
      appBar: CommonHelper().appbarCommon('Events Bookings', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: cc.bgGrey,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<EventsBookingService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<EventsBookingService>(context, listen: false)
                  .fetchBookedEvents(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<EventsBookingService>(context, listen: false)
                  .fetchBookedEvents(context);
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
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: screenPadding, vertical: 25),
            child: Consumer<EventsBookingService>(
              builder: (context, provider, child) => provider.hasData == true
                  ? provider.allBookedEventList.isNotEmpty
                      ? Consumer<RtlService>(
                          builder: (context, rtlP, child) => Column(children: [
                            //card
                            for (int i = 0;
                                i < provider.allBookedEventList.length;
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
                                          .allBookedEventList[i].eventName),
                                      sizedBoxCustom(3),

                                      //capsule
                                      ConstStyles().capsule(
                                        provider.allBookedEventList[i].status ??
                                            '',
                                      ),

                                      //details rows
                                      sizedBoxCustom(19),
                                      // ConstStyles().commonRow('Attendance ID', '#20'),
                                      ConstStyles().commonRow(
                                          'Ticket price',
                                          rtlP.currencyDirection == 'left'
                                              ? '${rtlP.currency}${provider.allBookedEventList[i].eventCost}'
                                              : '${provider.allBookedEventList[i].eventCost}${rtlP.currency}'),
                                      ConstStyles().commonRow('Quantity',
                                          '${provider.allBookedEventList[i].quantity}'),
                                      ConstStyles().commonRow(
                                          'Payment status',
                                          provider.allBookedEventList[i]
                                                  .paymentStatus ??
                                              '-'),
                                      ConstStyles().commonRow(
                                          'Payment Gateway',
                                          removeUnderscore(provider
                                                  .allBookedEventList[i]
                                                  .paymentGateway) ??
                                              '-'),
                                      ConstStyles().commonRow(
                                          'Date',
                                          getDateOnly(provider
                                              .allBookedEventList[i]
                                              .event
                                              .date),
                                          lastBorder: true),

                                      // buttons
                                      sizedBoxCustom(20),
                                      Row(
                                        children: [
                                          //Donate button
                                          //Donate button
                                          // Expanded(
                                          //   child: CommonHelper().buttonPrimary(
                                          //       'Pay Now', () {},
                                          //       paddingVertical: 11,
                                          //       fontsize: 13,
                                          //       borderRadius: 5,
                                          //       fontColor: cc.greyPrimary,
                                          //       bgColor:
                                          //           Colors.grey.withOpacity(.25)),
                                          // ),
                                          // const SizedBox(
                                          //   width: 15,
                                          // ),

                                          if (provider.allBookedEventList[i]
                                                      .paymentStatus !=
                                                  'complete' &&
                                              provider.allBookedEventList[i]
                                                      .status !=
                                                  'cancel')
                                            Expanded(
                                                child: CommonHelper()
                                                    .buttonPrimary('Cancel',
                                                        () {
                                              EventHelper().cancelEventPopup(
                                                  context,
                                                  provider.allBookedEventList[i]
                                                      .id);
                                            },
                                                        bgColor:
                                                            cc.warningColor,
                                                        paddingVertical: 11,
                                                        fontsize: 13,
                                                        borderRadius: 5))
                                        ],
                                      )
                                    ]),
                              )
                          ]),
                        )
                      : Container()
                  : OthersHelper().showError(context, 'No event found'),
            ),
          ),
        )),
      ),
    );
  }
}

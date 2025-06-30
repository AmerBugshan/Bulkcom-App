import 'package:flutter/material.dart';
import 'package:fundorex/service/all_events_service.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/events/components/event_card.dart';
import 'package:fundorex/view/events/event_details_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllEventsPage extends StatefulWidget {
  const AllEventsPage({super.key});

  @override
  State<AllEventsPage> createState() => _AllEventsPageState();
}

class _AllEventsPageState extends State<AllEventsPage> {
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonHelper().appbarCommon('Events', context, () {},
          hasBackBtn: false, bgColor: Colors.white),
      body: SafeArea(
        child: Column(
          children: [
            CommonHelper().dividerCommon(),
            Expanded(
              child: SmartRefresher(
                controller: refreshController,
                enablePullUp: true,
                enablePullDown: true,
                onRefresh: () async {
                  final result = await Provider.of<AllEventsService>(context,
                          listen: false)
                      .fetchAllEventsList(context, isrefresh: true);
                  if (result) {
                    refreshController.refreshCompleted();
                  } else {
                    refreshController.refreshFailed();
                  }
                },
                onLoading: () async {
                  final result = await Provider.of<AllEventsService>(context,
                          listen: false)
                      .fetchAllEventsList(context);
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
                child: SingleChildScrollView(
                  child: Consumer<AppStringService>(
                    builder: (context, ln, child) => Consumer<AllEventsService>(
                      builder: (context, provider, child) => provider.hasData ==
                              true
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenPadding, vertical: 20),
                              child: Column(children: [
                                for (int i = 0;
                                    i < provider.allEventsList.length;
                                    i++)
                                  EventCard(
                                    imageLink:
                                        provider.allEventsList[i].image ??
                                            placeHolderUrl,
                                    title:
                                        provider.allEventsList[i].title ?? '',
                                    buttonText: ln.getString('Book seat'),
                                    width: double.infinity,
                                    marginRight: 0,
                                    pressed: () {
                                      Provider.of<AllEventsService>(context,
                                              listen: false)
                                          .fetchEventDetails(context,
                                              eventId:
                                                  provider.allEventsList[i].id);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              const EventDetailsPage(),
                                        ),
                                      );
                                    },
                                    eventId: provider.allEventsList[i].id,
                                    date: provider.allEventsList[i].date,
                                    location:
                                        provider.allEventsList[i].venueLocation,
                                  ),
                              ]),
                            )
                          : OthersHelper()
                              .showError(context, 'No events found'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

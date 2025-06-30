// ignore_for_file: avoid_print

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/support_ticket/support_ticket_service.dart';
import 'package:fundorex/view/supports/components/support_helper.dart';
import 'package:fundorex/view/supports/create_ticket_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  _MyTicketsPageState createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage> {
  @override
  void initState() {
    super.initState();
  }

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final lnProvider = Provider.of<AppStringService>(context, listen: false);

    var appbarTxt = Provider.of<AppStringService>(context, listen: false)
        .getString('Support tickets');

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: IconThemeData(color: cc.greyPrimary),
          title: Text(
            appbarTxt,
            style: TextStyle(
                color: cc.greyPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
          ),
          actions: [
            Consumer<AppStringService>(
              builder: (context, ln, child) => Container(
                width: screenWidth / 4,
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const CreateTicketPage(),
                      ),
                    );
                  },
                  child: Container(
                      // width: double.infinity,

                      alignment: Alignment.center,
                      // padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: cc.primaryColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: AutoSizeText(
                        ln.getString('Create'),
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      )),
                ),
              ),
            ),
            const SizedBox(
              width: 25,
            ),
          ],
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          enablePullDown: context.watch<SupportTicketService>().currentPage > 1
              ? false
              : true,
          onRefresh: () async {
            final result =
                await Provider.of<SupportTicketService>(context, listen: false)
                    .fetchTicketList(context);
            if (result) {
              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result =
                await Provider.of<SupportTicketService>(context, listen: false)
                    .fetchTicketList(context);
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
            physics: physicsCommon,
            child: Consumer<SupportTicketService>(
                builder: (context, provider, child) => provider
                        .ticketList.isNotEmpty
                    ? Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0; i < provider.ticketList.length; i++)
                              InkWell(
                                onTap: () {
                                  print(
                                      'ticket id is ${provider.ticketList[i]['id']}');

                                  provider.goToMessagePage(
                                      context,
                                      provider.ticketList[i]['subject'],
                                      provider.ticketList[i]['id']);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    bottom: 3,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: cc.borderColor),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              '#${provider.ticketList[i]['id']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: cc.primaryColor,
                                              ),
                                            ),
                                            // put the hamburger icon here
                                            PopupMenuButton(
                                              // initialValue: 2,
                                              child:
                                                  const Icon(Icons.more_vert),
                                              itemBuilder: (context) {
                                                return List.generate(1,
                                                    (index) {
                                                  return PopupMenuItem(
                                                    onTap: () async {
                                                      await Future.delayed(
                                                          Duration.zero);
                                                      provider.goToMessagePage(
                                                          context,
                                                          provider.ticketList[i]
                                                              ['subject'],
                                                          provider.ticketList[i]
                                                              ['id']);
                                                    },
                                                    value: index,
                                                    child: Text(lnProvider
                                                        .getString('Chat')),
                                                  );
                                                });
                                              },
                                            )
                                          ],
                                        ),

                                        //Ticket title
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        CommonHelper().titleCommon(
                                            provider.ticketList[i]['subject']),

                                        //Divider
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 17, bottom: 12),
                                          child: CommonHelper().dividerCommon(),
                                        ),
                                        //Capsules
                                        Row(
                                          children: [
                                            SupportHelper().statusCapsule(
                                                provider.ticketList[i]
                                                    ['priority'],
                                                cc.greyThree),
                                            const SizedBox(
                                              width: 11,
                                            ),
                                            SupportHelper()
                                                .statusCapsuleBordered(
                                                    provider.ticketList[i]
                                                        ['status'],
                                                    cc.greyParagraph),
                                          ],
                                        )
                                      ]),
                                ),
                              )
                          ],
                        ),
                      )
                    : CommonHelper().nothingfound(context, 'No ticket')),
          ),
        ));
  }
}

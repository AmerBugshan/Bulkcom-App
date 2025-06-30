import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/view/campaign/components/people_donated_list.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../service/app_string_service.dart';
import '../../utils/common_styles.dart';

class AllPeopleWhoDonated extends StatelessWidget {
  const AllPeopleWhoDonated({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    final asProvider = Provider.of<AppStringService>(context, listen: false);
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    return Scaffold(
      appBar: CommonHelper()
          .appbarCommon(asProvider.getString('All donators'), context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown: context.watch<CampaignDetailsService>().currentPage > 1
            ? false
            : true,
        onRefresh: () async {
          final result =
              await Provider.of<CampaignDetailsService>(context, listen: false)
                  .fetchAllDonators(context, isrefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<CampaignDetailsService>(context, listen: false)
                  .fetchAllDonators(
            context,
          );
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
          child: Consumer<CampaignDetailsService>(
            builder: (context, provider, child) =>
                provider.allDonators.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenPadding,
                        ),
                        child: Column(
                          children: [
                            sizedBoxCustom(5),
                            GridView.builder(
                              gridDelegate: const FlutterzillaFixedGridView(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 15,
                                  height: 70),
                              itemCount: provider.allDonators.length,
                              shrinkWrap: true,
                              clipBehavior: Clip.none,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return DonatorCard(
                                    width: double.infinity,
                                    marginRight: 0,
                                    cc: cc,
                                    element: provider.allDonators[index],
                                    i: index);
                              },
                            ),
                            sizedBoxCustom(25),
                          ],
                        ))
                    : Container(),
          ),
        )),
        // footer: CommonHelper().commonRefreshFooter(context),
      ),
    );
  }
}

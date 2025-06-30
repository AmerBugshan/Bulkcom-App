import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/dashboard_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class DashboardCards extends StatelessWidget {
  const DashboardCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Provider.of<DashboardService>(context, listen: false)
        .fetchDashboardData(context);

    ConstantColors cc = ConstantColors();
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<DashboardService>(
        builder: (context, provider, child) =>
            provider.dashboardDataList.isNotEmpty
                ? GridView.builder(
                    gridDelegate: const FlutterzillaFixedGridView(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        height: 80),
                    padding: const EdgeInsets.only(top: 30),
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                dCardsList[index].icon,
                                height: 35,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      ln.getString(dCardsList[index].name),
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: cc.greyParagraph,
                                        height: 1.4,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    CommonHelper().titleCommon(provider
                                        .dashboardDataList[index]
                                        .toString()),
                                  ],
                                ),
                              )
                            ]),
                      );
                    },
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 70),
                    child: OthersHelper().showLoading(cc.primaryColor)),
      ),
    );
  }
}

class Dcards {
  String name;
  String icon;

  Dcards(this.name, this.icon);
}

List dCardsList = [
  Dcards('Events booking', 'assets/svg/event-circle.svg'),
  Dcards('Total donations', 'assets/svg/donations-circle.svg'),
  Dcards('Total campaign', 'assets/svg/campaign-circle.svg'),
  Dcards('Total reward pts', 'assets/svg/rewards-circle.svg'),
];

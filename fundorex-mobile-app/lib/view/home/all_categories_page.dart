import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterzilla_fixed_grid/flutterzilla_fixed_grid.dart';
import 'package:fundorex/service/category_service.dart';
import 'package:fundorex/view/campaign/campaign_by_category_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/config.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllCategoriesPage extends StatelessWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RefreshController refreshController =
        RefreshController(initialRefresh: true);

    ConstantColors cc = ConstantColors();
    return Scaffold(
      appBar: CommonHelper().appbarCommon('All categories', context, () {
        Navigator.pop(context);
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        enablePullDown:
            context.watch<CategoryService>().currentPage > 1 ? false : true,
        onRefresh: () async {
          final result =
              await Provider.of<CategoryService>(context, listen: false)
                  .fetchAllCategories(context);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result =
              await Provider.of<CategoryService>(context, listen: false)
                  .fetchAllCategories(context);
          if (result != null) {
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
          child: Consumer<CategoryService>(
            builder: (context, provider, child) => Container(
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
                          height: 58),
                      itemCount: provider.allCategories.length,
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    CampaignByCategoryPage(
                                  categoryId: provider.allCategories[index].id,
                                  categoryName:
                                      provider.allCategories[index].title,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: cc.borderColor),
                                borderRadius: BorderRadius.circular(9)),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 13,
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      height: 37,
                                      width: 37,
                                      imageUrl:
                                          provider.allCategories[index].image ??
                                              placeHolderUrl,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),
                                  //Title
                                  Flexible(
                                    child: Text(
                                      provider.allCategories[index].title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: cc.greyParagraph,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    sizedBoxCustom(25),
                  ],
                )),
          ),
        )),
      ),
    );
  }
}

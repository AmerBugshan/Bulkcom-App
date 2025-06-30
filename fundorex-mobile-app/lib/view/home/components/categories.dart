import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/category_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/view/campaign/campaign_by_category_page.dart';
import 'package:fundorex/view/home/all_categories_page.dart';
import 'package:fundorex/view/home/components/section_title.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.cc,
    required this.width,
    required this.marginRight,
  });
  final ConstantColors cc;

  final double width;
  final double marginRight;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<CategoryService>(
        builder: (context, provider, child) => provider.hasError != true
            ? provider.categoryList.isNotEmpty
                ? Consumer<RtlService>(
                    builder: (context, rtlP, child) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionTitle(
                          cc: cc,
                          title: ln.getString('Categories'),
                          pressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const AllCategoriesPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          height: 58,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            clipBehavior: Clip.none,
                            children: [
                              for (int i = 0;
                                  i < provider.categoryList.length;
                                  i++)
                                InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            CampaignByCategoryPage(
                                          categoryId:
                                              provider.categoryList[i].id,
                                          categoryName:
                                              provider.categoryList[i].title,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: width,
                                    margin: EdgeInsets.only(
                                      right: rtlP.direction == 'ltr'
                                          ? marginRight
                                          : 0,
                                      left: rtlP.direction == 'ltr'
                                          ? 0
                                          : marginRight,
                                    ),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: cc.borderColor),
                                        borderRadius: BorderRadius.circular(9)),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 13,
                                      ),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: CachedNetworkImage(
                                              height: 37,
                                              width: 37,
                                              imageUrl: provider
                                                  .categoryList[i].image,
                                              errorWidget:
                                                  (context, url, error) =>
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
                                              provider.categoryList[i].title,
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
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container()
            : Text(ln.getString('No category found')),
      ),
    );
  }
}

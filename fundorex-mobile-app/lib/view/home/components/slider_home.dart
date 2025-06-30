import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/service/slider_service.dart';
import 'package:fundorex/view/campaign/campaign_details_page.dart';
import 'package:fundorex/view/payment/donation_payment_choose_page.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:provider/provider.dart';

import '../../../service/campaign_details_service.dart';

class SliderHome extends StatelessWidget {
  const SliderHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();
    return Consumer<AppStringService>(
      builder: (context, ln, child) => Consumer<SliderService>(
        builder: (context, sliderProvider, child) => sliderProvider
                .sliderImageList.isNotEmpty
            ? SizedBox(
                height: 175,
                width: double.infinity,
                child: CarouselSlider.builder(
                  itemCount: sliderProvider.sliderImageList.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                    initialPage: 1,
                  ),
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: sliderProvider.sliderImageList[itemIndex]
                                ['imgUrl'],
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Consumer<RtlService>(
                        builder: (context, rtlP, child) => Positioned(
                            left: rtlP.direction == 'ltr' ? 25 : 0,
                            right: rtlP.direction == 'ltr' ? 0 : 25,
                            top: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    sliderProvider.sliderImageList[itemIndex]
                                        ['title'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: cc.greyFour,
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Text(
                                    sliderProvider.sliderImageList[itemIndex]
                                        ['subtitle'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: cc.greyFour,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: cc.secondaryColor,
                                        elevation: 0),
                                    onPressed: () {
                                      Provider.of<CampaignDetailsService>(
                                              context,
                                              listen: false)
                                          .fetchCampaignDetails(
                                              context: context,
                                              campaignId: sliderProvider
                                                      .sliderImageList[
                                                  itemIndex]['campaignId']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              CampaignDetailsPage(
                                                  campaignId: sliderProvider
                                                          .sliderImageList[
                                                      itemIndex]['campaignId']),
                                        ),
                                      );
                                    },
                                    child: Text(ln.getString('View Details')))
                              ],
                            )),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:provider/provider.dart';

class UploadCampaignImages extends StatefulWidget {
  const UploadCampaignImages({super.key, required this.networkImage});

  @override
  State<UploadCampaignImages> createState() => _UploadCampaignImagesState();

  final networkImage;
}

class _UploadCampaignImagesState extends State<UploadCampaignImages> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateCampaignService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHelper().labelCommon("Image"),
            Column(
              children: [
                //pick image button =====>
                CommonHelper().buttonPrimary('Choose image', () {
                  provider.pickImage(context);
                }, icon: Icons.image_outlined, paddingVertical: 15),

                sizedBoxCustom(15),
                provider.pickedImage != null
                    ? SizedBox(
                        height: 80,
                        child: ListView(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Image.file(
                                // File(provider.images[i].path),
                                File(provider.pickedImage.path),
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      )
                    : widget.networkImage != null
                        ? CachedNetworkImage(
                            imageUrl: widget.networkImage,
                            height: 80,
                            width: 80,
                          )
                        : Container(),
                sizedBoxCustom(5),

                //==========>
                //Image gallery =====>
                // CommonHelper().buttonPrimary('Image gallery', () {
                //   provider.pickImageGallery(context);
                // }, bgColor: cc.orangeColor),

                // sizedBoxCustom(15),

                // if (provider.imageGallery != null)
                //   if (provider.imageGallery!.isNotEmpty)
                //     SizedBox(
                //       height: 80,
                //       child: ListView(
                //         clipBehavior: Clip.none,
                //         scrollDirection: Axis.horizontal,
                //         shrinkWrap: true,
                //         children: [
                //           for (int i = 0; i < provider.imageGallery!.length; i++)
                //             InkWell(
                //               onTap: () {},
                //               child: Column(
                //                 children: [
                //                   Container(
                //                     margin: const EdgeInsets.only(right: 10),
                //                     child: Image.file(
                //                       // File(provider.images[i].path),
                //                       File(provider.imageGallery![i].path),
                //                       height: 80,
                //                       width: 80,
                //                       fit: BoxFit.cover,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //         ],
                //       ),
                //     ),

                // sizedBoxCustom(5),

                // //==========>
                // //Medical documents =====>
                // CommonHelper().buttonPrimary('Medical documents', () {
                //   provider.pickMedicalDocuments(context);
                // }, bgColor: Colors.black),

                // sizedBoxCustom(15),

                // if (provider.medicalDocuments != null)
                //   if (provider.medicalDocuments!.isNotEmpty)
                //     SizedBox(
                //       height: 80,
                //       child: ListView(
                //         clipBehavior: Clip.none,
                //         scrollDirection: Axis.horizontal,
                //         shrinkWrap: true,
                //         children: [
                //           for (int i = 0;
                //               i < provider.medicalDocuments!.length;
                //               i++)
                //             InkWell(
                //               onTap: () {},
                //               child: Column(
                //                 children: [
                //                   Container(
                //                     margin: const EdgeInsets.only(right: 10),
                //                     child: Image.file(
                //                       // File(provider.images[i].path),
                //                       File(provider.medicalDocuments![i].path),
                //                       height: 80,
                //                       width: 80,
                //                       fit: BoxFit.cover,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //         ],
                //       ),
                //     ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

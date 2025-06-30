import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class CreateCampaignFAQ extends StatefulWidget {
  const CreateCampaignFAQ({super.key});

  @override
  State<CreateCampaignFAQ> createState() => _CreateCampaignFAQState();
}

class _CreateCampaignFAQState extends State<CreateCampaignFAQ> {
  final faqTitleController = TextEditingController();
  final faqAnswerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<CreateCampaignService>(
      builder: (context, provider, child) => Consumer<AppStringService>(
        builder: (context, ln, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonHelper().labelCommon("FAQ title"),
            CustomInput(
              controller: faqTitleController,
              paddingHorizontal: 15,
              hintText: ln.getString("FAQ title"),
              textInputAction: TextInputAction.next,
            ),
            sizedBoxCustom(5),
            CommonHelper().labelCommon("FAQ description"),
            CustomInput(
              controller: faqAnswerController,
              paddingHorizontal: 15,
              hintText: ln.getString("FAQ description"),
              textInputAction: TextInputAction.next,
            ),

            //Add faq button
            //=========>
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    if (faqAnswerController.text.trim().isEmpty ||
                        faqTitleController.text.trim().isEmpty) {
                      OthersHelper().showSnackBar(
                          context,
                          ln.getString(
                              'You must enter FAQ title and description'),
                          Colors.red);
                      return;
                    }
                    provider.addFaq(
                        faqTitleController.text, faqAnswerController.text);

                    //clear
                    faqAnswerController.clear();
                    faqTitleController.clear();
                  },
                  child: Container(
                    color: cc.primaryColor,
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            sizedBoxCustom(5),

            //faq question answer
            //--------->
            if (provider.faqList.isNotEmpty)
              ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: provider.faqList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonHelper().labelCommon(
                                provider.faqList[index]['title'],
                                marginBottom: 5),
                            CommonHelper().paragraphCommon(
                                provider.faqList[index]['desc'],
                                fontsize: 13)
                          ]),
                      trailing: InkWell(
                        onTap: () {
                          provider.removeFaq(index);
                        },
                        child: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/write_comment_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/textarea_field.dart';
import 'package:provider/provider.dart';

class WriteCommentPage extends StatefulWidget {
  const WriteCommentPage({
    super.key,
    required this.campaignId,
  });

  final campaignId;
  @override
  State<WriteCommentPage> createState() => _WriteCommentPageState();
}

class _WriteCommentPageState extends State<WriteCommentPage> {
  TextEditingController reviewController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('Write a comment', context, () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        physics: physicsCommon,
        child: Consumer<AppStringService>(
          builder: (context, ln, child) => Consumer<ProfileService>(
            builder: (context, profileProvider, child) => Container(
              padding: EdgeInsets.symmetric(horizontal: screenPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 14,
                    ),
                    TextareaField(
                      controller: reviewController,
                      hintText: ln.getString('Write a comment'),
                    ),
                    sizedBox20(),
                    Consumer<WriteCommentService>(
                      builder: (context, provider, child) =>
                          CommonHelper().buttonPrimary('Comment', () {
                        if (provider.isloading == false) {
                          provider.writeComment(reviewController.text,
                              widget.campaignId, context);
                        }
                      }, isloading: provider.isloading == false ? false : true),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

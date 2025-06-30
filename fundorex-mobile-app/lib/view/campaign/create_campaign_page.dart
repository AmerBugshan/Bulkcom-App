import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/view/campaign/components/create_campaign_category_dropdown.dart';
import 'package:fundorex/view/campaign/components/create_campaign_faq.dart';
import 'package:fundorex/view/campaign/components/upload_campaign_images.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:fundorex/view/utils/textarea_field.dart';
import 'package:provider/provider.dart';

class CreateCampaignPage extends StatefulWidget {
  const CreateCampaignPage({super.key});

  @override
  State<CreateCampaignPage> createState() => _CreateCampaignPageState();
}

class _CreateCampaignPageState extends State<CreateCampaignPage> {
  @override
  void initState() {
    super.initState();

    Provider.of<CreateCampaignService>(context, listen: false)
        .fetchCampaignCategory(context);
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final amountController = TextEditingController();
  // final excerptController = TextEditingController();

  ConstantColors cc = ConstantColors();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var onlyDate = selectedDate.toString().split(' ');

    return Scaffold(
      appBar: CommonHelper().appbarCommon('Create campaign', context, () {
        Navigator.pop(context);

        Provider.of<CreateCampaignService>(context, listen: false)
            .makePickedImageAndFaqNull();
      }, bgColor: Colors.white),
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          Provider.of<CreateCampaignService>(context, listen: false)
              .makePickedImageAndFaqNull();
          return Future.value(true);
        },
        child: SafeArea(
            child: SingleChildScrollView(
                child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenPadding,
          ),
          child: Consumer<AppStringService>(
            builder: (context, ln, child) => Consumer<CreateCampaignService>(
              builder: (context, provider, child) => Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Title ============>
                      CommonHelper().labelCommon("Title"),
                      CustomInput(
                        controller: titleController,
                        paddingHorizontal: 15,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return ln.getString('Please enter campaign title');
                          }
                          return null;
                        },
                        hintText: ln.getString("Title"),
                        textInputAction: TextInputAction.next,
                      ),
                      sizedBoxCustom(5),

                      //description ============>
                      CommonHelper().labelCommon("Description"),
                      TextareaField(
                        controller: descController,
                        hintText: ln.getString('Campaign description'),
                      ),
                      // sizedBoxCustom(18),

                      // //amount ============>
                      // CommonHelper().labelCommon("Excerpt"),
                      // TextareaField(
                      //   controller: excerptController,
                      //   hintText: 'Short description',
                      // ),

                      sizedBoxCustom(18),

                      //amount ============>
                      CommonHelper().labelCommon("Amount"),
                      CustomInput(
                        controller: amountController,
                        paddingHorizontal: 15,
                        isNumberField: true,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return ln.getString('Please enter amount goal');
                          }
                          return null;
                        },
                        hintText: ln.getString("Amount"),
                        textInputAction: TextInputAction.next,
                      ),

                      // ============>
                      // Category dropdown ===============>
                      const CreateCampaignCategoryDropdown(),

                      // pick date
                      //===========>
                      sizedBoxCustom(20),
                      CommonHelper().labelCommon("End date"),
                      Container(
                        decoration: BoxDecoration(
                            color: ConstantColors().greySecondary,
                            borderRadius: BorderRadius.circular(8)),
                        child: Stack(
                          children: [
                            TextField(
                              showCursor: false,
                              readOnly: true,
                              onTap: () {
                                _selectDate(context);
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ConstantColors().primaryColor)),
                                  errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ConstantColors().warningColor)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              ConstantColors().primaryColor)),
                                  hintText: onlyDate[0],
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16)),
                            ),
                            Positioned(
                                right: 0,
                                top: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 12),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: cc.greyPrimary,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      sizedBoxCustom(20),

                      //upload campaign images
                      const UploadCampaignImages(
                        networkImage: null,
                      ),

                      //FQA
                      //==========>
                      sizedBoxCustom(5),
                      const CreateCampaignFAQ(),

                      sizedBoxCustom(15),
                      CommonHelper().buttonPrimary('Create', () {
                        if (provider.isLoading == false) {
                          if (_formKey.currentState!.validate()) {
                            if (descController.text.trim().isEmpty) {
                              OthersHelper().showSnackBar(
                                  context,
                                  ln.getString('You must enter a description'),
                                  Colors.red);
                              return;
                            }
                            if (double.tryParse(amountController.text.trim()) ==
                                null) {
                              //if not integer value
                              OthersHelper().showSnackBar(
                                  context,
                                  ln.getString('You must enter a valid amount'),
                                  Colors.red);
                              return;
                            }

                            provider.createCampaign(context,
                                title: titleController.text.trim(),
                                causeContent: descController.text.trim(),
                                amount: amountController.text.trim(),
                                deadLine: onlyDate[0]);
                          }
                        }
                      }, isloading: provider.isLoading == true ? true : false),
                      sizedBoxCustom(25),

                      //
                    ]),
              ),
            ),
          ),
        ))),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/support_ticket/create_ticket_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/common_styles.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/textarea_field.dart';
import 'package:provider/provider.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  _CreateTicketPageState createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController URLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonHelper().appbarCommon('اضافة منتج', context, () {
        Navigator.pop(context); // ✅ حذف makeOrderlistEmpty()
      }),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(true); // ✅ حذف makeOrderlistEmpty()
        },
        child: SingleChildScrollView(
          physics: physicsCommon,
          child: Consumer<AppStringService>(
            builder: (context, ln, child) =>
                Consumer<CreateTicketService>(
                  builder: (context, provider, child) => Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenPadding, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonHelper().labelCommon("اسم المنتج"),
                          CustomInput(
                            controller: titleController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال اسم المنتج';
                              }
                              return null;
                            },
                            hintText: "اسم المنتج",
                            paddingHorizontal: 18,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 15),

                          CommonHelper().labelCommon("الوصف"),
                          TextareaField(
                            hintText: 'اكتب وصف للمنتج',
                            controller: descController,
                          ),
                          const SizedBox(height: 15),

                          CommonHelper().labelCommon("رابط المنتج"),
                          CustomInput(
                            controller: URLController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال رابط المنتج';
                              }
                              return null;
                            },
                            hintText: "https://...",
                            paddingHorizontal: 18,
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 30),

                          CommonHelper().buttonPrimary('ارسل الاقتراح', () {
                            if (_formKey.currentState!.validate()) {
                              if (!provider.isLoading) {
                                provider.createTicket(
                                  context,
                                  titleController.text,
                                  descController.text,
                                  URLController.text,
                                );
                              }
                            }
                          },
                              isloading: provider.isLoading),
                        ],
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

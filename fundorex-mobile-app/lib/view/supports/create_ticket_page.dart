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

  @override
  void initState() {
    super.initState();
    // Provider.of<CreateTicketService>(context, listen: false)
    //     .fetchOrderDropdown(context);
  }

  TextEditingController descController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonHelper().appbarCommon('Create ticket', context, () {
          Provider.of<CreateTicketService>(context, listen: false)
              .makeOrderlistEmpty();
          Navigator.pop(context);
        }),
        body: WillPopScope(
          onWillPop: () {
            Provider.of<CreateTicketService>(context, listen: false)
                .makeOrderlistEmpty();
            return Future.value(true);
          },
          child: SingleChildScrollView(
            physics: physicsCommon,
            child: Consumer<AppStringService>(
              builder: (context, ln, child) => Consumer<CreateTicketService>(
                builder: (context, provider, child) => Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenPadding, vertical: 20),
                    child: Column(children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Priority dropdown ======>
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonHelper().labelCommon("Priority"),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: cc.greySecondary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    // menuMaxHeight: 200,
                                    isExpanded: true,
                                    value: provider.selectedPriority,
                                    icon: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: cc.greyFour),
                                    iconSize: 26,
                                    elevation: 17,
                                    style: TextStyle(color: cc.greyFour),
                                    onChanged: (newValue) {
                                      provider.setPriorityValue(newValue);

                                      //setting the id of selected value
                                      provider.setSelectedPriorityId(
                                          provider.priorityDropdownIndexList[
                                              provider.priorityDropdownList
                                                  .indexOf(newValue!)]);
                                    },
                                    items: provider.priorityDropdownList
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          ln.getString(value),
                                          style: TextStyle(
                                              color: cc.greyPrimary
                                                  .withOpacity(.8)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                            ],
                          ),

                          sizedBox20(),
                          CommonHelper().labelCommon("Title"),
                          CustomInput(
                            controller: titleController,
                            validation: (value) {
                              if (value == null || value.isEmpty) {
                                return ln
                                    .getString('Please enter ticket title');
                              }
                              return null;
                            },
                            hintText: ln.getString("Ticket title"),
                            // icon: 'assets/icons/user.png',
                            paddingHorizontal: 18,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          CommonHelper().labelCommon("Description"),
                          TextareaField(
                            hintText:
                                ln.getString('Please explain your problem'),
                            controller: descController,
                          ),

                          //Save button =========>

                          const SizedBox(
                            height: 30,
                          ),
                          CommonHelper().buttonPrimary('Create ticket', () {
                            if (_formKey.currentState!.validate()) {
                              if (provider.isLoading == false &&
                                  provider.hasOrder == true) {
                                provider.createTicket(
                                  context,
                                  titleController.text,
                                  provider.selectedPriority,
                                  descController.text,
                                  // provider.selectedOrderId
                                );
                              }
                            }
                          },
                              isloading:
                                  provider.isLoading == false ? false : true)
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

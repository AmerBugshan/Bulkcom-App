import 'package:flutter/material.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/country_states_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/custom_input.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class CountryStatesDropdowns extends StatefulWidget {
  const CountryStatesDropdowns({super.key, required this.cityController});

  @override
  State<CountryStatesDropdowns> createState() => _CountryStatesDropdownsState();

  final cityController;
}

class _CountryStatesDropdownsState extends State<CountryStatesDropdowns> {
  @override
  void initState() {
    super.initState();
    Provider.of<CountryStatesService>(context, listen: false)
        .fetchCountries(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<CountryStatesService>(
        builder: (context, provider, child) => Consumer<AppStringService>(
              builder: (context, ln, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //dropdown and search box
                  const SizedBox(
                    width: 17,
                  ),

                  // Country dropdown ===============>
                  CommonHelper().labelCommon("اختر بلدك"),
                  provider.countryDropdownList.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: cc.greySecondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              // menuMaxHeight: 200,
                              // isExpanded: true,
                              value: provider.selectedCountry,
                              icon: Icon(Icons.keyboard_arrow_down_rounded,
                                  color: cc.greyFour),
                              iconSize: 26,
                              elevation: 17,
                              style: TextStyle(color: cc.greyFour),
                              onChanged: (newValue) {
                                provider.setCountryValue(newValue);

                                // setting the id of selected value
                                provider.setSelectedCountryId(
                                    provider.countryDropdownIndexList[provider
                                        .countryDropdownList
                                        .indexOf(newValue)]);

                                //fetch states based on selected country
                                // provider.fetchStates(
                                //     provider.selectedCountryId, context);
                              },
                              items: provider.countryDropdownList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                        color: cc.greyPrimary.withOpacity(.8)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            OthersHelper().showLoading(cc.primaryColor)
                          ],
                        ),

                  const SizedBox(
                    height: 21,
                  ),
                  //Area============>
                  CommonHelper().labelCommon("City"),

                  CustomInput(
                    controller: widget.cityController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return ln.getString('ادخل مدينتك');
                      }
                      return null;
                    },
                    hintText: ln.getString("ادخل مدينتك"),
                    icon: 'assets/icons/location.png',
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  // const SizedBox(
                  //   height: 25,
                  // ),
                  // States dropdown ===============>
                  // CommonHelper().labelCommon("Choose states"),
                  // provider.statesDropdownList.isNotEmpty
                  //     ? Container(
                  //         width: double.infinity,
                  //         padding: const EdgeInsets.symmetric(horizontal: 15),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: cc.greyFive),
                  //           borderRadius: BorderRadius.circular(6),
                  //         ),
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<String>(
                  //             // menuMaxHeight: 200,
                  //             // isExpanded: true,
                  //             value: provider.selectedState,
                  //             icon: Icon(Icons.keyboard_arrow_down_rounded,
                  //                 color: cc.greyFour),
                  //             iconSize: 26,
                  //             elevation: 17,
                  //             style: TextStyle(color: cc.greyFour),
                  //             onChanged: (newValue) {
                  //               provider.setStatesValue(newValue);

                  //               //setting the id of selected value
                  //               provider.setSelectedStatesId(
                  //                   provider.statesDropdownIndexList[provider
                  //                       .statesDropdownList
                  //                       .indexOf(newValue)]);
                  //               // //fetch area based on selected country and state

                  //               provider.fetchArea(provider.selectedCountryId,
                  //                   provider.selectedStateId, context);

                  //               // print(provider.statesDropdownIndexList[provider
                  //               //     .statesDropdownList
                  //               //     .indexOf(newValue)]);
                  //             },
                  //             items: provider.statesDropdownList
                  //                 .map<DropdownMenuItem<String>>((value) {
                  //               return DropdownMenuItem(
                  //                 value: value,
                  //                 child: Text(
                  //                   value,
                  //                   style: TextStyle(
                  //                       color: cc.greyPrimary.withOpacity(.8)),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ),
                  //       )
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [OthersHelper().showLoading(cc.primaryColor)],
                  //       ),

                  // const SizedBox(
                  //   height: 25,
                  // ),

                  // Area dropdown ===============>
                  // CommonHelper().labelCommon("Choose area"),
                  // provider.areaDropdownList.isNotEmpty
                  //     ? Container(
                  //         width: double.infinity,
                  //         padding: const EdgeInsets.symmetric(horizontal: 15),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: cc.greyFive),
                  //           borderRadius: BorderRadius.circular(6),
                  //         ),
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<String>(
                  //             // menuMaxHeight: 200,
                  //             // isExpanded: true,
                  //             value: provider.selectedArea,
                  //             icon: Icon(Icons.keyboard_arrow_down_rounded,
                  //                 color: cc.greyFour),
                  //             iconSize: 26,
                  //             elevation: 17,
                  //             style: TextStyle(color: cc.greyFour),
                  //             onChanged: (newValue) {
                  //               provider.setAreaValue(newValue);

                  //               //setting the id of selected value
                  //               provider.setSelectedAreaId(provider
                  //                       .areaDropdownIndexList[
                  //                   provider.areaDropdownList.indexOf(newValue)]);
                  //             },
                  //             items: provider.areaDropdownList
                  //                 .map<DropdownMenuItem<String>>((value) {
                  //               return DropdownMenuItem(
                  //                 value: value,
                  //                 child: Text(
                  //                   value,
                  //                   style: TextStyle(
                  //                       color: cc.greyPrimary.withOpacity(.8)),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ),
                  //       )
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [OthersHelper().showLoading(cc.primaryColor)],
                  //       ),
                ],
              ),
            ));
  }
}

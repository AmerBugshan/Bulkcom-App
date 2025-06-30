import 'package:flutter/material.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class CreateCampaignCategoryDropdown extends StatelessWidget {
  const CreateCampaignCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final cc = ConstantColors();

    return Consumer<CreateCampaignService>(
      builder: (context, provider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonHelper().labelCommon("Category"),
          provider.categoryDropdownList.isNotEmpty
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
                      value: provider.selectedCategory,
                      icon: Icon(Icons.keyboard_arrow_down_rounded,
                          color: cc.greyFour),
                      iconSize: 26,
                      elevation: 17,
                      style: TextStyle(color: cc.greyFour),
                      onChanged: (newValue) {
                        provider.setCategoryValue(newValue);

                        // setting the id of selected value
                        provider.setSelectedCategoryId(provider
                                .categoryDropdownIndexList[
                            provider.categoryDropdownList.indexOf(newValue!)]);

                        //fetch states based on selected country
                        // provider.fetchStates(
                        //     provider.selectedCountryId, context);
                      },
                      items: provider.categoryDropdownList
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
                  children: [OthersHelper().showLoading(cc.primaryColor)],
                ),
        ],
      ),
    );
  }
}

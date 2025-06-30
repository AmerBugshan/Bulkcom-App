import 'package:flutter/material.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/follow_user_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:provider/provider.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileService>(builder: (context, ps, child) {
      return ps.profileDetails == null
          ? const SizedBox()
          : Row(
              children: [
                SizedBox(
                  height: 41,
                  width: 90,
                  child: Consumer<CampaignDetailsService>(
                    builder: (context, provider, child) =>
                        Consumer<FollowUserService>(
                      builder: (context, fProvider, child) => Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: CommonHelper().buttonPrimary(
                            fProvider.isFollowingUser ? 'Following' : 'Follow',
                            () {
                          if (fProvider.isLoading == true) return;

                          fProvider.followUser(
                              context: context,
                              userType: provider.campaignDetails.createdBy,
                              campaignOwnerId:
                                  provider.campaignDetails.campaignOwnerId);
                        },
                            paddingVertical: 5,
                            fontsize: 13,
                            borderRadius: 7,
                            isloading:
                                fProvider.isLoading == false ? false : true),
                      ),
                    ),
                  ),
                ),
              ],
            );
    });
  }
}

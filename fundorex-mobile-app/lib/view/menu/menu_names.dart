import 'package:flutter/material.dart';
import 'package:fundorex/view/campaign/create_campaign_page.dart';
import 'package:fundorex/view/campaign/followed_user_list_page.dart';
import 'package:fundorex/view/campaign/my_campaign/my_campaigns_page.dart';
import 'package:fundorex/view/dashboard/dashboard_page.dart';
import 'package:fundorex/view/donations/donations_list_page.dart';
import 'package:fundorex/view/events/events_bookings_page.dart';
import 'package:fundorex/view/reward_points/reward_points_page.dart';
import 'package:fundorex/view/supports/my_tickets_page.dart';

class MenuNames {
  String name;
  String icon;

  MenuNames(this.name, this.icon);
}

List menuNamesList = [
  MenuNames('Dashboard', 'assets/svg/dashboard.svg'),
  MenuNames('Events Booking', 'assets/svg/event.svg'),
  MenuNames('All Donations', 'assets/svg/donations.svg'),
  MenuNames('Following User Campaigns', 'assets/svg/following.svg'),
  MenuNames('All Support Ticket', 'assets/svg/support-ticket.svg'),
  MenuNames('Reward Points', 'assets/svg/rewards.svg'),
  MenuNames('Create campaign', 'assets/svg/following.svg'),
  MenuNames('My campaigns', 'assets/svg/following.svg'),
];

getNavLink(int i, BuildContext context) {
  if (i == 0) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const DashboardPage(),
      ),
    );
  } else if (i == 1) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const EventsBookingsPage(),
      ),
    );
  } else if (i == 2) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const DonationsListPage(),
      ),
    );
  } else if (i == 3) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const FollowedUserListPage(),
      ),
    );
  } else if (i == 4) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MyTicketsPage(),
      ),
    );
  } else if (i == 5) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const RewardPointsPage(),
      ),
    );
  } else if (i == 6) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const CreateCampaignPage(),
      ),
    );
  } else if (i == 7) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MyCampaignsPage(),
      ),
    );
  }
}

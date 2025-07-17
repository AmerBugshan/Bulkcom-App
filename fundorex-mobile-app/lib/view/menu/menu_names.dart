import 'package:flutter/material.dart';
import 'package:fundorex/view/campaign/followed_user_list_page.dart';
import 'package:fundorex/view/dashboard/dashboard_page.dart';
import 'package:fundorex/view/donations/donations_list_page.dart';
import 'package:fundorex/view/supports/my_tickets_page.dart';
import 'package:fundorex/view/menu/terms_conditions_page.dart';
import 'package:fundorex/view/menu/contact_methods_page.dart';

class MenuNames {
  final String name;
  final String icon;

  const MenuNames(this.name, this.icon);
}

// ✅ Explicit type to avoid the List<dynamic> issue
final List<MenuNames> menuNamesList = [
  MenuNames('لوحة التحكم', 'assets/svg/dashboard.svg'),
  MenuNames('مشترياتي', 'assets/svg/donations.svg'),
  MenuNames('الحملات المتابعة', 'assets/svg/following.svg'),
  MenuNames('اقتراح منتج جديد', 'assets/svg/support-ticket.svg'),
  MenuNames('الشروط والأحكام', 'assets/svg/terms.svg'),
  MenuNames('طرق التواصل', 'assets/svg/contact.svg'),
];

void getNavLink(int i, BuildContext context) {
  if (i == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  } else if (i == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DonationsListPage()),
    );
  } else if (i == 2) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FollowedUserListPage()),
    );
  } else if (i == 3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyTicketsPage()),
    );
  } else if (i == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
    );
  } else if (i == 5) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactMethodsPage()),
    );
  }
}

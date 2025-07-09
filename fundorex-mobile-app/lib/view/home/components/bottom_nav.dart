import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/responsive.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  const BottomNav(
      {super.key, required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();

    // Adjust the index for hidden tab (skipping الفعاليات)
    int adjustedIndex = currentIndex >= 2 ? currentIndex - 1 : currentIndex;

    return SizedBox(
      height: isIos ? 90 : 70,
      child: Consumer<AppStringService>(
        builder: (context, ln, child) => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          selectedItemColor: cc.primaryColor,
          unselectedItemColor: cc.greyFour,
          backgroundColor: cc.white,
          onTap: (index) {
            // Shift index back after hidden tab
            onTabTapped(index >= 1 ? index + 1 : index);
          },
          currentIndex: adjustedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset('assets/svg/home-icon.svg',
                    color: adjustedIndex == 0 ? cc.primaryColor : cc.greyFour,
                    semanticsLabel: 'Acme Logo'),
              ),
              label: ln.getString('الرئيسية'),
            ),
            if (false) ...[
              BottomNavigationBarItem(
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  // child: SvgPicture.asset('assets/svg/calendar.svg',
                  //     height: 19,
                  //     color: currentIndex == 1 ? cc.primaryColor : cc.greyFour,
                  //     semanticsLabel: 'Acme Logo'),
                ),
                label: ln.getString('الفعاليات'),
              ),
            ],
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset('assets/svg/settings-icon.svg',
                    color: adjustedIndex == 1 ? cc.primaryColor : cc.greyFour,
                    semanticsLabel: 'Acme Logo'),
              ),
              label: ln.getString('الاعدادات'),
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: SvgPicture.asset('assets/svg/user.svg',
                    height: 18,
                    color: adjustedIndex == 2 ? cc.primaryColor : cc.greyFour,
                    semanticsLabel: 'Acme Logo'),
              ),
              label: ln.getString('حسابي '),
            ),
          ],
        ),
      ),
    );
  }
}

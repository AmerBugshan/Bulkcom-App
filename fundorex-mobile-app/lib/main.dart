// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fundorex/service/all_donations_service.dart';
import 'package:fundorex/service/all_events_service.dart';
import 'package:fundorex/service/app_string_service.dart';
import 'package:fundorex/service/auth_services/apple_sign_in_sevice.dart';
import 'package:fundorex/service/auth_services/change_pass_service.dart';
import 'package:fundorex/service/auth_services/email_verify_service.dart';
import 'package:fundorex/service/auth_services/facebook_login_service.dart';
import 'package:fundorex/service/auth_services/google_sign_service.dart';
import 'package:fundorex/service/auth_services/login_service.dart';
import 'package:fundorex/service/auth_services/logout_service.dart';
import 'package:fundorex/service/auth_services/reset_password_service.dart';
import 'package:fundorex/service/auth_services/signup_service.dart';
import 'package:fundorex/service/bottom_nav_service.dart';
import 'package:fundorex/service/campaign_by_category_service.dart';
import 'package:fundorex/service/campaign_details_service.dart';
import 'package:fundorex/service/category_service.dart';
import 'package:fundorex/service/country_states_service.dart';
import 'package:fundorex/service/create_campaign_service.dart';
import 'package:fundorex/service/dashboard_service.dart';
import 'package:fundorex/service/donate_service.dart';
import 'package:fundorex/service/edit_campaign_service.dart';
import 'package:fundorex/service/event_book_pay_service.dart';
import 'package:fundorex/service/events_booking_service.dart';
import 'package:fundorex/service/featured_campaing_service.dart';
import 'package:fundorex/service/follow_user_service.dart';
import 'package:fundorex/service/followed_user_campaign_service.dart';
import 'package:fundorex/service/followed_user_list_service.dart';
import 'package:fundorex/service/my_campaign_list_service.dart';
import 'package:fundorex/service/pay_services/bank_transfer_service.dart';
import 'package:fundorex/service/pay_services/payment_choose_service.dart';
import 'package:fundorex/service/profile_edit_service.dart';
import 'package:fundorex/service/profile_service.dart';
import 'package:fundorex/service/quick_donation_dropdown_service.dart';
import 'package:fundorex/service/recent_campaing_service.dart';
import 'package:fundorex/service/reward_list_service.dart';
import 'package:fundorex/service/reedem_reward_service.dart';
import 'package:fundorex/service/related_campaign_service.dart';
import 'package:fundorex/service/reward_points_service.dart';
import 'package:fundorex/service/rtl_service.dart';
import 'package:fundorex/service/slider_service.dart';
import 'package:fundorex/service/support_ticket/create_ticket_service.dart';
import 'package:fundorex/service/support_ticket/support_messages_service.dart';
import 'package:fundorex/service/support_ticket/support_ticket_service.dart';
import 'package:fundorex/service/write_comment_service.dart';
import 'package:fundorex/themes/default_themes.dart';
import 'package:fundorex/view/account_delete/account_delete_view.dart';
import 'package:fundorex/view/intro/splash.dart';
import 'package:fundorex/view/utils/web_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'service/account_delete_service.dart';
import 'view/utils/constant_colors.dart';
import 'package:fundorex/view/auth/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  runApp(const MyApp());

  //get user id, so that we can clear everything cached by provider when user logs out and logs in again
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getInt('userId');
}

int? userId;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return MultiProvider(
      key: ObjectKey(userId),
      providers: [
        ChangeNotifierProvider(create: (_) => LoginService()),
        ChangeNotifierProvider(create: (_) => SignupService()),
        ChangeNotifierProvider(create: (_) => CountryStatesService()),
        ChangeNotifierProvider(create: (_) => ProfileService()),
        ChangeNotifierProvider(create: (_) => ChangePassService()),
        ChangeNotifierProvider(create: (_) => EmailVerifyService()),
        ChangeNotifierProvider(create: (_) => LogoutService()),
        ChangeNotifierProvider(create: (_) => ResetPasswordService()),
        ChangeNotifierProvider(create: (_) => RtlService()),
        ChangeNotifierProvider(create: (_) => GoogleSignInService()),
        ChangeNotifierProvider(create: (_) => FacebookLoginService()),
        ChangeNotifierProvider(create: (_) => SliderService()),
        ChangeNotifierProvider(create: (_) => QuickDonationDropdownService()),
        ChangeNotifierProvider(create: (_) => DonateService()),
        ChangeNotifierProvider(create: (_) => PaymentChooseService()),
        ChangeNotifierProvider(create: (_) => ProfileEditService()),
        ChangeNotifierProvider(create: (_) => RewardListService()),
        ChangeNotifierProvider(create: (_) => CreateTicketService()),
        ChangeNotifierProvider(create: (_) => SupportMessagesService()),
        ChangeNotifierProvider(create: (_) => SupportTicketService()),
        ChangeNotifierProvider(create: (_) => BottomNavService()),
        ChangeNotifierProvider(create: (_) => FeaturedCampaignService()),
        ChangeNotifierProvider(create: (_) => CategoryService()),
        ChangeNotifierProvider(create: (_) => RecentCampaignService()),
        ChangeNotifierProvider(create: (_) => CampaignDetailsService()),
        ChangeNotifierProvider(create: (_) => DashboardService()),
        ChangeNotifierProvider(create: (_) => AllDonationsService()),
        ChangeNotifierProvider(create: (_) => RelatedCampaignService()),
        ChangeNotifierProvider(create: (_) => FollowUserService()),
        ChangeNotifierProvider(create: (_) => FollowedUserListService()),
        ChangeNotifierProvider(create: (_) => AllEventsService()),
        ChangeNotifierProvider(create: (_) => EventsBookingService()),
        ChangeNotifierProvider(create: (_) => CampaignByCategoryService()),
        ChangeNotifierProvider(create: (_) => FollowedUserCampaignService()),
        ChangeNotifierProvider(create: (_) => RewardPointsService()),
        ChangeNotifierProvider(create: (_) => RedeemRewardService()),
        ChangeNotifierProvider(create: (_) => BankTransferService()),
        ChangeNotifierProvider(create: (_) => WriteCommentService()),
        ChangeNotifierProvider(create: (_) => EventBookPayService()),
        ChangeNotifierProvider(create: (_) => CreateCampaignService()),
        ChangeNotifierProvider(create: (_) => MyCampaignListService()),
        ChangeNotifierProvider(create: (_) => EditCampaignService()),
        ChangeNotifierProvider(create: (_) => AppStringService()),
        ChangeNotifierProvider(create: (_) => AccountDeleteService()),
        ChangeNotifierProvider(create: (_) => AppleSignInService()),
      ],
      child: Consumer<RtlService>(
        builder: (context, rtlP, child) => MaterialApp(
          title: 'Bulkcom | بلكوم',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', "GB")],
          builder: (context, rtlchild) {
            return Directionality(
              textDirection: rtlP.direction == 'ltr'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: rtlchild!,
            );
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: cc.white,
            inputDecorationTheme: DefaultThemes().inputDecorationTheme(context),
            outlinedButtonTheme: DefaultThemes().outlinedButtonTheme(context),
            elevatedButtonTheme: DefaultThemes().elevatedButtonTheme(context),
            appBarTheme: DefaultThemes().appBarTheme(context),
            checkboxTheme: DefaultThemes().checkboxTheme(),
          ),
          home: child,
          routes: {WebViewScreen.routeName: (_) => const WebViewScreen(),'/login': (_) => const LoginPage(),},
        ),
        child: const SplashScreen(),
      ),
    );
  }
}

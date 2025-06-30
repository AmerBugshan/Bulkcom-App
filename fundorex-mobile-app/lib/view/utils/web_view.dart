import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fundorex/helper/extension/context_extension.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:fundorex/view/utils/others_helper.dart';
import 'package:provider/provider.dart';

class WebViewScreen extends StatelessWidget {
  static const String routeName = 'web view screen';
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)!.settings.arguments as List;
    final title = routeData[0];
    String data = routeData[1];
    return Scaffold(
        appBar: CommonHelper().appbarCommon(title, context, () {
          context.popFalse;
        }),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: HtmlWidget(data),
        ));
  }
}

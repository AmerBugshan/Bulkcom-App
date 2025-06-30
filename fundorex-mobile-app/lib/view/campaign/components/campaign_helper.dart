import 'package:flutter/material.dart';
import 'package:fundorex/view/utils/constant_colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class CampaignHelper {
  ConstantColors cc = ConstantColors();

  List timeCardTitle = ['Days', 'Hours', 'Minutes', 'Seconds'];

  progressBar(raisedValue, goalValue) {
    var raised = raisedValue ?? 0.0;
    var goal = goalValue ?? 0.0;
    var progressPercent =
        double.parse(raised.toString()) / double.parse(goal.toString());

    if (progressPercent > 1) {
      progressPercent = 1.0;
    }
    return LinearPercentIndicator(
      lineHeight: 8.0,
      padding: EdgeInsets.zero,
      percent: progressPercent,
      barRadius: const Radius.circular(10),
      backgroundColor: Colors.grey.withOpacity(.2),
      progressColor: cc.secondaryColor,
    );
  }
}

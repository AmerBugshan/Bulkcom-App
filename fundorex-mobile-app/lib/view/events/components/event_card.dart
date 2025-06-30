// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fundorex/service/common_service.dart';
import 'package:fundorex/view/events/event_details_page.dart';
import 'package:fundorex/view/utils/common_helper.dart';
import 'package:fundorex/view/utils/constant_colors.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.imageLink,
    required this.title,
    required this.buttonText,
    required this.width,
    required this.marginRight,
    required this.pressed,
    required this.eventId,
    required this.date,
    required this.location,
  });

  final eventId;
  final imageLink;
  final title;
  final buttonText;
  final width;
  final double marginRight;
  final VoidCallback pressed;

  final date;
  final location;

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return InkWell(
      onTap: pressed,
      child: Container(
        alignment: Alignment.center,
        width: width,
        margin: EdgeInsets.only(right: marginRight, bottom: 15),
        decoration: BoxDecoration(
            border: Border.all(color: cc.borderColor),
            borderRadius: BorderRadius.circular(9)),
        padding: const EdgeInsets.fromLTRB(10, 10, 13, 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonHelper().profileImage(imageLink, 75, 78),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //service name ======>
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cc.greyFour,
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      //=================>
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        getDateOnly(date),
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cc.greyFour,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        location ?? '',
                        textAlign: TextAlign.start,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: cc.greyFour,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

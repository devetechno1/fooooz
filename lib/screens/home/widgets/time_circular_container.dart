import 'package:flutter/material.dart';

class TimeCircularContainer extends StatelessWidget {
  const TimeCircularContainer({
    super.key,
    required this.currentValue,
    required this.totalValue,
    required this.timeText,
    required this.timeType,
  });

  final int currentValue;
  final int totalValue;
  final String timeText;
  final String timeType;
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CircularProgressIndicator(
              value: currentValue / totalValue,
              backgroundColor: const Color.fromARGB(255, 240, 220, 220),
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              strokeWidth: 4.0,
              strokeCap: StrokeCap.round,
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            top: 4,
            right: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeText,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // SizedBox(width: 12,),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(timeType,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 7))),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

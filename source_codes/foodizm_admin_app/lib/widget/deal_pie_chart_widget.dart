import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:foodizm_admin_app/common/common.dart';
import 'indicator.dart';

class DealPieChartWidget extends StatefulWidget {
  const DealPieChartWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<DealPieChartWidget> {
  int? touchedIndex;
  var rng = new Random();
  List<Color> colors = [Colors.green, Colors.deepPurple, Colors.greenAccent, Colors.teal];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 18),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              children: [
                for (int i = 0; i < Common.totalDealsOrder.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Indicator(
                      color: colors[i],
                      text: Common.totalDealsOrder[i].title,
                      isSquare: true,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(Common.totalDealsOrder.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
        color: colors[i],
        value: double.parse(((Common.totalDealsOrder[i].totalOrder! / calculateTotalCount()) * 100).toStringAsFixed(1)),
        title: ((Common.totalDealsOrder[i].totalOrder! / calculateTotalCount()) * 100).toStringAsFixed(1) + '%',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
      );
    });
  }


  calculateTotalCount() {
    int count = 0;
    if (Common.totalDealsOrder.length == 4) {
      count = Common.totalDealsOrder[0].totalOrder! +
          Common.totalDealsOrder[1].totalOrder! +
          Common.totalDealsOrder[2].totalOrder! +
          Common.totalDealsOrder[3].totalOrder!;
    } else if (Common.totalDealsOrder.length == 3) {
      count = Common.totalDealsOrder[0].totalOrder! + Common.totalDealsOrder[1].totalOrder! + Common.totalDealsOrder[2].totalOrder!;
    } else if (Common.totalDealsOrder.length == 2) {
      count = Common.totalDealsOrder[0].totalOrder! + Common.totalDealsOrder[1].totalOrder!;
    } else {
      count = Common.totalDealsOrder[0].totalOrder!;
    }
    return double.parse(count.toString());
  }
}

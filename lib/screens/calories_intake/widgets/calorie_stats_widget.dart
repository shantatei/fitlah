import 'package:fitlah/models/calorie.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fitlah/utils/theme_colors.dart';

import '../../../models/calorie.dart';

class CalorieStats extends StatelessWidget {
  final List<Calorie> foodList;

  DateTime today = DateTime.now();
  CalorieStats({required this.foodList});

  num totalCalories = 0;
  num totalCarbs = 0;
  num totalFat = 0;
  num totalProtein = 0;
  num displayCalories = 0;

  static List<num> macroData = [];

  @override
  Widget build(BuildContext context) {
    void findNutriments(List<Calorie> foodTracks) {
      for (var scan in foodTracks) {
        totalCarbs += scan.carbs;
        totalFat += scan.fat;
        totalProtein += scan.protein;
        displayCalories += scan.calories;
      }
      totalCalories = 9 * totalFat + 4 * totalCarbs + 4 * totalProtein;
    }

    findNutriments(foodList);

    // ignore: deprecated_member_use
    List<PieChartSectionData> _sections = <PieChartSectionData>[];

    PieChartSectionData _fat = PieChartSectionData(
      color: const Color(FAT_COLOR),
      value: (9 * (totalFat) / totalCalories) * 100,
      title:
          '', // ((9 * totalFat / totalCalories) * 100).toStringAsFixed(0) + '%',
      radius: 50,
      // titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    PieChartSectionData _carbohydrates = PieChartSectionData(
      color: const Color(CARBS_COLOR),
      value: (4 * (totalCarbs) / totalCalories) * 100,
      title:
          '', // ((4 * totalCarbs / totalCalories) * 100).toStringAsFixed(0) + '%',
      radius: 50,
      // titleStyle: TextStyle(color: Colors.black, fontSize: 24),
    );

    PieChartSectionData _protein = PieChartSectionData(
      color: const Color(PROTEIN_COLOR),
      value: (4 * (totalProtein) / totalCalories) * 100,
      title:
          '', // ((4 * totalProtein / totalCalories) * 100).toStringAsFixed(0) + '%',
      radius: 50,
      // titleStyle: TextStyle(color: Colors.white, fontSize: 24),
    );

    _sections = [_fat, _protein, _carbohydrates];

    macroData = [displayCalories, totalProtein, totalCarbs, totalFat];

    totalCarbs = 0;
    totalFat = 0;
    totalProtein = 0;
    displayCalories = 0;

    Widget _chartLabels() {
      return Padding(
        padding: const EdgeInsets.only(top: 78.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Text('Carbs ',
                    style: TextStyle(
                      color: Color(CARBS_COLOR),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
                Text(macroData[2].toStringAsFixed(1) + 'g',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            const SizedBox(height: 3.0),
            Row(
              children: <Widget>[
                const Text('Protein ',
                    style: TextStyle(
                      color: Color(0xffFA8925),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
                Text(macroData[1].toStringAsFixed(1) + 'g',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
            const SizedBox(height: 3.0),
            Row(
              children: <Widget>[
                const Text('Fat ',
                    style: TextStyle(
                      color: Color(0xff01B4BC),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
                Text(macroData[3].toStringAsFixed(1) + 'g',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Open Sans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    )),
              ],
            ),
          ],
        ),
      );
    }

    Widget _calorieDisplay() {
      return Container(
        height: 74,
        width: 74,
        decoration: const BoxDecoration(
          color: Color(0xff5FA55A),
          shape: BoxShape.circle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(macroData[0].toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 22.0,
                  color: Colors.white,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w500,
                )),
            const Text('kcal',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      );
    }

    if (foodList.isEmpty) {
      return const Flexible(
        fit: FlexFit.loose,
        child: Text(
          'Add food to see calorie breakdown.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      return Container(
        child: Row(
          children: <Widget>[
            Stack(alignment: Alignment.center, children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sections: _sections,
                    borderData: FlBorderData(show: false),
                    centerSpaceRadius: 40,
                    sectionsSpace: 3,
                  ),
                ),
              ),
              _calorieDisplay(),
            ]),
            _chartLabels(),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const PriceChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots:
                data
                    .map(
                      (point) => FlSpot(
                        point['time'].millisecondsSinceEpoch.toDouble(),
                        point['price'].toDouble(),
                      ),
                    )
                    .toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}

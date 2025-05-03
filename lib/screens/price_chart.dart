import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RecommendationChart extends StatelessWidget {
  final Map<String, dynamic> latest;

  const RecommendationChart({required this.latest, super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'label': 'Strong Buy',
        'value': latest['strongBuy'] ?? 0,
        'color': Colors.green[800],
      },
      {'label': 'Buy', 'value': latest['buy'] ?? 0, 'color': Colors.green},
      {'label': 'Hold', 'value': latest['hold'] ?? 0, 'color': Colors.orange},
      {'label': 'Sell', 'value': latest['sell'] ?? 0, 'color': Colors.red[300]},
      {
        'label': 'Strong Sell',
        'value': latest['strongSell'] ?? 0,
        'color': Colors.red[800],
      },
    ];

    final double maxValue =
        (categories
            .map((c) => c['value'] as int)
            .reduce((a, b) => a > b ? a : b)).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Analyst Ratings (${latest['period'] ?? 'N/A'}) for ${latest['symbol'] ?? ''}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 300,
          child: BarChart(
            BarChartData(
              maxY: maxValue + 2,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (BarChartGroupData group) => Colors.black,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${categories[groupIndex]['label']}: ${rod.toY.toInt()}',
                      TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (double value, _) {
                      return Text(
                        categories[value.toInt()]['label'],
                        style: TextStyle(fontSize: 12),
                      );
                    },
                    reservedSize: 60,
                  ),
                ),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: false),
              barGroups:
                  categories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (data['value'] as int).toDouble(),
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                          color: data['color'],
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxValue + 2,
                            color: Colors.grey[200],
                          ),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList(),
            ),
          ),
        ),
        SizedBox(height: 20),
        ...categories.map(
          (c) => Row(
            children: [
              Container(width: 14, height: 14, color: c['color']),
              SizedBox(width: 6),
              Text("${c['label']}: ${c['value']}"),
            ],
          ),
        ),
      ],
    );
  }
}

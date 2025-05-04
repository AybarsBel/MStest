import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/app_constants.dart';

class IncomeChartWidget extends StatelessWidget {
  final Map<String, double> monthlyIncome;
  final double totalIncome;
  final double potentialIncome;

  const IncomeChartWidget({
    Key? key,
    required this.monthlyIncome,
    required this.totalIncome,
    required this.potentialIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monthsData = monthlyIncome.entries.toList();
    monthsData.sort((a, b) {
      final aParts = a.key.split('/');
      final bParts = b.key.split('/');
      if (aParts.length != 2 || bParts.length != 2) return 0;
      final aYear = int.parse(aParts[1]);
      final bYear = int.parse(bParts[1]);
      if (aYear != bYear) return aYear.compareTo(bYear);
      return int.parse(aParts[0]).compareTo(int.parse(bParts[0]));
    });

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Aylık Gelir Grafiği',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorConstants.textWhite,
              ),
            ),
            const SizedBox(height: 24),
            _buildTotalIncome(),
            const SizedBox(height: 32),
            SizedBox(
              height: 300,
              child: monthsData.isEmpty
                  ? const Center(
                      child: Text(
                        'Bu tarih aralığında gelir verisi bulunamadı',
                        style: TextStyle(
                          color: ColorConstants.textGrey,
                        ),
                      ),
                    )
                  : _buildBarChart(monthsData),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalIncome() {
    return Row(
      children: [
        Expanded(
          child: _buildTotalIncomeCard(
            title: 'Toplam Gelir',
            amount: totalIncome,
            icon: Icons.attach_money,
            color: ColorConstants.statusActive,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildTotalIncomeCard(
            title: 'Potansiyel Gelir',
            amount: potentialIncome,
            icon: Icons.trending_up,
            color: ColorConstants.primaryRed,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalIncomeCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.cardBlack,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(2)} ${AppConstants.currency}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<MapEntry<String, double>> monthsData) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: ColorConstants.cardBlack,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${monthsData[groupIndex].key}\n',
                const TextStyle(
                  color: ColorConstants.textWhite,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${rod.toY.toStringAsFixed(2)} ${AppConstants.currency}',
                    style: TextStyle(
                      color: ColorConstants.chartColors[0],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value < 0 || value >= monthsData.length) {
                  return const SizedBox();
                }
                final parts = monthsData[value.toInt()].key.split('/');
                if (parts.length != 2) return const SizedBox();
                
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${parts[0]}/${parts[1].substring(2)}',
                    style: const TextStyle(
                      color: ColorConstants.textGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        gridData: const FlGridData(
          show: true,
          horizontalInterval: 1000,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: ColorConstants.dividerColor,
              strokeWidth: 0.5,
              dashArray: [5, 5],
            );
          },
        ),
        barGroups: monthsData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.value,
                color: ColorConstants.chartColors[0],
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

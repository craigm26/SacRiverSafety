import 'package:flutter/material.dart';
import 'package:sacriversafety/data/services/drowning_statistics_service.dart';
import 'package:sacriversafety/presentation/themes/app_theme.dart';

class DrowningStatisticsWidget extends StatefulWidget {
  const DrowningStatisticsWidget({super.key});

  @override
  State<DrowningStatisticsWidget> createState() => _DrowningStatisticsWidgetState();
}

class _DrowningStatisticsWidgetState extends State<DrowningStatisticsWidget> {
  late Future<YearlyStatistics> _currentYearStats;
  late Future<List<YearlyStatistics>> _tenYearTrend;
  late Future<Map<String, SectionStatistics>> _sectionStats;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final service = DrowningStatisticsService();
    _currentYearStats = service.getCurrentYearStatistics();
    _tenYearTrend = service.getTenYearTrend();
    _sectionStats = service.getStatisticsBySection();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildCurrentYearStats(),
        const SizedBox(height: 16),
        _buildTenYearTrend(),
        const SizedBox(height: 16),
        _buildSectionBreakdown(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.warning, color: Colors.red, size: 24),
        const SizedBox(width: 8),
        Text(
          'River Safety Statistics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            setState(() {
              _loadData();
            });
          },
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh statistics',
        ),
      ],
    );
  }

  Widget _buildCurrentYearStats() {
    return FutureBuilder<YearlyStatistics>(
      future: _currentYearStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Card(
            color: Colors.red.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Error loading statistics: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final stats = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${stats.year} Statistics',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Incidents',
                        '${stats.totalIncidents}',
                        Icons.warning,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Fatal',
                        '${stats.fatalIncidents}',
                        Icons.favorite_border,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Rescues',
                        '${stats.rescues}',
                        Icons.emergency,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'With Life Jacket',
                        '${stats.incidentsWithLifeJackets}',
                        Icons.safety_divider,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatCard(
                        'Without Life Jacket',
                        '${stats.incidentsWithoutLifeJackets}',
                        Icons.cancel,
                        Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Most Common Activity: ${stats.mostCommonActivity}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Average Age: ${stats.averageAge.toStringAsFixed(1)} years',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTenYearTrend() {
    return FutureBuilder<List<YearlyStatistics>>(
      future: _tenYearTrend,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final trendData = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '10-Year Trend',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: _buildTrendChart(trendData),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendChart(List<YearlyStatistics> data) {
    if (data.isEmpty) return const Center(child: Text('No trend data available'));

    final maxFatal = data.map((d) => d.fatalIncidents).reduce((a, b) => a > b ? a : b);
    final maxTotal = data.map((d) => d.totalIncidents).reduce((a, b) => a > b ? a : b);

    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: TrendChartPainter(
        data: data,
        maxFatal: maxFatal.toDouble(),
        maxTotal: maxTotal.toDouble(),
      ),
    );
  }

  Widget _buildSectionBreakdown() {
    return FutureBuilder<Map<String, SectionStatistics>>(
      future: _sectionStats,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final sectionData = snapshot.data!;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistics by River Section',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...sectionData.entries.map((entry) => _buildSectionCard(entry.value)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard(SectionStatistics stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stats.sectionName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: ${stats.totalIncidents}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Fatal: ${stats.fatalIncidents}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Rescues: ${stats.rescues}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Most Common: ${stats.mostCommonActivity}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the trend chart
class TrendChartPainter extends CustomPainter {
  final List<YearlyStatistics> data;
  final double maxFatal;
  final double maxTotal;

  TrendChartPainter({
    required this.data,
    required this.maxFatal,
    required this.maxTotal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fatalPaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..color = Colors.red;

    final totalPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = Colors.orange;

    final width = size.width;
    final height = size.height;
    final padding = 40.0;
    final chartWidth = width - 2 * padding;
    final chartHeight = height - 2 * padding;

    // Draw grid lines
    _drawGrid(canvas, size, padding);

    // Draw data points and lines
    final points = <Offset>[];
    final fatalPoints = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = padding + (i / (data.length - 1)) * chartWidth;
      final yTotal = padding + (1 - data[i].totalIncidents / maxTotal) * chartHeight;
      final yFatal = padding + (1 - data[i].fatalIncidents / maxFatal) * chartHeight;

      points.add(Offset(x, yTotal));
      fatalPoints.add(Offset(x, yFatal));
    }

    // Draw lines
    for (int i = 1; i < points.length; i++) {
      canvas.drawLine(points[i - 1], points[i], totalPaint);
      canvas.drawLine(fatalPoints[i - 1], fatalPoints[i], fatalPaint);
    }

    // Draw points
    for (final point in points) {
      canvas.drawCircle(point, 3, Paint()..color = Colors.orange);
    }
    for (final point in fatalPoints) {
      canvas.drawCircle(point, 3, Paint()..color = Colors.red);
    }

    // Draw legend
    _drawLegend(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size, double padding) {
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Colors.grey.withOpacity(0.3);

    final width = size.width;
    final height = size.height;
    final chartWidth = width - 2 * padding;
    final chartHeight = height - 2 * padding;

    // Vertical lines
    for (int i = 0; i <= 5; i++) {
      final x = padding + (i / 5) * chartWidth;
      canvas.drawLine(Offset(x, padding), Offset(x, height - padding), paint);
    }

    // Horizontal lines
    for (int i = 0; i <= 5; i++) {
      final y = padding + (i / 5) * chartHeight;
      canvas.drawLine(Offset(padding, y), Offset(width - padding, y), paint);
    }
  }

  void _drawLegend(Canvas canvas, Size size) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    // Total incidents legend
    textPainter.text = TextSpan(
      text: 'Total Incidents',
      style: const TextStyle(color: Colors.orange, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, size.height - 40));

    // Fatal incidents legend
    textPainter.text = TextSpan(
      text: 'Fatal Incidents',
      style: const TextStyle(color: Colors.red, fontSize: 12),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(10, size.height - 25));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 
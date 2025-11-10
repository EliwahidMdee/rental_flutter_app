import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

/// Admin Reports Screen
/// 
/// Dashboard with financial reports and analytics

class AdminReportsScreen extends ConsumerWidget {
  const AdminReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Report',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Revenue',
                  '\$45,230',
                  Icons.attach_money,
                  Colors.green,
                  '+12.5%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Active Properties',
                  '42',
                  Icons.home_work,
                  Colors.blue,
                  '+3',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Tenants',
                  '128',
                  Icons.people,
                  Colors.orange,
                  '+8',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Occupancy Rate',
                  '94%',
                  Icons.check_circle,
                  Colors.purple,
                  '+2%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Revenue Chart
          Text(
            'Monthly Revenue',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: LineChart(
                  _buildRevenueChart(context),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Payment Status Chart
          Text(
            'Payment Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: 200,
                child: PieChart(
                  _buildPaymentStatusChart(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Recent Transactions
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ..._buildRecentTransactions(context),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildRevenueChart(BuildContext context) {
    return LineChartData(
      gridData: FlGridData(show: true),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                '\$${(value / 1000).toStringAsFixed(0)}k',
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
              if (value.toInt() >= 0 && value.toInt() < months.length) {
                return Text(
                  months[value.toInt()],
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: [
            const FlSpot(0, 35000),
            const FlSpot(1, 38000),
            const FlSpot(2, 42000),
            const FlSpot(3, 40000),
            const FlSpot(4, 43000),
            const FlSpot(5, 45000),
          ],
          isCurved: true,
          color: Colors.green,
          barWidth: 3,
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }

  PieChartData _buildPaymentStatusChart() {
    return PieChartData(
      sections: [
        PieChartSectionData(
          value: 85,
          title: '85%\nPaid',
          color: Colors.green,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          value: 10,
          title: '10%\nPending',
          color: Colors.orange,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        PieChartSectionData(
          value: 5,
          title: '5%\nLate',
          color: Colors.red,
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRecentTransactions(BuildContext context) {
    final transactions = [
      {'tenant': 'John Doe', 'amount': '\$1,200', 'date': 'Dec 1, 2024', 'status': 'Paid'},
      {'tenant': 'Jane Smith', 'amount': '\$1,500', 'date': 'Dec 1, 2024', 'status': 'Paid'},
      {'tenant': 'Bob Johnson', 'amount': '\$900', 'date': 'Dec 1, 2024', 'status': 'Pending'},
    ];

    return transactions.map((tx) {
      final isPaid = tx['status'] == 'Paid';
      return Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isPaid ? Colors.green.shade100 : Colors.orange.shade100,
            child: Icon(
              isPaid ? Icons.check : Icons.pending,
              color: isPaid ? Colors.green : Colors.orange,
            ),
          ),
          title: Text(tx['tenant']!),
          subtitle: Text(tx['date']!),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx['amount']!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                tx['status']!,
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

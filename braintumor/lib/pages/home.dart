import 'package:flutter/material.dart';
import 'AppStats.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final stats = AppStats();

    return Scaffold(
      appBar: AppBar(title: Text("Brain Scan Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatCard(
              icon: Icons.analytics,
              title: "Total Scans",
              value: stats.totalScans.toString(),
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.warning,
              title: "Tumor Detected",
              value: stats.tumorDetected.toString(),
              color: Colors.red,
            ),
            SizedBox(height: 16),
            _buildStatCard(
              icon: Icons.check_circle,
              title: "No Tumor",
              value: stats.noTumor.toString(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {}); // force refresh when returning from ScanPage
  }
}

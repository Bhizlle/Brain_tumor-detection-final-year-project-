import 'package:flutter/material.dart';
import 'ScanHistory.dart';
import 'scan_history_entry.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String _selectedFilter = 'All';

  final List<String> _filterOptions = [
    'All',
    'Gliomas',
    'Meningiomas',
    'Pituitary',
    'No Tumor',
  ];

  @override
  Widget build(BuildContext context) {
    final allEntries = ScanHistory().entries;
    final dateFormatter = DateFormat('yyyy-MM-dd  hh:mm a');

    // Filtered based on selected dropdown option
    final filteredEntries = _selectedFilter == 'All'
        ? allEntries
        : allEntries.where((entry) => entry.result == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan History"),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter,
            icon: Icon(Icons.filter_list, color: Colors.white),
            dropdownColor: Colors.deepPurple[50],
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedFilter = newValue!;
              });
            },
            items: _filterOptions
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              ),
            )
                .toList(),
          ),
          SizedBox(width: 12),
        ],
      ),
      body: filteredEntries.isEmpty
          ? Center(
        child: Text(
          "No scans for selected filter.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.separated(
        itemCount: filteredEntries.length,
        separatorBuilder: (_, __) => SizedBox(height: 10),
        padding: EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final entry = filteredEntries[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      entry.imageBytes,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tumor Type: ${entry.result}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Scanned on: ${dateFormatter.format(entry.timestamp)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

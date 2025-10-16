import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './ThemeManager.dart';
import './ScanHistory.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: SwitchListTile(
                title: Text(
                  "Dark Mode",
                  style: TextStyle(fontSize: 18),
                ),
                secondary: Icon(Icons.dark_mode),
                value: themeManager.isDarkMode,
                onChanged: (val) {
                  themeManager.toggleTheme();
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  "Clear Scan History",
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Confirm Deletion"),
                      content: Text("Are you sure you want to clear your scan history?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Clear"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    ScanHistory().clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("History cleared")),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

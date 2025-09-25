import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import '../pages/AppStats.dart';
import 'ScanHistory.dart';
import 'scan_history_entry.dart';

class ScanPage extends StatefulWidget {
  final VoidCallback? onScanComplete;

  ScanPage({required this.onScanComplete});

  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  Uint8List? _webImageBytes;
  String? _result = '';
  bool _isLoading = false;

  void _pickImageWeb() {
    final input = html.FileUploadInputElement()..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files?.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file!);
      reader.onLoadEnd.listen((event) {
        setState(() {
          _webImageBytes = reader.result as Uint8List;
          _result = ''; // reset result
        });
        // Do NOT scan automatically here
      });
    });
  }

  Future<void> _sendToFlask(Uint8List imageBytes) async {
    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/predict'),
    );

    request.files.add(
      http.MultipartFile.fromBytes('image', imageBytes, filename: 'mri.jpg'),
    );

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseData);

        setState(() {
          _result = decoded['tumor_type'];
          AppStats().recordResult(_result ?? "");
        });

        ScanHistory().addEntry(
          ScanHistoryEntry(
            imageBytes: imageBytes,
            result: decoded['tumor_type'],
            timestamp: DateTime.now(),
          ),
        );

        widget.onScanComplete?.call();
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error sending image to server.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan MRI Image")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_webImageBytes != null)
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.memory(
                      _webImageBytes!,
                      height: 280,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () => _sendToFlask(_webImageBytes!),
                    icon: Icon(Icons.search),
                    label: Text("Scan Image"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              )
            else
              Text("No image selected.", style: TextStyle(fontSize: 16, color: Colors.grey)),

            SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickImageWeb,
              icon: Icon(Icons.upload_file),
              label: Text("Upload MRI Image"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),
            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Scanning image..."),
                ],
              ),
            if (!_isLoading && _result != null && _result!.isNotEmpty)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.insights, color: Colors.deepPurple, size: 32),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          "Prediction: $_result",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

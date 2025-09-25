import 'dart:typed_data';

class ScanHistoryEntry {
  final Uint8List imageBytes;
  final String result;
  final DateTime timestamp;

  ScanHistoryEntry({
    required this.imageBytes,
    required this.result,
    required this.timestamp,
  });
}

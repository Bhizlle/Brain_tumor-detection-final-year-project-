import 'scan_history_entry.dart';

class ScanHistory {
  static final ScanHistory _instance = ScanHistory._internal();

  factory ScanHistory() => _instance;

  ScanHistory._internal();

  final List<ScanHistoryEntry> _entries = [];

  void addEntry(ScanHistoryEntry entry) {
    _entries.insert(0, entry); // newest first
  }

  List<ScanHistoryEntry> get entries => List.unmodifiable(_entries);

  void clear() => _entries.clear();
}

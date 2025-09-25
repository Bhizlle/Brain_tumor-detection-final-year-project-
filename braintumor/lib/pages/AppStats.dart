class AppStats {
  static final AppStats _instance = AppStats._internal();

  factory AppStats() {
    return _instance;
  }
  String lastTumorType = "";

  AppStats._internal();

  int totalScans = 0;
  int tumorDetected = 0;
  int noTumor = 0;

  void recordResult(String tumorType) {
    totalScans++;
    lastTumorType = tumorType;

    if (tumorType == "No Tumor") {
      noTumor++;
    } else {
      tumorDetected++;
    }
  }


  void reset() {
    totalScans = 0;
    tumorDetected = 0;
    noTumor = 0;
  }
}



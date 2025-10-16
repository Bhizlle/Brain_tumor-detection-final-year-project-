import 'package:flutter/material.dart';
import 'AppStats.dart';
import 'dart:html' as html;
import 'dart:js' as js;

class LearnPage extends StatefulWidget {
  @override
  _LearnPageState createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final TextEditingController _symptomController = TextEditingController();
  String? _predictedTumor;

  final Map<String, List<String>> symptomKeywords = {
    "Gliomas": ["seizure", "headache", "memory", "weakness", "numbness"],
    "Meningiomas": ["vision", "hearing", "personality", "headache"],
    "Pituitary": ["hormone", "fatigue", "irregular", "sexual", "vision"],
  };

  final Map<String, String> symptoms = {
    "Gliomas": "• Headaches\n• Seizures\n• Memory loss\n• Weakness or numbness in limbs",
    "Meningiomas": "• Vision problems\n• Headaches\n• Hearing loss\n• Personality changes",
    "Pituitary": "• Hormonal imbalance\n• Fatigue\n• Irregular periods or sexual dysfunction\n• Vision issues",
    "No Tumor": "✅ No tumor detected.\nKeep following general brain health tips to stay safe."
  };

  final Map<String, String> prevention = {
    "General": "• Avoid exposure to radiation.\n• Eat a healthy diet.\n• Exercise regularly.\n• Avoid smoking and toxins."
  };

  final Map<String, String> foodRecommendations = {
    "Gliomas": "• Leafy greens (spinach, kale)\n• Berries (blueberries)\n• Green tea\n• Omega-3 foods (salmon, flaxseeds)",
    "Meningiomas": "• Cruciferous veggies (broccoli)\n• Whole grains\n• Tomatoes and carrots\n• Antioxidant-rich fruits",
    "Pituitary": "• Vitamin D-rich foods\n• Lean proteins\n• Nuts and seeds\n• Complex carbs (sweet potatoes)",
    "No Tumor": "• Maintain brain-boosting foods:\n  - Berries\n  - Leafy greens\n  - Water"
  };

  final Map<String, String> learnMoreLinks = {
    "Gliomas": "https://www.cancer.gov/types/brain/patient/adult-glioblastoma-treatment-pdq",
    "Meningiomas": "https://www.mayoclinic.org/diseases-conditions/meningioma/symptoms-causes",
    "Pituitary": "https://www.hopkinsmedicine.org/health/conditions-and-diseases/pituitary-tumor",
    "No Tumor": "https://www.cancer.org/cancer/brain-spinal-cord-tumors-adults/about/what-is-brain-tumor.html",
  };

  void _checkSymptoms() {
    final input = _symptomController.text.toLowerCase();
    Map<String, int> scores = {
      "Gliomas": 0,
      "Meningiomas": 0,
      "Pituitary": 0,
    };

    for (var tumor in symptomKeywords.keys) {
      for (var keyword in symptomKeywords[tumor]!) {
        if (input.contains(keyword)) {
          scores[tumor] = scores[tumor]! + 1;
        }
      }
    }

    final bestMatch = scores.entries.reduce((a, b) => a.value > b.value ? a : b);
    setState(() {
      _predictedTumor = bestMatch.value > 0 ? bestMatch.key : "No match";
    });
  }

  void _startVoiceInput() {
    js.context.callMethod('startRecognition');
    html.window.onMessage.listen((event) {
      final data = event.data;
      if (data is String && data.trim().isNotEmpty) {
        setState(() {
          _symptomController.text = data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String type = AppStats().lastTumorType;

    return Scaffold(
      appBar: AppBar(title: Text("Learn About: $type")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInfoTile("🧠 Tumor Type", type),
          _buildExpandableTile("📌 Symptoms", symptoms[type],),
          _buildExpandableTile("🛡️ Prevention", prevention["General"]),
          _buildExpandableTile("🍽️ Food Recommendations", foodRecommendations[type]),
          _buildLinkTile("🔗 Learn More", learnMoreLinks[type]),

          const SizedBox(height: 30),
          Text("🤖 Symptom Checker", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          TextField(
            controller: _symptomController,
            decoration: InputDecoration(
              hintText: "Describe your symptoms...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              suffixIcon: IconButton(
                icon: Icon(Icons.mic),
                onPressed: _startVoiceInput,
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _startVoiceInput,
                  icon: Icon(Icons.mic, color: Colors.white,),
                  label: Text("Speak Symptoms", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _checkSymptoms,
                  icon: Icon(Icons.search, color: Colors.white,),
                  label: Text("Check Tumor Type", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),
            ],
          ),

          if (_predictedTumor != null) ...[
            const SizedBox(height: 10),
            Card(
              color: Colors.yellow.shade100,
              child: ListTile(
                leading: Icon(Icons.info_outline, color: Colors.orange),
                title: Text(
                  "Possible Tumor Type: $_predictedTumor",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Card(
      color: Colors.deepPurple.shade50,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text("$label: $value",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
      ),
    );
  }

  Widget _buildExpandableTile(String title, String? content) {
    return ExpansionTile(
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tilePadding: EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(content ?? "Information not available.", style: TextStyle(fontSize: 15)),
        ),
      ],
    );
  }

  Widget _buildLinkTile(String title, String? url) {
    final fallbackUrl = "https://www.google.com/search?q=brain+tumor";
    return Card(
      margin: const EdgeInsets.only(top: 12),
      child: ListTile(
        leading: Icon(Icons.open_in_new, color: Colors.blue),
        title: GestureDetector(
          onTap: () => html.window.open(url ?? fallbackUrl, '_blank'),
          child: Text(
            url ?? fallbackUrl,
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}

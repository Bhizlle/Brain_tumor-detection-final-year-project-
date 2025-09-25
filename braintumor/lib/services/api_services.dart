import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://127.0.0.1:5000/predict';

  static Future<Map<String, dynamic>> scanImage(File imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return json.decode(responseData);
    } else {
      throw Exception('Failed to connect to server');
    }
  }
}

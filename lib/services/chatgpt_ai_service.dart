import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:anecdotal/utils/constants.dart';

class ChatGPTService {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<Map<String, dynamic>> sendTextPrompt({
    required String message,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    final body = {
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a helpful assistant. Respond in valid JSON format with keys for summary, insights, recommendations, and suggestions. Ensure all string values are properly escaped.'
        },
        {'role': 'user', 'content': message},
      ],
      'max_tokens': 300,
      'temperature': 0.7,
    };

    final response = await _sendRequest(headers, body);
    return _parseJsonResponse(response);
  }

  static Future<Map<String, dynamic>> analyzeImages({
    required List<File> images,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    // Build the content
    final List<Map<String, dynamic>> content = [
      {
        'type': 'text',
        'text':
            'Analyze the following images and respond in valid JSON format with keys for summary, insights, recommendations, and suggestions. Ensure all string values are properly escaped. ' +
                prompt
      }
    ];

    // Add image URLs as plain text
    for (final image in images) {
      final imageBytes = await _readImageFromFile(image.path);
      if (imageBytes != null) {
        final imageData = base64Encode(imageBytes);
        content.add({
          'type': 'text',
          'text': 'Image data: data:image/jpeg;base64,$imageData'
        });
      }
    }

    final body = {
      'model': model,
      'messages': [
        {
          'role': 'user',
          'content': content,
        }
      ],
      'max_tokens': 500,
      'temperature': 0.7,
    };

    final response = await _sendRequest(headers, body);
    return _parseJsonResponse(response);
  }

  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $chatGPTPremiumApiKey',
    };
  }

  static Future<String> _sendRequest(
      Map<String, String> headers, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final choices = responseData['choices'] as List;
        if (choices.isNotEmpty) {
          return choices.first['message']['content'];
        }
      }

      if (kDebugMode) {
        print('Response Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return '{"error": "Failed to get a valid response"}';
  }

  static Map<String, dynamic> _parseJsonResponse(String response) {
    try {
      return jsonDecode(response);
    } catch (e) {
      print('Error parsing JSON: $e');
      print('Raw response: $response');

      return {"error": "Invalid JSON response", "raw_response": response};
    }
  }

  static Future<Uint8List?> _readImageFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      } else {
        print('Image file not found: $filePath');
        return null;
      }
    } catch (e) {
      print('Error reading image file: $e');
      return null;
    }
  }
}

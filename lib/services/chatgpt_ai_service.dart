import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:anecdotal/utils/constants/constants.dart';

class ChatGPTService {
  static Future<Map<String, dynamic>?> getChatGPTResponse({
    required String prompt,
    String? imageUrl,
    String? imagePath,
    String? model,
    required String apiKey,
  }) async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final List<Map<String, dynamic>> messages = [
      {
        'role': 'system',
        'content': '''
          You are a helpful AI assistant. Provide responses in JSON format with the following structure:
          {
            "summary": "A brief summary of the response",
            "insights": ["Key insight 1", "Key insight 2", ...],
            "recommendations": ["Recommendation 1", "Recommendation 2", ...],
            "suggestions": ["Suggestion 1", "Suggestion 2", ...],
            "citations": ["Citation 1", "Citation 2", ...]
          }
        '''
      },
      {
        'role': 'user',
        'content': [],
      },
    ];

    // Add prompt as text
    messages[1]['content'].add({'type': 'text', 'text': prompt});

    if (imageUrl != null) {
      // Add image URL
      messages[1]['content'].add({
        'type': 'image_url',
        'image_url': {'url': imageUrl}
      });
    } else if (imagePath != null) {
      final imageBytes = await _readImageFromFile(imagePath);
      if (imageBytes != null) {
        final imageData = base64Encode(imageBytes);
        // Add base64-encoded image as image URL
        messages[1]['content'].add({
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$imageData'}
        });
      }
    }

    final requestBody = {
      'model': model ?? gpt4OModel,
      'messages': messages,
      'max_tokens': 1000,
      'temperature': 0.7,
      'top_p': 1.0,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
      'response_format': {'type': 'json_object'},
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final choices = responseData['choices'] as List;
        if (choices.isNotEmpty) {
          final generatedAnswer = choices.first['message']['content'];
          return jsonDecode(generatedAnswer);
        }
      }
      // Print details for debugging
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } catch (error) {
      // Handle other exceptions
      print('Error: $error');
    }

    // Handle error cases or provide a default response
    return null;
  }

  static Future<Map<String, dynamic>?> analyzeImages({
    required List<File> images,
    required String prompt,
    String? preferredModel,
    required String apiKey,
  }) async {
    const apiUrl = 'https://api.openai.com/v1/chat/completions';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final List<Map<String, dynamic>> messages = [
      {
        'role': 'system',
        'content': '''
          You are a helpful AI assistant. Analyze the provided images and respond to the prompt. 
          Provide responses in JSON format with the following structure:
          {
            "summary": "A brief summary of the analysis",
            "insights": ["Key insight 1", "Key insight 2", ...],
            "recommendations": ["Recommendation 1", "Recommendation 2", ...],
            "suggestions": ["Suggestion 1", "Suggestion 2", ...],
            "citations": ["Citation 1", "Citation 2", ...]
          }
        '''
      },
      {
        'role': 'user',
        'content': [],
      },
    ];

    // Add prompt as text
    messages[1]['content'].add({'type': 'text', 'text': prompt});

    // Add images
    for (var image in images) {
      final imageBytes = await image.readAsBytes();
      final imageData = base64Encode(imageBytes);
      messages[1]['content'].add({
        'type': 'image_url',
        'image_url': {'url': 'data:image/jpeg;base64,$imageData'}
      });
    }

    final requestBody = {
      'model': preferredModel ?? gpt4OModel,
      'messages': messages,
      'max_tokens': 1000,
      'temperature': 0.7,
      'top_p': 1.0,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
      'response_format': {'type': 'json_object'},
    };

    try {
      final response = await http.post(Uri.parse(apiUrl),
          headers: headers, body: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final choices = responseData['choices'] as List;
        if (choices.isNotEmpty) {
          final generatedAnswer = choices.first['message']['content'];
          return jsonDecode(generatedAnswer);
        }
      }
      // Print details for debugging
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } catch (error) {
      // Handle other exceptions
      print('Error: $error');
    }

    // Handle error cases or provide a default response
    return null;
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

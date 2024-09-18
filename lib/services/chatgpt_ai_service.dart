import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:anecdotal/utils/constants/constants.dart';

class ChatGPTServiceG {
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

  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $chatGPTPremiumApiKey',
    };
  }

  static Future<Map<String, dynamic>> _sendRequest(
      Map<String, String> headers, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get response from ChatGPT');
    }
  }

  static Map<String, dynamic> _parseJsonResponse(
      Map<String, dynamic> response) {
    // Extract and structure the response similarly to Gemini's response
    final choices = response['choices'];
    if (choices != null && choices.isNotEmpty) {
      final content = choices.first['message']['content'];
      final jsonResponse = jsonDecode(content);
      return {
        'summary': jsonResponse['summary'] ?? 'No summary available.',
        'insights': jsonResponse['insights'] ?? [],
        'recommendations': jsonResponse['recommendations'] ?? [],
        'suggestions': jsonResponse['suggestions'] ?? [],
        'citations': jsonResponse['citations'] ?? [],
      };
    } else {
      return {
        'summary': 'No summary available.',
        'insights': [],
        'recommendations': [],
        'suggestions': [],
        'citations': [],
      };
    }
  }
}

class ChatGPTService {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<Map<String, dynamic>?> sendTextPrompt({
    required String message,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? 'gpt-4'; // Replace with your default model
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer YOUR_API_KEY_HERE', // Replace with your actual API key
    };

    final body = jsonEncode({
      'model': model,
      'messages': [
        {
          'role': 'system',
          'content':
              'You are a helpful assistant. Respond with a valid JSON object containing keys for summary, insights, recommendations, and suggestions. Do not use markdown or code blocks in your response.'
        },
        {'role': 'user', 'content': message},
      ],
      'max_tokens': 300,
      'temperature': 0.7,
    });

    try {
      final response =
          await http.post(Uri.parse(_apiUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        var content = jsonResponse['choices'][0]['message']['content'];

        // Remove any leading/trailing whitespace and backticks
        content = content.trim().replaceAll(RegExp(r'^```json\s*|\s*```$'), '');

        // Parse the content as JSON
        final parsedContent = jsonDecode(content);

        // Ensure the parsed content matches the expected structure
        return {
          'summary': parsedContent['summary'] ?? '',
          'insights': parsedContent['insights'] ?? [],
          'recommendations': parsedContent['recommendations'] ?? [],
          'suggestions': parsedContent['suggestions'] ?? [],
          'citations': parsedContent['citations'] ?? [],
        };
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  static Map<String, dynamic> _parseJsonResponse(http.Response response) {
    try {
      // Log the raw response for debugging
      print("Raw response body: ${response.body}");

      // Attempt to decode the JSON response
      final decodedResponse = jsonDecode(response.body);

      // Extract and structure the response similarly to Gemini's response
      final choices = decodedResponse['choices'];
      if (choices != null && choices.isNotEmpty) {
        final content = choices.first['message']['content'];

        // Log the content returned by OpenAI for further debugging
        print("OpenAI content: $content");

        final jsonResponse = jsonDecode(content);
        return {
          'summary': jsonResponse['summary'] ?? 'No summary available.',
          'insights': jsonResponse['insights'] ?? [],
          'recommendations': jsonResponse['recommendations'] ?? [],
          'suggestions': jsonResponse['suggestions'] ?? [],
          'citations': jsonResponse['citations'] ?? [],
        };
      } else {
        return {
          'summary': 'No summary available.',
          'insights': [],
          'recommendations': [],
          'suggestions': [],
          'citations': [],
        };
      }
    } catch (e) {
      // Catch and log any JSON format errors
      print("Error parsing JSON response: $e");

      // Return a default response in case of failure
      return {
        'summary': 'No summary available due to an error.',
        'insights': [],
        'recommendations': [],
        'suggestions': [],
        'citations': [],
      };
    }
  }
}

class ChatGPTServiceOld {
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
            'Analyze the following images and respond in valid JSON format with keys for summary, insights, recommendations, and suggestions. Ensure all string values are properly escaped. $prompt'
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

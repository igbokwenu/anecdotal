import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:anecdotal/utils/constants.dart';

class ChatGPTService {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String?> sendTextPrompt({
    required String message,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    final body = {
      'model': model,
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': message},
      ],
      'max_tokens': 150,
      'temperature': 0.7,
    };

    return _sendRequest(headers, body);
  }

  static Future<String?> sendImagePrompt({
    required String message,
    required String imagePath,
    String? preferredModel,
  }) async {
    return analyzeImages(
        images: [File(imagePath)],
        prompt: message,
        preferredModel: preferredModel);
  }

  static Future<String?> analyzeImages({
    required List<File> images,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    final List<Map<String, dynamic>> content = [
      {'type': 'text', 'text': prompt}
    ];

    for (final image in images) {
      final imageBytes = await _readImageFromFile(image.path);
      if (imageBytes != null) {
        final imageData = base64Encode(imageBytes);
        content.add({
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$imageData'}
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
      'max_tokens': 300,
      'temperature': 0.7,
    };

    return _sendRequest(headers, body);
  }

  static Future<String?> analyzeAudio({
    required List<File> audios,
    required String prompt,
    String? preferredModel,
  }) async {
    // Note: OpenAI doesn't directly support audio input in the same way as Gemini.
    // This method is a placeholder for future implementation or to use a different service.
    throw UnimplementedError(
        'Audio analysis is not yet supported for ChatGPT.');
  }

  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myOpenAIKey',
    };
  }

  static Future<String?> _sendRequest(
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
      }
      if (kDebugMode) {
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }

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

class ChatGPTHelper {
  static const String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  static Future<String?> sendTextPrompt({
    required String message,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    final body = {
      'model': model,
      'messages': [
        {'role': 'system', 'content': 'You are a helpful assistant.'},
        {'role': 'user', 'content': message},
      ],
      'max_tokens': 150,
      'temperature': 0.7,
      'top_p': 1.0,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    };

    return _sendRequest(headers, body);
  }

  static Future<String?> analyzeImage({
    required String prompt,
    String? imageUrl,
    String? imagePath,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    final List<Map<String, dynamic>> content = [
      {'type': 'text', 'text': prompt}
    ];

    if (imageUrl != null) {
      content.add({
        'type': 'image_url',
        'image_url': {'url': imageUrl}
      });
    } else if (imagePath != null) {
      final imageBytes = await _readImageFromFile(imagePath);
      if (imageBytes != null) {
        final imageData = base64Encode(imageBytes);
        content.add({
          'type': 'image_url',
          'image_url': {'url': 'data:image/jpeg;base64,$imageData'}
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
      'max_tokens': 150,
      'temperature': 0.7,
      'top_p': 1.0,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    };

    return _sendRequest(headers, body);
  }

  static Future<String?> analyzeMultipleImages({
    required String prompt,
    List<String>? imageUrls,
    List<String>? imagePaths,
    String? preferredModel,
  }) async {
    final model = preferredModel ?? gpt4OModel;
    final headers = _getHeaders();

    final List<Map<String, dynamic>> content = [
      {'type': 'text', 'text': prompt}
    ];

    if (imageUrls != null && imageUrls.isNotEmpty) {
      for (final url in imageUrls) {
        content.add({
          'type': 'image_url',
          'image_url': {'url': url}
        });
      }
    } else if (imagePaths != null && imagePaths.isNotEmpty) {
      for (final path in imagePaths) {
        final imageBytes = await _readImageFromFile(path);
        if (imageBytes != null) {
          final imageData = base64Encode(imageBytes);
          content.add({
            'type': 'image_url',
            'image_url': {'url': 'data:image/jpeg;base64,$imageData'}
          });
        }
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
      'max_tokens': 300, // Increased for potentially longer responses
      'temperature': 0.7,
      'top_p': 1.0,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    };

    return _sendRequest(headers, body);
  }

  static Future<String?> analyzeAudio(List<File> audios, String prompt) async {
    // Note: OpenAI doesn't directly support audio input in the same way as Gemini.
    // This method is a placeholder for future implementation or to use a different service.
    throw UnimplementedError(
        'Audio analysis is not yet supported for ChatGPT.');
  }

  static Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $myOpenAIKey',
    };
  }

  static Future<String?> _sendRequest(
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

      // Print details for debugging
      print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    } catch (error) {
      print('Error: $error');
    }

    return 'Failed to generate a response.';
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

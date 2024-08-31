import 'dart:io';
import 'dart:typed_data';
import 'package:anecdotal/utils/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static Future<String?> analyzeAudio({
    required List<File> audios,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
        model: preferredModel ?? geminiFlashModel, apiKey: geminiApiKey);

    final audioBytes = await Future.wait(audios.map((file) => file.readAsBytes()));
    List<DataPart> audioParts = [];
    for (var i = 0; i < audios.length; i++) {
      String mimeType = _getMimeType(audios[i].path);
      audioParts.add(DataPart(mimeType, audioBytes[i]));
    }

    final textPart = TextPart(prompt);
    final response = await model.generateContent([
      Content.multi([textPart, ...audioParts])
    ]);

    return response.text;
  }

  static Future<String?> analyzeImages({
    required List<File> images,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
        model: preferredModel ?? geminiFlashModel, apiKey: geminiApiKey);

    final imageBytes = await Future.wait(images.map((file) => file.readAsBytes()));
    final imageParts = imageBytes.map((bytes) => DataPart('image/jpeg', bytes)).toList();

    final textPart = TextPart(prompt);
    final response = await model.generateContent([
      Content.multi([textPart, ...imageParts])
    ]);

    return response.text;
  }

  static Future<String?> sendImagePrompt({
    required String message,
    required String imagePath,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
        model: preferredModel ?? geminiFlashModel, apiKey: geminiApiKey);

    try {
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      final content = [
        Content.multi([
          TextPart(message),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await model.generateContent(content);
      return response.text;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<String?> sendTextPrompt({
    required String message,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
        model: preferredModel ?? geminiFlashModel, apiKey: geminiApiKey);

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    return response.text;
  }

  static String _getMimeType(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'wav':
        return 'audio/wav';
      case 'mp3':
        return 'audio/mp3';
      case 'aiff':
        return 'audio/aiff';
      case 'aac':
        return 'audio/aac';
      case 'ogg':
        return 'audio/ogg';
      case 'flac':
        return 'audio/flac';
      default:
        throw UnsupportedError('Unsupported audio format: $extension');
    }
  }
}


class GeminiAIHelper {
  static Future<String> analyzeAudio(List<File> audios, String prompt) async {
    final model =
        GenerativeModel(model: geminiFlashModel, apiKey: geminiApiKey);

    // Convert the audio files to bytes
    final audioBytes =
        await Future.wait(audios.map((file) => file.readAsBytes()));

    // Determine MIME type based on file extension
    List<DataPart> audioParts = [];
    for (var i = 0; i < audios.length; i++) {
      String mimeType;
      String extension = audios[i].path.split('.').last.toLowerCase();
      switch (extension) {
        case 'wav':
          mimeType = 'audio/wav';
          break;
        case 'mp3':
          mimeType = 'audio/mp3';
          break;
        case 'aiff':
          mimeType = 'audio/aiff';
          break;
        case 'aac':
          mimeType = 'audio/aac';
          break;
        case 'ogg':
          mimeType = 'audio/ogg';
          break;
        case 'flac':
          mimeType = 'audio/flac';
          break;
        default:
          throw UnsupportedError('Unsupported audio format: $extension');
      }
      audioParts.add(DataPart(mimeType, audioBytes[i]));
    }

    final textPart = TextPart(prompt);

    final response = await model.generateContent([
      Content.multi([textPart, ...audioParts])
    ]);

    return response.text ?? 'Something went wrong 🥲';
  }

  static Future<String> analyzeImages(List<File> images, String prompt) async {
    // For text-and-image input (multimodal), use the gemini-pro-vision model
    final model =
        GenerativeModel(model: geminiFlashModel, apiKey: geminiApiKey);

    // Convert the image files to bytes
    final imageBytes =
        await Future.wait(images.map((file) => file.readAsBytes()));

    final imageParts =
        imageBytes.map((bytes) => DataPart('image/jpeg', bytes)).toList();

    final textPart = TextPart(prompt);

    final response = await model.generateContent([
      Content.multi([textPart, ...imageParts])
    ]);

    return response.text ?? 'Something went wrong 🥲';
  }

  static Future<String?> sendImagePrompt(
      {required String message, required String imagePath}) async {
    final GenerativeModel visionModel = GenerativeModel(
      model: geminiFlashModel,
      apiKey: geminiApiKey,
    );

    final List<Map<String, dynamic>> generatedContent = [];

    try {
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();

      final content = [
        Content.multi([
          TextPart(message),
          // The only accepted mime type is image/*.
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      generatedContent.add({
        'image': imagePath,
        'text': message,
        'fromUser': true,
      });

      final response = await visionModel.generateContent(content);
      final String? text = response.text;

      if (text == null) {
        // Return null if no response from API
        return null;
      } else {
        // Return the generated text
        generatedContent.add({'image': null, 'text': text, 'fromUser': false});
        return text;
      }
    } catch (e) {
      // Handle exceptions
      print('Error: $e');
      return null;
    }
  }

  static Future<String?> sendTextPrompt(
      {required String message, String? preferredModel}) async {
    final model = GenerativeModel(
        model: preferredModel ?? geminiFlashModel, apiKey: geminiApiKey);

    final prompt = message;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response.text;
  }
}

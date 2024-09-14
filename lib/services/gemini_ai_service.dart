import 'dart:io';
import 'dart:typed_data';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class GeminiService {
  static Future<Map<String, dynamic>?> sendTextPrompt({
    required String message,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiProModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(
          properties: {
            "summary": Schema.string(),
            "insights": Schema.array(items: Schema.string()),
            "recommendations": Schema.array(items: Schema.string()),
            "suggestions": Schema.array(items: Schema.string()),
            "citations": Schema.array(items: Schema.string()),
          },
        ),
      ),
    );

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    if (response.text != null) {
      return jsonDecode(response.text!);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> analyzeAudio({
    required List<File> audios,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(
          properties: {
            "firstName": Schema.string(),
            "lastName": Schema.string(),
            "gender": Schema.string(),
            "knownSymptoms": Schema.array(items: Schema.string()),
            "unknownSymptoms": Schema.array(items: Schema.string()),
            "country": Schema.string(),
            "state": Schema.string(),
            "recommendations": Schema.array(items: Schema.string()),
          },
        ),
      ),
    );

    final audioBytes =
        await Future.wait(audios.map((file) => file.readAsBytes()));
    List<DataPart> audioParts = [];
    for (var i = 0; i < audios.length; i++) {
      String mimeType = _getMimeType(audios[i].path);
      audioParts.add(DataPart(mimeType, audioBytes[i]));
    }

    final textPart = TextPart(prompt);
    final response = await model.generateContent([
      Content.multi([textPart, ...audioParts])
    ]);

    if (response.text != null) {
      return jsonDecode(response.text!);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> analyzeAudioForHome({
    required List<File> audios,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(
          properties: {
            "summary": Schema.string(),
            "insights": Schema.array(items: Schema.string()),
            "recommendations": Schema.array(items: Schema.string()),
            "suggestions": Schema.array(items: Schema.string()),
            "citations": Schema.array(items: Schema.string()),
          },
        ),
      ),
    );

    final audioBytes =
        await Future.wait(audios.map((file) => file.readAsBytes()));
    List<DataPart> audioParts = [];
    for (var i = 0; i < audios.length; i++) {
      String mimeType = _getMimeType(audios[i].path);
      audioParts.add(DataPart(mimeType, audioBytes[i]));
    }

    final textPart = TextPart(prompt);
    final response = await model.generateContent([
      Content.multi([textPart, ...audioParts])
    ]);

    if (response.text != null) {
      return jsonDecode(response.text!);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> analyzeImages({
    required List<File> images,
    required String prompt,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(
          properties: {
            "summary": Schema.string(),
            "insights": Schema.array(items: Schema.string()),
            "recommendations": Schema.array(items: Schema.string()),
            "suggestions": Schema.array(items: Schema.string()),
            "citations": Schema.array(items: Schema.string()),
          },
        ),
      ),
    );

    final imageBytes =
        await Future.wait(images.map((file) => file.readAsBytes()));
    final imageParts =
        imageBytes.map((bytes) => DataPart('image/jpeg', bytes)).toList();

    final textPart = TextPart(prompt);
    final response = await model.generateContent([
      Content.multi([textPart, ...imageParts])
    ]);

    if (response.text != null) {
      return jsonDecode(response.text!);
    } else {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> sendImagePrompt({
    required String message,
    required String imagePath,
    String? preferredModel,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(
          properties: {
            "summary": Schema.string(),
            "insights": Schema.array(items: Schema.string()),
            "recommendations": Schema.array(items: Schema.string()),
            "suggestions": Schema.array(items: Schema.string()),
          },
        ),
      ),
    );

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
      if (response.text != null) {
        return jsonDecode(response.text!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  static Future<String?> sendTextPromptWithoutJson({
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

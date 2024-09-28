import 'dart:io';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class GeminiService {

  static Future<Map<String, dynamic>?> sendTextPrompt({
    required String message,
    String? preferredModel,
    required String apiKey,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: apiKey,
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

  static Future<Map<String, dynamic>?> analyzeAudioForSignup({
    required List<File> audios,
    required String prompt,
    String? preferredModel,
    required String apiKey,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: Schema.object(
          properties: {
            "firstName": Schema.string(),
            "lastName": Schema.string(),
            "symptoms": Schema.array(items: Schema.string()),
            "country": Schema.string(),
            "state": Schema.string(),
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
    required String apiKey,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: apiKey,
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
    required String apiKey,
  }) async {
    final model = GenerativeModel(
      model: preferredModel ?? geminiFlashModel,
      apiKey: apiKey,
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

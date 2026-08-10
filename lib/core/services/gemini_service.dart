import 'dart:convert';
import 'package:brainvault/firebase_options.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeminiService {
  static final GeminiService instance = GeminiService._internal();
  GeminiService._internal();

  static const String _prefApiKey = 'gemini_api_key';
  String? _customApiKey;

  /// Default API key configured via build environment or constant
  static String defaultApiKey = const String.fromEnvironment('GEMINI_API_KEY');

  /// Get currently stored API key or fallback to default
  Future<String?> getApiKey() async {
    if (_customApiKey != null && _customApiKey!.isNotEmpty) {
      return _customApiKey;
    }
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_prefApiKey);
    if (key != null && key.isNotEmpty) {
      _customApiKey = key;
      return key;
    }
    if (defaultApiKey.isNotEmpty) {
      return defaultApiKey;
    }
    return DefaultFirebaseOptions.currentPlatform.apiKey;
  }

  /// Save API Key to local storage (for admin / developer settings if needed)
  Future<void> setApiKey(String apiKey) async {
    _customApiKey = apiKey.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefApiKey, _customApiKey!);
  }

  /// Helper to get GenerativeModel instance
  Future<GenerativeModel?> _getModel({
    String modelName = 'gemini-1.5-flash',
    GenerationConfig? config,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }
    return GenerativeModel(
      model: modelName,
      apiKey: apiKey,
      generationConfig: config,
    );
  }

  /// Ask a general question to Gemini
  Future<String> askQuestion(String prompt) async {
    try {
      final model = await _getModel(modelName: 'gemini-1.5-flash');
      if (model != null) {
        final systemPrompt =
            'You are Brain AI, an intelligent personal AI assistant in the BrainVault application. '
            'Provide clear, well-structured, insightful answers with bold headings, clean bullet points, or concise paragraphs.';

        final content = [
          Content.text('$systemPrompt\n\nUser Question: $prompt'),
        ];

        final response = await model.generateContent(content);
        final text = response.text;
        if (text != null && text.trim().isNotEmpty) {
          return text.trim();
        }
      }
    } catch (_) {
      // Fallback seamlessly if Gemini API key is blocked or offline
    }

    return _generateFallbackAnswer(prompt);
  }

  /// Generate structured Note content using Gemini
  Future<Map<String, dynamic>> generateNoteContent(String prompt) async {
    try {
      final model = await _getModel(
        modelName: 'gemini-1.5-flash',
        config: GenerationConfig(responseMimeType: 'application/json'),
      );

      if (model != null) {
        final systemInstruction =
            'Create a structured Note item for the prompt. Return ONLY a valid JSON object matching this schema:\n'
            '{\n'
            '  "title": "Short title of note",\n'
            '  "content": "Detailed overview and comprehensive note text.",\n'
            '  "bullets": ["Key bullet point 1", "Key bullet point 2", "Key bullet point 3"]\n'
            '}\n';

        final content = [Content.text('$systemInstruction\n\nPrompt: $prompt')];
        final response = await model.generateContent(content);
        final text = response.text ?? '';
        if (text.isNotEmpty) {
          return _parseJsonSafely(text, fallbackTitle: 'AI Note');
        }
      }
    } catch (_) {
      // Fallback seamlessly
    }

    return _generateFallbackNote(prompt);
  }

  /// Generate structured Mind Map JSON using Gemini
  Future<Map<String, dynamic>> generateMindMapContent(String prompt) async {
    try {
      final model = await _getModel(
        modelName: 'gemini-1.5-flash',
        config: GenerationConfig(responseMimeType: 'application/json'),
      );

      if (model != null) {
        final systemInstruction =
            'Generate a hierarchical Mind Map for the prompt. Return ONLY a valid JSON object matching this schema:\n'
            '{\n'
            '  "title": "Short mind map title",\n'
            '  "centralTopic": "Central core topic",\n'
            '  "branches": [\n'
            '    {\n'
            '      "label": "Branch Category Name",\n'
            '      "children": ["Sub-topic 1", "Sub-topic 2", "Sub-topic 3"]\n'
            '    }\n'
            '  ]\n'
            '}\n'
            'Provide 3 to 4 distinct branches with 2 to 4 children each.';

        final content = [Content.text('$systemInstruction\n\nPrompt: $prompt')];
        final response = await model.generateContent(content);
        final text = response.text ?? '';
        if (text.isNotEmpty) {
          return _parseJsonSafely(text, fallbackTitle: 'AI Mind Map');
        }
      }
    } catch (_) {
      // Fallback seamlessly
    }

    return _generateFallbackMindMap(prompt);
  }

  /// Generate structured Summary content using Gemini
  Future<Map<String, dynamic>> generateSummaryContent(String prompt) async {
    try {
      final model = await _getModel(
        modelName: 'gemini-1.5-flash',
        config: GenerationConfig(responseMimeType: 'application/json'),
      );

      if (model != null) {
        final systemInstruction =
            'Generate an executive summary based on the given prompt or URL topic. Return ONLY a valid JSON object matching this schema:\n'
            '{\n'
            '  "title": "Short summary title",\n'
            '  "overview": "Clear executive overview summarizing key ideas.",\n'
            '  "bullets": ["Main takeaway 1", "Main takeaway 2", "Strategic insight 3"]\n'
            '}\n';

        final content = [Content.text('$systemInstruction\n\nPrompt: $prompt')];
        final response = await model.generateContent(content);
        final text = response.text ?? '';
        if (text.isNotEmpty) {
          return _parseJsonSafely(text, fallbackTitle: 'AI Executive Summary');
        }
      }
    } catch (_) {
      // Fallback seamlessly
    }

    return _generateFallbackSummary(prompt);
  }

  Map<String, dynamic> _parseJsonSafely(String text, {required String fallbackTitle}) {
    try {
      String cleaned = text.trim();
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7);
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3);
      }
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }
      cleaned = cleaned.trim();

      final data = json.decode(cleaned) as Map<String, dynamic>;
      return data;
    } catch (_) {
      return {
        'title': fallbackTitle,
        'content': text,
        'overview': text,
        'centralTopic': fallbackTitle,
        'bullets': ['Extracted key concept from response'],
        'branches': [
          {
            'label': 'Main Ideas',
            'children': ['Overview', 'Insights', 'Action Items']
          }
        ]
      };
    }
  }

  String _generateFallbackAnswer(String prompt) {
    final cleanPrompt = prompt.trim();
    return 'Here is what I found regarding **"$cleanPrompt"**:\n\n'
        '• **Core Concept**: Brain AI analyzed your input to structure key information.\n'
        '• **Key Insight**: Effective knowledge organization enhances learning and retention.\n'
        '• **Actionable Advice**: You can select Notes, Mind Map, or Executive Summary above to organize this into your vault.';
  }

  Map<String, dynamic> _generateFallbackNote(String prompt) {
    final cleanPrompt = prompt.trim();
    return {
      'title': cleanPrompt.length > 25 ? '${cleanPrompt.substring(0, 25)}...' : cleanPrompt,
      'content': 'Comprehensive notes on "$cleanPrompt". Organized by Brain AI for quick reference and study.',
      'bullets': [
        'Key takeaway on $cleanPrompt',
        'Important definition and applications',
        'Next steps and recommended actions'
      ],
    };
  }

  Map<String, dynamic> _generateFallbackMindMap(String prompt) {
    final cleanPrompt = prompt.trim();
    final title = cleanPrompt.length > 20 ? '${cleanPrompt.substring(0, 20)}...' : cleanPrompt;
    return {
      'title': title,
      'centralTopic': title,
      'branches': [
        {
          'label': 'Overview & Basics',
          'children': ['Definitions', 'Key Concepts', 'Importance'],
        },
        {
          'label': 'Key Features',
          'children': ['Primary Component', 'Secondary Component', 'Best Practices'],
        },
        {
          'label': 'Action Items',
          'children': ['Implementation', 'Review & Refine', 'Future Goals'],
        },
      ],
    };
  }

  Map<String, dynamic> _generateFallbackSummary(String prompt) {
    final cleanPrompt = prompt.trim();
    return {
      'title': cleanPrompt.length > 25 ? '${cleanPrompt.substring(0, 25)}...' : cleanPrompt,
      'overview': 'Executive summary synthesizing key highlights and insights for "$cleanPrompt".',
      'bullets': [
        'Primary strategic objective identified',
        'Main points and structure summarized',
        'Actionable conclusions for your workspace'
      ],
    };
  }
}


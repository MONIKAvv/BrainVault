import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';

class GeminiService {
  static final GeminiService instance = GeminiService._internal();

  GeminiService._internal();

  // Gemini model through Firebase AI Logic
  late final GenerativeModel _model;

  // Prevent initializing the model multiple times
  bool _initialized = false;

  /// Initialize Firebase AI Logic Gemini model.
  ///
  /// IMPORTANT:
  /// Firebase.initializeApp() must already have been called
  /// before this method is called.
  Future<void> initialize() async {
    if (_initialized) return;

    final ai = FirebaseAI.googleAI();

    _model = ai.generativeModel(model: 'gemini-3.6-flash');

    _initialized = true;
  }

  /// Make sure Gemini is initialized before making a request.
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await initialize();
    }
  }

  // ---------------------------------------------------------------------------
  // GENERAL AI CHAT
  // ---------------------------------------------------------------------------

  /// Ask a general question to Brain AI.
  Future<String> askQuestion(String prompt) async {
    try {
      await _ensureInitialized();

      const systemPrompt = '''
You are Brain AI, an intelligent personal AI assistant
inside the BrainVault application.

Your job is to help users understand, organize, and learn information.

Provide:
- Clear explanations
- Useful structure
- Short headings when appropriate
- Bullet points when helpful
- Examples when useful
- Concise answers when the question is simple

Do not unnecessarily repeat the user's question.
''';

      final content = [
        Content.text('$systemPrompt\n\nUser Question:\n$prompt'),
      ];

      final response = await _model.generateContent(content);

      final text = response.text;

      if (text != null && text.trim().isNotEmpty) {
        return text.trim();
      }

      return 'I could not generate a response. Please try again.';
    } catch (e) {
      return 'Gemini request failed: $e';
    }
  }

  // ---------------------------------------------------------------------------
  // NOTES
  // ---------------------------------------------------------------------------

  /// Generate structured Note content.
  Future<Map<String, dynamic>> generateNoteContent(String prompt) async {
    try {
      await _ensureInitialized();

      const systemInstruction = '''
Create a structured study note from the user's input.

Return ONLY valid JSON.

The JSON must follow exactly this structure:

{
  "title": "Short title of note",
  "content": "Detailed explanation of the topic.",
  "bullets": [
    "Key point 1",
    "Key point 2",
    "Key point 3"
  ]
}

Rules:
- title must be short and descriptive
- content should explain the topic clearly
- bullets should contain the most important points
- do not return Markdown
- do not wrap the JSON in ```json
''';

      final response = await _model.generateContent(
        [Content.text('$systemInstruction\n\nUser Input:\n$prompt')],
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final text = response.text ?? '';

      if (text.trim().isNotEmpty) {
        return _parseJsonSafely(text, fallbackTitle: 'AI Note');
      }
    } catch (e) {
      // Return fallback rather than crashing the UI.
    }

    return _generateFallbackNote(prompt);
  }

  // ---------------------------------------------------------------------------
  // MIND MAP
  // ---------------------------------------------------------------------------

  /// Generate structured Mind Map JSON.
  Future<Map<String, dynamic>> generateMindMapContent(String prompt) async {
    try {
      await _ensureInitialized();

      const systemInstruction = '''
Create a hierarchical mind map from the user's input.

Return ONLY valid JSON.

The JSON must follow exactly this structure:

{
  "title": "Short mind map title",
  "centralTopic": "Central topic",
  "branches": [
    {
      "label": "Branch name",
      "children": [
        "Sub-topic 1",
        "Sub-topic 2",
        "Sub-topic 3"
      ]
    }
  ]
}

Rules:
- Create 3 to 5 main branches.
- Each branch should contain 2 to 5 children.
- Keep labels short.
- Organize information logically.
- Do not return Markdown.
- Do not wrap the JSON in ```json.
''';

      final response = await _model.generateContent(
        [Content.text('$systemInstruction\n\nUser Input:\n$prompt')],
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final text = response.text ?? '';

      if (text.trim().isNotEmpty) {
        return _parseJsonSafely(text, fallbackTitle: 'AI Mind Map');
      }
    } catch (e) {
      // Return fallback rather than crashing the UI.
    }

    return _generateFallbackMindMap(prompt);
  }

  // ---------------------------------------------------------------------------
  // SUMMARY
  // ---------------------------------------------------------------------------

  /// Generate structured Summary JSON.
  Future<Map<String, dynamic>> generateSummaryContent(String prompt) async {
    try {
      await _ensureInitialized();

      const systemInstruction = '''
Create an executive summary from the user's input.

Return ONLY valid JSON.

The JSON must follow exactly this structure:

{
  "title": "Short summary title",
  "overview": "Clear overview of the main ideas.",
  "bullets": [
    "Main takeaway 1",
    "Main takeaway 2",
    "Main takeaway 3"
  ]
}

Rules:
- overview should explain the main idea clearly
- bullets should contain the most important takeaways
- avoid unnecessary repetition
- do not return Markdown
- do not wrap the JSON in ```json
''';

      final response = await _model.generateContent(
        [Content.text('$systemInstruction\n\nUser Input:\n$prompt')],
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      final text = response.text ?? '';

      if (text.trim().isNotEmpty) {
        return _parseJsonSafely(text, fallbackTitle: 'AI Executive Summary');
      }
    } catch (e) {
      // Return fallback rather than crashing the UI.
    }

    return _generateFallbackSummary(prompt);
  }

  // ---------------------------------------------------------------------------
  // JSON PARSER
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _parseJsonSafely(
    String text, {
    required String fallbackTitle,
  }) {
    try {
      String cleaned = text.trim();

      // Remove Markdown code fences if Gemini returns them anyway.
      if (cleaned.startsWith('```json')) {
        cleaned = cleaned.substring(7);
      } else if (cleaned.startsWith('```')) {
        cleaned = cleaned.substring(3);
      }

      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }

      cleaned = cleaned.trim();

      final decoded = json.decode(cleaned);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return {'title': fallbackTitle, 'content': cleaned};
    } catch (_) {
      return {
        'title': fallbackTitle,
        'content': text,
        'overview': text,
        'centralTopic': fallbackTitle,
        'bullets': ['Extracted key concept from AI response'],
        'branches': [
          {
            'label': 'Main Ideas',
            'children': ['Overview', 'Insights', 'Key Points'],
          },
        ],
      };
    }
  }

  // ---------------------------------------------------------------------------
  // FALLBACK ANSWER
  // ---------------------------------------------------------------------------

  String _generateFallbackAnswer(String prompt) {
    final cleanPrompt = prompt.trim();

    return '''
Here is what I found regarding **"$cleanPrompt"**:

• **Core Concept:** Brain AI analyzed your input to structure the information.

• **Key Insight:** Organizing information into notes, summaries, and mind maps can make learning easier.

• **Next Step:** Select Notes, Mind Map, or Summary to organize the information in BrainVault.
''';
  }

  // ---------------------------------------------------------------------------
  // FALLBACK NOTE
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _generateFallbackNote(String prompt) {
    final cleanPrompt = prompt.trim();

    return {
      'title': cleanPrompt.length > 25
          ? '${cleanPrompt.substring(0, 25)}...'
          : cleanPrompt,
      'content': 'Comprehensive notes on "$cleanPrompt".',
      'bullets': [
        'Key takeaway about $cleanPrompt',
        'Important concepts and definitions',
        'Applications and examples',
      ],
    };
  }

  // ---------------------------------------------------------------------------
  // FALLBACK MIND MAP
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _generateFallbackMindMap(String prompt) {
    final cleanPrompt = prompt.trim();

    final title = cleanPrompt.length > 20
        ? '${cleanPrompt.substring(0, 20)}...'
        : cleanPrompt;

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
          'children': [
            'Primary Component',
            'Secondary Component',
            'Best Practices',
          ],
        },
        {
          'label': 'Applications',
          'children': ['Implementation', 'Examples', 'Use Cases'],
        },
      ],
    };
  }

  // ---------------------------------------------------------------------------
  // FALLBACK SUMMARY
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _generateFallbackSummary(String prompt) {
    final cleanPrompt = prompt.trim();

    return {
      'title': cleanPrompt.length > 25
          ? '${cleanPrompt.substring(0, 25)}...'
          : cleanPrompt,
      'overview':
          'Executive summary of the main ideas related to "$cleanPrompt".',
      'bullets': [
        'Primary concept identified',
        'Main points summarized',
        'Important conclusions highlighted',
      ],
    };
  }
}

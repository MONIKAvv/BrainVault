import 'package:flutter/material.dart';

/// Data models for Vault items
class NoteItem {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final DateTime createdAt;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;

  NoteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.createdAt,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
  });
}

class MindMapNode {
  final String id;
  final String label;
  final List<String> children;

  MindMapNode({
    required this.id,
    required this.label,
    required this.children,
  });
}

class MindMapItem {
  final String id;
  final String title;
  final String sourceUrl;
  final String centralTopic;
  final List<MindMapNode> branches;
  final DateTime createdAt;

  MindMapItem({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.centralTopic,
    required this.branches,
    required this.createdAt,
  });
}

class SummaryItem {
  final String id;
  final String title;
  final String sourceUrl;
  final String sourceCategory; // 'YouTube' or 'Website'
  final String overview;
  final List<String> bulletPoints;
  final DateTime createdAt;

  SummaryItem({
    required this.id,
    required this.title,
    required this.sourceUrl,
    required this.sourceCategory,
    required this.overview,
    required this.bulletPoints,
    required this.createdAt,
  });
}

/// Central Repository for user notes, mind maps, and summaries
class VaultRepository extends ChangeNotifier {
  static final VaultRepository instance = VaultRepository._internal();
  VaultRepository._internal() {
    _initDemoData();
  }

  final List<NoteItem> _notes = [];
  final List<MindMapItem> _mindMaps = [];
  final List<SummaryItem> _summaries = [];

  List<NoteItem> get notes => List.unmodifiable(_notes);
  List<MindMapItem> get mindMaps => List.unmodifiable(_mindMaps);
  List<SummaryItem> get summaries => List.unmodifiable(_summaries);

  void _initDemoData() {
    _notes.addAll([
      NoteItem(
        id: '1',
        title: 'Project Ideas',
        subtitle: 'Today, 9:30 AM',
        content: 'AI Note Summary, Voice to Text, Mind Map Generation, Smart Search',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        iconBg: const Color(0xFFFFEDD5),
        iconColor: const Color(0xFFEA580C),
        icon: Icons.edit_note_rounded,
      ),
      NoteItem(
        id: '2',
        title: 'Study Plan',
        subtitle: 'Today, 8:15 AM',
        content: 'Flutter Architecture, Provider State Management, Clean Code',
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        iconBg: const Color(0xFFF3E8FF),
        iconColor: const Color(0xFF9333EA),
        icon: Icons.article_outlined,
      ),
      NoteItem(
        id: '3',
        title: 'Book Summary',
        subtitle: 'Yesterday, 6:45 PM',
        content: 'Atomic Habits key takeaways and daily tracker implementation',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        iconBg: const Color(0xFFECFDF5),
        iconColor: const Color(0xFF10B981),
        icon: Icons.menu_book_outlined,
      ),
    ]);

    _mindMaps.addAll([
      MindMapItem(
        id: 'mm1',
        title: 'Flutter App Architecture',
        sourceUrl: 'https://youtube.com/watch?v=flutter_arch',
        centralTopic: 'Mobile App Architecture',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        branches: [
          MindMapNode(
            id: 'n1',
            label: 'Presentation Layer',
            children: ['Widgets', 'Screens', 'State Controllers'],
          ),
          MindMapNode(
            id: 'n2',
            label: 'Domain Layer',
            children: ['Use Cases', 'Entities', 'Contracts'],
          ),
          MindMapNode(
            id: 'n3',
            label: 'Data Layer',
            children: ['Repositories', 'Data Sources', 'DTO Models'],
          ),
        ],
      ),
      MindMapItem(
        id: 'mm2',
        title: 'Artificial Intelligence Basics',
        sourceUrl: 'https://wikipedia.org/wiki/Artificial_intelligence',
        centralTopic: 'Artificial Intelligence',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        branches: [
          MindMapNode(
            id: 'n4',
            label: 'Machine Learning',
            children: ['Supervised', 'Unsupervised', 'Reinforcement'],
          ),
          MindMapNode(
            id: 'n5',
            label: 'Deep Learning',
            children: ['Neural Networks', 'CNN', 'Transformers'],
          ),
          MindMapNode(
            id: 'n6',
            label: 'Applications',
            children: ['NLP', 'Computer Vision', 'Robotics'],
          ),
        ],
      ),
    ]);

    _summaries.addAll([
      SummaryItem(
        id: 's1',
        title: 'Key Takeaways: Modern Web & Mobile Development',
        sourceUrl: 'https://youtube.com/watch?v=tech_trends',
        sourceCategory: 'YouTube',
        overview:
            'A comprehensive breakdown of upcoming design systems, AI integrations, and mobile application optimization practices.',
        bulletPoints: [
          'Cross-platform development speed accelerated by 40% using modern state management.',
          'AI-assisted code generation reduces boilerplate by over 60%.',
          'Responsive visual polish and modern color palettes enhance user retention.',
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      SummaryItem(
        id: 's2',
        title: 'Effective Product Management Guide',
        sourceUrl: 'https://medium.com/product-management-guide',
        sourceCategory: 'Website',
        overview:
            'Best practices for roadmap planning, user research synthesis, and rapid prototyping in agile teams.',
        bulletPoints: [
          'Prioritize high-impact features through rapid feedback loops.',
          'Maintain clear documentation and decoupled component design.',
          'Emphasize accessibility and seamless micro-animations.',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  void addNote(NoteItem note) {
    _notes.insert(0, note);
    notifyListeners();
  }

  void addMindMap(MindMapItem mindMap) {
    _mindMaps.insert(0, mindMap);
    notifyListeners();
  }

  void addSummary(SummaryItem summary) {
    _summaries.insert(0, summary);
    notifyListeners();
  }
}

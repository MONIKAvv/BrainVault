import 'package:brainvault/core/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Data models for Vault items with Cloud Firestore serialization
class NoteItem {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final DateTime createdAt;
  final Color iconBg;
  final Color iconColor;
  final IconData icon;
  final String? imageUrl;
  final String? audioUrl;
  final List<Map<String, dynamic>>? checklist;
  final String fontFamily;
  final double fontSize;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final bool isPinned;
  final String? folderName;

  NoteItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.createdAt,
    required this.iconBg,
    required this.iconColor,
    required this.icon,
    this.imageUrl,
    this.audioUrl,
    this.checklist,
    this.fontFamily = 'Inter',
    this.fontSize = 15.0,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.isPinned = false,
    this.folderName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'iconBg': iconBg.toARGB32(),
      'iconColor': iconColor.toARGB32(),
      'iconCodePoint': icon.codePoint,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'checklist': checklist,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'isBold': isBold,
      'isItalic': isItalic,
      'isUnderline': isUnderline,
      'isPinned': isPinned,
      'folderName': folderName,
    };
  }

  factory NoteItem.fromMap(Map<String, dynamic> map, {String fallbackId = ''}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    final int bgInt = map['iconBg'] is int ? map['iconBg'] : 0xFFFFEDD5;
    final int colorInt = map['iconColor'] is int ? map['iconColor'] : 0xFFEA580C;
    final int codePoint = map['iconCodePoint'] is int ? map['iconCodePoint'] : Icons.edit_note_rounded.codePoint;

    List<Map<String, dynamic>>? parsedChecklist;
    if (map['checklist'] is List) {
      parsedChecklist = (map['checklist'] as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }

    return NoteItem(
      id: map['id'] ?? fallbackId,
      title: map['title'] ?? 'Untitled Note',
      subtitle: map['subtitle'] ?? '',
      content: map['content'] ?? '',
      createdAt: parseDate(map['createdAt']),
      iconBg: Color(bgInt),
      iconColor: Color(colorInt),
      icon: IconData(codePoint, fontFamily: 'MaterialIcons'),
      imageUrl: map['imageUrl'] as String?,
      audioUrl: map['audioUrl'] as String?,
      checklist: parsedChecklist,
      fontFamily: map['fontFamily'] as String? ?? 'Inter',
      fontSize: (map['fontSize'] as num?)?.toDouble() ?? 15.0,
      isBold: map['isBold'] as bool? ?? false,
      isItalic: map['isItalic'] as bool? ?? false,
      isUnderline: map['isUnderline'] as bool? ?? false,
      isPinned: map['isPinned'] as bool? ?? false,
      folderName: map['folderName'] as String?,
    );
  }

  NoteItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? content,
    DateTime? createdAt,
    Color? iconBg,
    Color? iconColor,
    IconData? icon,
    String? imageUrl,
    String? audioUrl,
    List<Map<String, dynamic>>? checklist,
    String? fontFamily,
    double? fontSize,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    bool? isPinned,
    String? folderName,
  }) {
    return NoteItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      iconBg: iconBg ?? this.iconBg,
      iconColor: iconColor ?? this.iconColor,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      checklist: checklist ?? this.checklist,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      isPinned: isPinned ?? this.isPinned,
      folderName: folderName ?? this.folderName,
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'children': children,
    };
  }

  factory MindMapNode.fromMap(Map<String, dynamic> map) {
    return MindMapNode(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      children: List<String>.from(map['children'] ?? []),
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sourceUrl': sourceUrl,
      'centralTopic': centralTopic,
      'branches': branches.map((b) => b.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MindMapItem.fromMap(Map<String, dynamic> map, {String fallbackId = ''}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    final rawBranches = map['branches'] as List<dynamic>? ?? [];
    final parsedBranches = rawBranches
        .whereType<Map<String, dynamic>>()
        .map((b) => MindMapNode.fromMap(b))
        .toList();

    return MindMapItem(
      id: map['id'] ?? fallbackId,
      title: map['title'] ?? 'Untitled Mind Map',
      sourceUrl: map['sourceUrl'] ?? '',
      centralTopic: map['centralTopic'] ?? '',
      branches: parsedBranches,
      createdAt: parseDate(map['createdAt']),
    );
  }
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'sourceUrl': sourceUrl,
      'sourceCategory': sourceCategory,
      'overview': overview,
      'bulletPoints': bulletPoints,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory SummaryItem.fromMap(Map<String, dynamic> map, {String fallbackId = ''}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return SummaryItem(
      id: map['id'] ?? fallbackId,
      title: map['title'] ?? 'Untitled Summary',
      sourceUrl: map['sourceUrl'] ?? '',
      sourceCategory: map['sourceCategory'] ?? 'General',
      overview: map['overview'] ?? '',
      bulletPoints: List<String>.from(map['bulletPoints'] ?? []),
      createdAt: parseDate(map['createdAt']),
    );
  }
}

class TaskItem {
  final String id;
  final String title;
  final String time;
  final Color color;
  final bool completed;
  final DateTime createdAt;
  final DateTime dueDate;
  final bool isPinned;
  final String? folderName;

  TaskItem({
    required this.id,
    required this.title,
    required this.time,
    required this.color,
    required this.completed,
    required this.createdAt,
    DateTime? dueDate,
    this.isPinned = false,
    this.folderName,
  }) : dueDate = dueDate ?? createdAt;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'colorInt': color.toARGB32(),
      'completed': completed,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'isPinned': isPinned,
      'folderName': folderName,
    };
  }

  factory TaskItem.fromMap(Map<String, dynamic> map, {String fallbackId = ''}) {
    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    final int colorInt = map['colorInt'] is int ? map['colorInt'] : 0xFF7C3AED;
    final created = parseDate(map['createdAt']);
    final due = map['dueDate'] != null ? parseDate(map['dueDate']) : created;

    return TaskItem(
      id: map['id'] ?? fallbackId,
      title: map['title'] ?? 'Untitled Task',
      time: map['time'] ?? 'Just now',
      color: Color(colorInt),
      completed: map['completed'] as bool? ?? false,
      createdAt: created,
      dueDate: due,
      isPinned: map['isPinned'] as bool? ?? false,
      folderName: map['folderName'] as String?,
    );
  }

  TaskItem copyWith({
    String? id,
    String? title,
    String? time,
    Color? color,
    bool? completed,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isPinned,
    String? folderName,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      color: color ?? this.color,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isPinned: isPinned ?? this.isPinned,
      folderName: folderName ?? this.folderName,
    );
  }
}

/// Central Repository for user notes, mind maps, summaries, and tasks
/// Automatically syncs with Cloud Firestore top-level collections.
class VaultRepository extends ChangeNotifier {
  static final VaultRepository instance = VaultRepository._internal();

  final FirestoreService _firestoreService = FirestoreService.instance;

  VaultRepository._internal() {
    _listenToFirestore();
  }

  final List<NoteItem> _notes = [];
  final List<MindMapItem> _mindMaps = [];
  final List<SummaryItem> _summaries = [];
  final List<TaskItem> _tasks = [];

  List<NoteItem> get notes => List.unmodifiable(_notes);
  List<MindMapItem> get mindMaps => List.unmodifiable(_mindMaps);
  List<SummaryItem> get summaries => List.unmodifiable(_summaries);
  List<TaskItem> get tasks => List.unmodifiable(_tasks);

  void _listenToFirestore() {
    // Listen to real-time updates from Cloud Firestore
    _firestoreService.streamNotes().listen((noteMaps) {
      _notes.clear();
      _notes.addAll(noteMaps.map((map) => NoteItem.fromMap(map)));
      notifyListeners();
    }, onError: (_) {});

    _firestoreService.streamMindMaps().listen((mindMapMaps) {
      _mindMaps.clear();
      _mindMaps.addAll(mindMapMaps.map((map) => MindMapItem.fromMap(map)));
      notifyListeners();
    }, onError: (_) {});

    _firestoreService.streamSummaries().listen((summaryMaps) {
      _summaries.clear();
      _summaries.addAll(summaryMaps.map((map) => SummaryItem.fromMap(map)));
      notifyListeners();
    }, onError: (_) {});

    _firestoreService.streamTasks().listen((taskMaps) {
      _tasks.clear();
      _tasks.addAll(taskMaps.map((map) => TaskItem.fromMap(map)));
      notifyListeners();
    }, onError: (_) {});
  }

  void addNote(NoteItem note) {
    final existingIndex = _notes.indexWhere((n) => n.id == note.id);
    if (existingIndex >= 0) {
      _notes[existingIndex] = note;
    } else {
      _notes.insert(0, note);
    }
    notifyListeners();
    // Persist to Cloud Firestore automatically
    _firestoreService.saveNote(note.toMap());
  }

  void toggleNotePin(String noteId) {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index >= 0) {
      final updated = _notes[index].copyWith(isPinned: !_notes[index].isPinned);
      addNote(updated);
    }
  }

  void moveNoteToFolder(String noteId, String? folderName) {
    final index = _notes.indexWhere((n) => n.id == noteId);
    if (index >= 0) {
      final updated = _notes[index].copyWith(folderName: folderName);
      addNote(updated);
    }
  }

  void addMindMap(MindMapItem mindMap) {
    _mindMaps.insert(0, mindMap);
    notifyListeners();
    // Persist to Cloud Firestore automatically
    _firestoreService.saveMindMap(mindMap.toMap());
  }

  void addSummary(SummaryItem summary) {
    _summaries.insert(0, summary);
    notifyListeners();
    // Persist to Cloud Firestore automatically
    _firestoreService.saveSummary(summary.toMap());
  }

  void saveTask(TaskItem task) {
    final existingIndex = _tasks.indexWhere((t) => t.id == task.id);
    if (existingIndex >= 0) {
      _tasks[existingIndex] = task;
    } else {
      _tasks.insert(0, task);
    }
    notifyListeners();
    _firestoreService.saveTask(task.toMap());
  }

  void toggleTaskPin(String taskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index >= 0) {
      final updated = _tasks[index].copyWith(isPinned: !_tasks[index].isPinned);
      saveTask(updated);
    }
  }

  void moveTaskToFolder(String taskId, String? folderName) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index >= 0) {
      final updated = _tasks[index].copyWith(folderName: folderName);
      saveTask(updated);
    }
  }

  void deleteNote(String noteId) {
    _notes.removeWhere((item) => item.id == noteId);
    notifyListeners();
    _firestoreService.deleteNote(noteId);
  }

  void deleteMindMap(String mindMapId) {
    _mindMaps.removeWhere((item) => item.id == mindMapId);
    notifyListeners();
    _firestoreService.deleteMindMap(mindMapId);
  }

  void deleteSummary(String summaryId) {
    _summaries.removeWhere((item) => item.id == summaryId);
    notifyListeners();
    _firestoreService.deleteSummary(summaryId);
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((item) => item.id == taskId);
    notifyListeners();
    _firestoreService.deleteTask(taskId);
  }
}

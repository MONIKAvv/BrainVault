import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Central Cloud Firestore service for BrainVault.
/// Manages top-level collections for notes, mindmaps, summaries, tasks, and reminders
/// so they show up directly in the Firebase Console.
class FirestoreService {
  static final FirestoreService instance = FirestoreService._internal();
  FirestoreService._internal() {
    _ensureAuth();
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _ensureAuth() async {
    if (_auth.currentUser == null) {
      try {
        await _auth.signInAnonymously();
        debugPrint('FirestoreService: Anonymous auth signed in successfully as ${_auth.currentUser?.uid}');
      } catch (e) {
        debugPrint('FirestoreService: Anonymous auth error: $e');
      }
    }
  }

  String get _currentUserId {
    return _auth.currentUser?.uid ?? 'guest_user';
  }

  // ---------------------------------------------------------------------------
  // NOTES COLLECTION: /notes
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _notesCollection {
    return _db.collection('notes');
  }

  Stream<List<Map<String, dynamic>>> streamNotes() {
    _ensureAuth();
    return _notesCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveNote(Map<String, dynamic> noteData) async {
    try {
      await _ensureAuth();
      final String docId = noteData['id'] ?? _notesCollection.doc().id;
      final dataToSave = Map<String, dynamic>.from(noteData);
      dataToSave['id'] = docId;
      dataToSave['userId'] = _currentUserId;
      if (!dataToSave.containsKey('createdAt') || dataToSave['createdAt'] == null) {
        dataToSave['createdAt'] = FieldValue.serverTimestamp();
      }
      dataToSave['updatedAt'] = FieldValue.serverTimestamp();

      await _notesCollection.doc(docId).set(dataToSave, SetOptions(merge: true));
      debugPrint('FirestoreService: Note $docId saved successfully to /notes collection!');
    } catch (e) {
      debugPrint('FirestoreService Error saving note to Cloud Firestore: $e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _ensureAuth();
      await _notesCollection.doc(noteId).delete();
      debugPrint('FirestoreService: Note $noteId deleted from /notes collection!');
    } catch (e) {
      debugPrint('FirestoreService Error deleting note: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // MIND MAPS COLLECTION: /mindmaps
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _mindMapsCollection {
    return _db.collection('mindmaps');
  }

  Stream<List<Map<String, dynamic>>> streamMindMaps() {
    _ensureAuth();
    return _mindMapsCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveMindMap(Map<String, dynamic> mindMapData) async {
    try {
      await _ensureAuth();
      final String docId = mindMapData['id'] ?? _mindMapsCollection.doc().id;
      final dataToSave = Map<String, dynamic>.from(mindMapData);
      dataToSave['id'] = docId;
      dataToSave['userId'] = _currentUserId;
      if (!dataToSave.containsKey('createdAt') || dataToSave['createdAt'] == null) {
        dataToSave['createdAt'] = FieldValue.serverTimestamp();
      }
      dataToSave['updatedAt'] = FieldValue.serverTimestamp();

      await _mindMapsCollection.doc(docId).set(dataToSave, SetOptions(merge: true));
      debugPrint('FirestoreService: MindMap $docId saved successfully to /mindmaps collection!');
    } catch (e) {
      debugPrint('FirestoreService Error saving mindmap: $e');
    }
  }

  Future<void> deleteMindMap(String mindMapId) async {
    try {
      await _ensureAuth();
      await _mindMapsCollection.doc(mindMapId).delete();
    } catch (e) {
      debugPrint('FirestoreService Error deleting mindmap: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // SUMMARIES COLLECTION: /summaries
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _summariesCollection {
    return _db.collection('summaries');
  }

  Stream<List<Map<String, dynamic>>> streamSummaries() {
    _ensureAuth();
    return _summariesCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveSummary(Map<String, dynamic> summaryData) async {
    try {
      await _ensureAuth();
      final String docId = summaryData['id'] ?? _summariesCollection.doc().id;
      final dataToSave = Map<String, dynamic>.from(summaryData);
      dataToSave['id'] = docId;
      dataToSave['userId'] = _currentUserId;
      if (!dataToSave.containsKey('createdAt') || dataToSave['createdAt'] == null) {
        dataToSave['createdAt'] = FieldValue.serverTimestamp();
      }
      dataToSave['updatedAt'] = FieldValue.serverTimestamp();

      await _summariesCollection.doc(docId).set(dataToSave, SetOptions(merge: true));
      debugPrint('FirestoreService: Summary $docId saved successfully to /summaries collection!');
    } catch (e) {
      debugPrint('FirestoreService Error saving summary: $e');
    }
  }

  Future<void> deleteSummary(String summaryId) async {
    try {
      await _ensureAuth();
      await _summariesCollection.doc(summaryId).delete();
    } catch (e) {
      debugPrint('FirestoreService Error deleting summary: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // TASKS COLLECTION: /tasks
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _tasksCollection {
    return _db.collection('tasks');
  }

  Stream<List<Map<String, dynamic>>> streamTasks() {
    _ensureAuth();
    return _tasksCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveTask(Map<String, dynamic> taskData) async {
    try {
      await _ensureAuth();
      final String docId = taskData['id'] ?? _tasksCollection.doc().id;
      final dataToSave = Map<String, dynamic>.from(taskData);
      dataToSave['id'] = docId;
      dataToSave['userId'] = _currentUserId;
      if (!dataToSave.containsKey('createdAt') || dataToSave['createdAt'] == null) {
        dataToSave['createdAt'] = FieldValue.serverTimestamp();
      }
      dataToSave['updatedAt'] = FieldValue.serverTimestamp();

      await _tasksCollection.doc(docId).set(dataToSave, SetOptions(merge: true));
      debugPrint('FirestoreService: Task $docId saved successfully to /tasks collection!');
    } catch (e) {
      debugPrint('FirestoreService Error saving task: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _ensureAuth();
      await _tasksCollection.doc(taskId).delete();
    } catch (e) {
      debugPrint('FirestoreService Error deleting task: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // REMINDERS COLLECTION: /reminders
  // ---------------------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> get _remindersCollection {
    return _db.collection('reminders');
  }

  Stream<List<Map<String, dynamic>>> streamReminders() {
    _ensureAuth();
    return _remindersCollection
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> saveReminder(Map<String, dynamic> reminderData) async {
    try {
      await _ensureAuth();
      final String docId = reminderData['id'] ?? _remindersCollection.doc().id;
      final dataToSave = Map<String, dynamic>.from(reminderData);
      dataToSave['id'] = docId;
      dataToSave['userId'] = _currentUserId;
      dataToSave['updatedAt'] = FieldValue.serverTimestamp();

      await _remindersCollection.doc(docId).set(dataToSave, SetOptions(merge: true));
      debugPrint('FirestoreService: Reminder $docId saved successfully to /reminders collection!');
    } catch (e) {
      debugPrint('FirestoreService Error saving reminder: $e');
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    try {
      await _ensureAuth();
      await _remindersCollection.doc(reminderId).delete();
    } catch (e) {
      debugPrint('FirestoreService Error deleting reminder: $e');
    }
  }
}

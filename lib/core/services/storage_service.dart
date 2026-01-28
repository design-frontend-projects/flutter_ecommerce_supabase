import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

/// Local storage service using GetStorage
class StorageService extends GetxService {
  late final GetStorage _storage;

  /// Initialize GetStorage
  Future<StorageService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }

  /// Write a value to storage
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Read a value from storage
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Remove a value from storage
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// Clear all storage
  Future<void> clear() async {
    await _storage.erase();
  }

  /// Check if key exists
  bool hasKey(String key) {
    return _storage.hasData(key);
  }

  /// Write a JSON-serializable object
  Future<void> writeJson(String key, Map<String, dynamic> value) async {
    await _storage.write(key, jsonEncode(value));
  }

  /// Read a JSON object
  Map<String, dynamic>? readJson(String key) {
    final value = _storage.read<String>(key);
    if (value == null) return null;
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Write a list of JSON objects
  Future<void> writeJsonList(
    String key,
    List<Map<String, dynamic>> value,
  ) async {
    await _storage.write(key, jsonEncode(value));
  }

  /// Read a list of JSON objects
  List<Map<String, dynamic>>? readJsonList(String key) {
    final value = _storage.read<String>(key);
    if (value == null) return null;
    try {
      final list = jsonDecode(value) as List;
      return list.map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      return null;
    }
  }

  /// Listen to key changes
  void listenKey(String key, void Function(dynamic) callback) {
    _storage.listenKey(key, callback);
  }
}

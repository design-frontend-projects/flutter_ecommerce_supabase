import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Object>?> getTable(String tableName) async {
    final response = await _client.from(tableName).select();
    if (response.isEmpty) {
      // In a real app, handle error appropriately
      return null;
    }
    return response;
  }

  Future<bool> insert(String tableName, Map<String, Object> values) async {
    final response = await _client.from(tableName).insert(values);
    return response.isEmpty;
  }

  Future<bool> delete(String tableName, Map<String, Object> match) async {
    final response = await _client.from(tableName).delete().match(match);
    return response.isEmpty;
  }

  Future<bool> upsert(String tableName, Map<String, Object> values) async {
    final response = await _client.from(tableName).upsert(values);
    return response.isEmpty;
  }
}

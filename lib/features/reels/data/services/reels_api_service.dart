import 'package:customdropdown/features/reels/data/models/reels_response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ReelsApiService {
  ReelsApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://petzy-server.fly.dev/api/v1';
  final http.Client _client;

  Future<ReelsResponse> fetchReels({
    required int limit,
    String? cursor,
  }) async {
    final uri = Uri.parse('$_baseUrl/reel').replace(
      queryParameters: <String, String>{
        'limit': '$limit',
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load reels: ${response.statusCode}');
    }

    return compute(parseReelsResponse, response.body);
  }
}

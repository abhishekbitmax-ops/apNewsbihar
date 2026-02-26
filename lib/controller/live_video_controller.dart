import 'dart:convert';
import 'dart:io';

import 'package:ap_news/Utils/api_endpoints.dart';
import 'package:ap_news/model/Recent_video.dart';
import 'package:ap_news/model/news_model.dart';

class LiveVideoController {
  static Future<VideoApiResponse> fetchYoutubeLive() async {
    final uri = Uri.parse(ApiEndpoint.getUrl(ApiEndpoint.youtubelive));
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map<String, dynamic>) {
          return VideoApiResponse.fromJson(decoded);
        }
        throw const FormatException('Unexpected API response format');
      }

      throw HttpException(
        'Failed to fetch live video. Status code: ${response.statusCode}',
        uri: uri,
      );
    } finally {
      client.close(force: true);
    }
  }

  static Future<PlaylistResponse> fetchRecentVideos() async {
    final uri = Uri.parse(ApiEndpoint.getUrl(ApiEndpoint.recentvideo));
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map<String, dynamic>) {
          return PlaylistResponse.fromJson(decoded);
        }
        throw const FormatException('Unexpected API response format');
      }

      throw HttpException(
        'Failed to fetch recent videos. Status code: ${response.statusCode}',
        uri: uri,
      );
    } finally {
      client.close(force: true);
    }
  }

  static Future<ArticlesResponse> fetchBusinessCategoryArticles() {
    return _fetchCategoryArticles(ApiEndpoint.businessCategory);
  }

  static Future<ArticlesResponse> fetchBhojpuriCategoryArticles() {
    return _fetchCategoryArticles(ApiEndpoint.bhojpuriCategory);
  }

  static Future<ArticlesResponse> fetchTechnologyCategoryArticles() {
    return _fetchCategoryArticles(ApiEndpoint.technologyCategory);
  }

  static Future<ArticlesResponse> fetchSportsCategoryArticles() {
    return _fetchCategoryArticles(ApiEndpoint.sportsCategory);
  }

  static Future<ArticlesResponse> fetchElectionCategoryArticles() {
    return _fetchCategoryArticles(ApiEndpoint.electionCategory);
  }

  static Future<ArticlesResponse> _fetchCategoryArticles(
    String endpoint,
  ) async {
    final uri = Uri.parse(ApiEndpoint.getUrl(endpoint));
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map<String, dynamic>) {
          return ArticlesResponse.fromJson(decoded);
        }
        throw const FormatException('Unexpected API response format');
      }

      throw HttpException(
        'Failed to fetch category articles. Status code: ${response.statusCode}',
        uri: uri,
      );
    } finally {
      client.close(force: true);
    }
  }

  static Future<NewsResponse> fetchTrendingNews() async {
    final uri = Uri.parse(ApiEndpoint.getUrl(ApiEndpoint.allArticlesPageOne));
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20);

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(responseBody);
        if (decoded is Map<String, dynamic>) {
          return NewsResponse.fromJson(decoded);
        }
        throw const FormatException('Unexpected API response format');
      }

      throw HttpException(
        'Failed to fetch trending news. Status code: ${response.statusCode}',
        uri: uri,
      );
    } finally {
      client.close(force: true);
    }
  }
}

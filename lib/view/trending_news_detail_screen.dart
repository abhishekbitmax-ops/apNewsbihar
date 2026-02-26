import 'package:ap_news/model/news_model.dart';
import 'package:flutter/material.dart';

class TrendingNewsDetailScreen extends StatelessWidget {
  const TrendingNewsDetailScreen({super.key, required this.news});

  final NewsItem news;

  String _title() {
    final en = news.title?.en?.trim();
    if (en != null && en.isNotEmpty) return en;
    final hi = news.title?.hi?.trim();
    if (hi != null && hi.isNotEmpty) return hi;
    return 'News Detail';
  }

  String _summary() {
    final en = news.summary?.en?.trim();
    if (en != null && en.isNotEmpty) return en;
    final hi = news.summary?.hi?.trim();
    if (hi != null && hi.isNotEmpty) return hi;
    return '';
  }

  String _content() {
    final en = news.content?.en?.trim();
    if (en != null && en.isNotEmpty) return en;
    final hi = news.content?.hi?.trim();
    if (hi != null && hi.isNotEmpty) return hi;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary();
    final content = _content();
    final imageUrl = news.featuredImage?.url;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA0000),
        foregroundColor: Colors.white,
        title: const Text('Trending News'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _title(),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
              if (imageUrl != null && imageUrl.trim().isNotEmpty) ...[
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 210,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              if (summary.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'Summary',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
              if (content.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'Content',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
              if (summary.isEmpty && content.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                    'Summary and content are not available.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

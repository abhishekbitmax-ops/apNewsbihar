import 'package:ap_news/model/Recent_video.dart';
import 'package:flutter/material.dart';

class CategoryArticleDetailScreen extends StatelessWidget {
  const CategoryArticleDetailScreen({super.key, required this.article});

  final Article article;

  String _title() {
    final en = article.title?.en?.trim();
    if (en != null && en.isNotEmpty) return en;
    final hi = article.title?.hi?.trim();
    if (hi != null && hi.isNotEmpty) return hi;
    return 'Article';
  }

  String _summaryEn() {
    return article.summary?.en?.trim() ?? '';
  }

  String _summaryHi() {
    return article.summary?.hi?.trim() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final summaryEn = _summaryEn();
    final summaryHi = _summaryHi();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEA0000),
        foregroundColor: Colors.white,
        title: const Text('News Summary'),
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
              const SizedBox(height: 12),
              if (article.featuredImage?.url != null &&
                  article.featuredImage!.url!.trim().isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    article.featuredImage!.url!,
                    width: double.infinity,
                    height: 210,
                    fit: BoxFit.cover,
                  ),
                ),
              if (summaryEn.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'Summary (EN)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  summaryEn,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
              if (summaryHi.isNotEmpty) ...[
                const SizedBox(height: 18),
                const Text(
                  'Summary (HI)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  summaryHi,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
              if (summaryEn.isEmpty && summaryHi.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                    'Summary is not available for this article.',
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

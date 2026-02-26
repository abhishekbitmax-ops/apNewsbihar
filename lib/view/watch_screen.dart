import 'package:ap_news/controller/live_video_controller.dart';
import 'package:ap_news/model/Recent_video.dart';
import 'package:flutter/material.dart';

class WatchScreen extends StatefulWidget {
  const WatchScreen({super.key});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late Future<PlaylistResponse> _recentVideosFuture;

  @override
  void initState() {
    super.initState();
    _recentVideosFuture = LiveVideoController.fetchRecentVideos();
  }

  void _retryFetch() {
    setState(() {
      _recentVideosFuture = LiveVideoController.fetchRecentVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFEA0000),
        foregroundColor: Colors.white,
        titleSpacing: 0,
        title: const Row(
          children: [
            Icon(Icons.videocam_rounded, size: 22),
            SizedBox(width: 8),
            Text(
              'WATCH',
              style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: FutureBuilder<PlaylistResponse>(
          future: _recentVideosFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Failed to load videos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _retryFetch,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final items = snapshot.data?.items ?? <PlaylistItem>[];
            final liveItem = items.isNotEmpty ? items.first : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LiveVideoCard(item: liveItem),
                  const SizedBox(height: 18),
                  _RecentVideosSection(items: items),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LiveVideoCard extends StatelessWidget {
  const _LiveVideoCard({required this.item});

  final PlaylistItem? item;

  String _title() {
    final raw = item?.snippet?.title?.trim();
    if (raw == null || raw.isEmpty) {
      return 'Latest AP News Video';
    }
    return raw;
  }

  String _channel() {
    final raw = item?.snippet?.channelTitle?.trim();
    if (raw == null || raw.isEmpty) {
      return 'AP NEWS BIHAR';
    }
    return raw;
  }

  String? _thumbnail() {
    final thumbs = item?.snippet?.thumbnails;
    return thumbs?.maxres?.url ??
        thumbs?.standard?.url ??
        thumbs?.high?.url ??
        thumbs?.medium?.url ??
        thumbs?.defaultThumb?.url;
  }

  @override
  Widget build(BuildContext context) {
    final thumbUrl = _thumbnail();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (thumbUrl != null)
                Image.network(
                  thumbUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _fallbackBanner(),
                )
              else
                _fallbackBanner(),
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x20000000), Color(0xA0000000)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: const Color(0xFFD40000),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Text(
                    _title(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 34,
                  backgroundColor: Color(0x66FFFFFF),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 44,
                child: Container(
                  color: const Color(0xFFF1D20A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: const Text(
                    'BREAKING NEWS',
                    style: TextStyle(
                      color: Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: const Color(0xFFC20000),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Text(
                    _channel(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fallbackBanner() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF49535F), Color(0xFF1F252B)],
        ),
      ),
    );
  }
}

class _RecentVideosSection extends StatelessWidget {
  const _RecentVideosSection({required this.items});

  final List<PlaylistItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.play_arrow_rounded, color: Color(0xFFD60000)),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    'Recent Videos',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    '${items.length} Videos',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 4),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'No recent videos found.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _RecentVideoRow(item: items[index], index: index);
                },
              ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4B5563),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFD7D7D7)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'View All Archives',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentVideoRow extends StatelessWidget {
  const _RecentVideoRow({required this.item, required this.index});

  final PlaylistItem item;
  final int index;

  String? _thumbnail() {
    final thumbs = item.snippet?.thumbnails;
    return thumbs?.high?.url ??
        thumbs?.medium?.url ??
        thumbs?.defaultThumb?.url ??
        thumbs?.standard?.url ??
        thumbs?.maxres?.url;
  }

  String _title() {
    final raw = item.snippet?.title?.trim();
    if (raw == null || raw.isEmpty) return 'Untitled video';
    return raw;
  }

  String _publishedDate() {
    final value = item.snippet?.publishedAt;
    if (value == null || value.isEmpty) return 'Unknown date';

    final parsed = DateTime.tryParse(value);
    if (parsed == null) return 'Unknown date';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[parsed.month - 1]} ${parsed.day}, ${parsed.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF8A1C1C),
      const Color(0xFF234D7A),
      const Color(0xFF2C5A40),
      const Color(0xFF6C4A20),
    ];
    final thumbUrl = _thumbnail();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: index == 0 ? const Color(0xFFF8EAEA) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE4E4E4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 130,
              height: 74,
              child: thumbUrl == null
                  ? Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colors[index % colors.length],
                            const Color(0xFF1E1E1E),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    )
                  : Image.network(
                      thumbUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              colors[index % colors.length],
                              const Color(0xFF1E1E1E),
                            ],
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _title(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _publishedDate(),
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

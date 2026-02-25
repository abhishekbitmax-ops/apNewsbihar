import 'package:flutter/material.dart';

class NewsShortsScreen extends StatelessWidget {
  const NewsShortsScreen({super.key});

  static const List<_ShortItem> _shorts = [
    _ShortItem(
      title: 'Cabinet big decision in 30 seconds',
      category: 'Politics',
      duration: '0:30',
    ),
    _ShortItem(
      title: 'Market opens with strong gains',
      category: 'Business',
      duration: '0:24',
    ),
    _ShortItem(
      title: 'Rain alert in 8 states today',
      category: 'Weather',
      duration: '0:27',
    ),
    _ShortItem(
      title: 'Team India net session highlights',
      category: 'Sports',
      duration: '0:33',
    ),
    _ShortItem(
      title: 'Film trailer breaks online records',
      category: 'Entertainment',
      duration: '0:21',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        title: const Text(
          'News Shorts',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          itemCount: _shorts.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            return _ShortCard(item: _shorts[index], index: index);
          },
        ),
      ),
    );
  }
}

class _ShortCard extends StatelessWidget {
  const _ShortCard({required this.item, required this.index});

  final _ShortItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final palette = [
      const Color(0xFF1D4ED8),
      const Color(0xFFB91C1C),
      const Color(0xFF047857),
      const Color(0xFF7C3AED),
      const Color(0xFFC2410C),
    ];

    final color = palette[index % palette.length];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, const Color(0xFF111827)],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC000000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.category.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0x66FFFFFF),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 14,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC000000),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortItem {
  const _ShortItem({
    required this.title,
    required this.category,
    required this.duration,
  });

  final String title;
  final String category;
  final String duration;
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  int _selectedCategoryIndex = 0;
  bool _isMenuOpen = false;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  static const List<String> _categories = [
    'Home',
    'Cricket',
    'India',
    'Entertainment',
    'Sports',
  ];

  static const List<_ArticleItem> _categoryArticles = [
    _ArticleItem(title: 'Africa Super 8 Opener'),
    _ArticleItem(
      title:
          'T20 World Cup 2026: Updated Super 8s Points Table After South Africa Outclass India',
    ),
    _ArticleItem(
      title:
          'IND vs SA Highlights T20 WC: India Stunned As South Africa Secure Big 76-Run Triumph',
    ),
    _ArticleItem(
      title: 'IPL 2026 Shocker? MS Dhoni May Not Play Every Match For CSK',
    ),
    _ArticleItem(
      title:
          'BCB Bans Monjurul Islam Over Sexual Assault Allegations From 2022 World Cup',
    ),
    _ArticleItem(
      title:
          'IND vs SA Super 8: What Is A Comfortable Score For India To Chase At Ahmedabad?',
    ),
    _ArticleItem(
      title:
          'T20 World Cup 2026 Points Table: Updated Standings After England Vs Sri Lanka',
    ),
  ];

  void _handleHorizontalSwipe(DragEndDetails details) {
    final velocityX = details.primaryVelocity ?? 0;
    if (velocityX.abs() < 250) return;

    final movingRight = velocityX > 0;
    final nextIndex = movingRight
        ? _selectedCategoryIndex - 1
        : _selectedCategoryIndex + 1;

    if (nextIndex < 0 || nextIndex >= _categories.length) return;
    setState(() {
      _selectedCategoryIndex = nextIndex;
    });
  }

  Widget _buildCategoryContent() {
    if (_selectedCategoryIndex == 0) {
      return const _HomeTabContent(key: ValueKey('home_tab'));
    }

    return KeyedSubtree(
      key: ValueKey('news_tab_$_selectedCategoryIndex'),
      child: _CategoryNewsList(
        articles: _categoryArticles,
        categoryName: _categories[_selectedCategoryIndex],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final panelWidth = MediaQuery.of(context).size.width * 0.92;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFEA0000),
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopHeader(
                    onMenuTap: () {
                      setState(() {
                        _isMenuOpen = true;
                      });
                    },
                  ),
                  _CategoryBar(
                    categories: _categories,
                    selectedIndex: _selectedCategoryIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragEnd: _handleHorizontalSwipe,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: _buildCategoryContent(),
                    ),
                  ),
                ],
              ),
            ),
            if (_isMenuOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMenuOpen = false;
                    });
                  },
                  child: Container(color: const Color(0x22000000)),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              top: 0,
              bottom: 0,
              left: _isMenuOpen ? 0 : -panelWidth,
              child: _SideMenuPanel(
                width: panelWidth,
                darkModeEnabled: _darkModeEnabled,
                selectedLanguage: _selectedLanguage,
                onDarkModeChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
                onLanguageChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                onClose: () {
                  setState(() {
                    _isMenuOpen = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFEA0000), Color(0xFFD10000)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 44, 14, 16),
      child: Row(
        children: [
          _HeaderIconButton(icon: Icons.menu, onTap: onMenuTap),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.change_history_rounded,
                    color: Color(0xFFEA0000),
                    size: 22,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ap news',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFEA0000),
                    ),
                  ),
                  SizedBox(width: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFF111111)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          const _HeaderIconButton(icon: Icons.search_rounded),
          const SizedBox(width: 8),
          const _HeaderIconButton(icon: Icons.person_outline_rounded),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x26FFFFFF),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

class _HomeTabContent extends StatelessWidget {
  const _HomeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'LIVE TV',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _LiveTvCard(),
        ),
        SizedBox(height: 18),
        Center(
          child: Text(
            'ADVERTISEMENT',
            style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 14),
          ),
        ),
        SizedBox(height: 22),
        _TrendingNewsSection(),
        SizedBox(height: 18),
        _LatestContentSection(),
        SizedBox(height: 12),
        SizedBox(height: 180),
      ],
    );
  }
}

class _SideMenuPanel extends StatelessWidget {
  const _SideMenuPanel({
    required this.width,
    required this.darkModeEnabled,
    required this.selectedLanguage,
    required this.onDarkModeChanged,
    required this.onLanguageChanged,
    required this.onClose,
  });

  final double width;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final ValueChanged<bool> onDarkModeChanged;
  final ValueChanged<String?> onLanguageChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F5F5),
      child: SizedBox(
        width: width,
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 18,
                  right: 18,
                  left: 18,
                  bottom: 8,
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onClose,
                    child: const Icon(
                      Icons.close,
                      color: Color(0xFFC33D45),
                      size: 28,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Choose your language',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF9B9B9B)),
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xFFF5F5F5),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedLanguage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF252525),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF7A7A7A),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'English',
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: 'Hindi',
                              child: Text('Hindi'),
                            ),
                          ],
                          onChanged: onLanguageChanged,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Switch(
                      value: darkModeEnabled,
                      onChanged: onDarkModeChanged,
                      activeThumbColor: const Color(0xFFEA0000),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(height: 1),
              const _MenuRow(title: 'Business'),
              const Divider(height: 1),
              const _MenuRow(title: 'Top Categories'),
              const Divider(height: 1),
              const _MenuRow(title: 'Other Categories'),
              const Divider(height: 1),
              const _MenuRow(title: 'Information and FAQ'),
              const Divider(height: 1),
              const _MenuRow(title: 'Rate App', hasChevron: false),
              const SizedBox(height: 180),
              const Padding(
                padding: EdgeInsets.only(bottom: 26),
                child: Center(
                  child: Text(
                    'Version: 13.8.10',
                    style: TextStyle(
                      color: Color(0xFF3E948D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.title, this.hasChevron = true});

  final String title;
  final bool hasChevron;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (hasChevron)
              const Icon(
                Icons.keyboard_arrow_down,
                size: 26,
                color: Color(0xFF222222),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({
    required this.categories,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final selected = index == selectedIndex;
          return InkWell(
            onTap: () => onTap(index),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                border: selected
                    ? const Border(
                        bottom: BorderSide(color: Colors.black, width: 4),
                      )
                    : null,
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: selected ? Colors.black : const Color(0xFF9A9A9A),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryNewsList extends StatelessWidget {
  const _CategoryNewsList({required this.articles, required this.categoryName});

  final List<_ArticleItem> articles;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: articles.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
      itemBuilder: (context, index) {
        final article = articles[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  article.title,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _ArticleThumb(index: index, categoryName: categoryName),
            ],
          ),
        );
      },
    );
  }
}

class _ArticleThumb extends StatelessWidget {
  const _ArticleThumb({required this.index, required this.categoryName});

  final int index;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF678D6D),
      const Color(0xFF2D5EA8),
      const Color(0xFF1D3A66),
      const Color(0xFF6A8A4A),
      const Color(0xFF426EA4),
      const Color(0xFF3A6A8F),
      const Color(0xFF9A3737),
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 182,
        height: 102,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors[index % colors.length], const Color(0xFF1E1E1E)],
          ),
        ),
        child: Center(
          child: Text(
            categoryName.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveTvCard extends StatelessWidget {
  const _LiveTvCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF3C3C3C), Color(0xFF1D1D1D)],
                    ),
                  ),
                ),
                const Positioned(
                  top: 12,
                  left: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFFD70000)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'BREAKING NEWS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0x66FFFFFF),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 52,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: const [
                CircleAvatar(radius: 8, backgroundColor: Color(0xFFEB4350)),
                SizedBox(width: 12),
                Text(
                  'Live TV',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                Icon(Icons.open_in_full, size: 23),
                SizedBox(width: 12),
                Icon(Icons.volume_off_rounded, size: 23),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingNewsSection extends StatelessWidget {
  const _TrendingNewsSection();

  static const List<_TrendingItem> _items = [
    _TrendingItem(
      title: 'Parliament Live: Major Policy Discussion Continues In Lok Sabha',
      category: 'Politics',
    ),
    _TrendingItem(
      title: 'Sensex Jumps 500 Points As Banking Stocks Lead The Rally',
      category: 'Business',
    ),
    _TrendingItem(
      title: 'Weather Alert: Heavy Rainfall Warning Issued For 6 States',
      category: 'India',
    ),
    _TrendingItem(
      title: 'India Squad Update Ahead Of High-Pressure T20 Clash',
      category: 'Sports',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'TRENDING NEWS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _items.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFE8E8E8)),
          itemBuilder: (context, index) {
            final item = _items[index];
            return _TrendingNewsRow(item: item, index: index);
          },
        ),
      ],
    );
  }
}

class _TrendingNewsRow extends StatelessWidget {
  const _TrendingNewsRow({required this.item, required this.index});

  final _TrendingItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final badgeColors = [
      const Color(0xFFEA0000),
      const Color(0xFF1D4F8E),
      const Color(0xFF2F6B44),
      const Color(0xFF6B4A1F),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: badgeColors[index % badgeColors.length],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.category,
                  style: const TextStyle(
                    color: Color(0xFF7A7A7A),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
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

class _LatestContentSection extends StatelessWidget {
  const _LatestContentSection();

  static const List<_LatestItem> _items = [
    _LatestItem(
      title: 'Latest Video: Election Ground Report And Live Updates',
      label: 'Video',
    ),
    _LatestItem(
      title: 'Breaking News: Market Opens Higher In Early Trade',
      label: 'News',
    ),
    _LatestItem(
      title: 'Sports Update: Team India Practice Session Highlights',
      label: 'Video',
    ),
    _LatestItem(
      title: 'Entertainment Buzz: New Film Trailer Out Now',
      label: 'News',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'LATEST VIDEOS / NEWS',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = _items[index];
              return _LatestCard(item: item, index: index);
            },
          ),
        ),
      ],
    );
  }
}

class _LatestCard extends StatelessWidget {
  const _LatestCard({required this.item, required this.index});

  final _LatestItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final thumbColors = [
      const Color(0xFF235EA7),
      const Color(0xFF8E2C2C),
      const Color(0xFF2E6C4A),
      const Color(0xFF6F4E24),
    ];
    final color = thumbColors[index % thumbColors.length];

    return SizedBox(
      width: 250,
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, const Color(0xFF1E1E1E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      item.label == 'Video'
                          ? Icons.play_circle_fill_rounded
                          : Icons.newspaper_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.label == 'Video'
                      ? const Color(0xFFEA0000)
                      : const Color(0xFF3B3B3B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleItem {
  const _ArticleItem({required this.title});

  final String title;
}

class _LatestItem {
  const _LatestItem({required this.title, required this.label});

  final String title;
  final String label;
}

class _TrendingItem {
  const _TrendingItem({required this.title, required this.category});

  final String title;
  final String category;
}

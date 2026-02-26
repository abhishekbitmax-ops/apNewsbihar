import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ap_news/controller/live_video_controller.dart';
import 'package:ap_news/model/Recent_video.dart';
import 'package:ap_news/model/news_model.dart';
import 'package:ap_news/view/category_article_detail_screen.dart';
import 'package:ap_news/view/profile_screen.dart';
import 'package:ap_news/view/trending_news_detail_screen.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
  final ScrollController _contentScrollController = ScrollController();
  late Future<VideoApiResponse> _liveVideoFuture;
  late Future<NewsResponse> _trendingNewsFuture;
  final Map<int, Future<ArticlesResponse>> _categoryArticlesFutures = {};

  static const List<String> _categories = [
    'Home',
    'Bussiness',
    'Bhojpuri',
    'Technology',
    'Sports',
    'Election',
  ];

  @override
  void initState() {
    super.initState();
    _liveVideoFuture = LiveVideoController.fetchYoutubeLive();
    _trendingNewsFuture = LiveVideoController.fetchTrendingNews();
  }

  void _retryLiveVideo() {
    setState(() {
      _liveVideoFuture = LiveVideoController.fetchYoutubeLive();
    });
  }

  void _retryTrendingNews() {
    setState(() {
      _trendingNewsFuture = LiveVideoController.fetchTrendingNews();
    });
  }

  Future<ArticlesResponse> _loadCategoryArticles(int index) {
    switch (index) {
      case 1:
        return LiveVideoController.fetchBusinessCategoryArticles();
      case 2:
        return LiveVideoController.fetchBhojpuriCategoryArticles();
      case 3:
        return LiveVideoController.fetchTechnologyCategoryArticles();
      case 4:
        return LiveVideoController.fetchSportsCategoryArticles();
      case 5:
        return LiveVideoController.fetchElectionCategoryArticles();
      default:
        return Future.value(ArticlesResponse(success: true, articles: []));
    }
  }

  Future<ArticlesResponse> _getCategoryFutureByIndex(int index) {
    return _categoryArticlesFutures.putIfAbsent(
      index,
      () => _loadCategoryArticles(index),
    );
  }

  void _retryCategoryArticles(int index) {
    setState(() {
      _categoryArticlesFutures[index] = _loadCategoryArticles(index);
    });
  }

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
      return _HomeTabContent(
        key: const ValueKey('home_tab'),
        liveVideoFuture: _liveVideoFuture,
        onRetry: _retryLiveVideo,
        trendingNewsFuture: _trendingNewsFuture,
        onTrendingRetry: _retryTrendingNews,
      );
    }

    return KeyedSubtree(
      key: ValueKey('news_tab_$_selectedCategoryIndex'),
      child: _CategoryNewsList(
        articlesFuture: _getCategoryFutureByIndex(_selectedCategoryIndex),
        onRetry: () => _retryCategoryArticles(_selectedCategoryIndex),
        categoryName: _categories[_selectedCategoryIndex],
      ),
    );
  }

  @override
  void dispose() {
    _contentScrollController.dispose();
    super.dispose();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopHeader(
                  onMenuTap: () {
                    setState(() {
                      _isMenuOpen = true;
                    });
                  },
                  onProfileTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
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
                Expanded(
                  child: Scrollbar(
                    controller: _contentScrollController,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _contentScrollController,
                      child: GestureDetector(
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
                    ),
                  ),
                ),
              ],
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
  const _TopHeader({required this.onMenuTap, required this.onProfileTap});

  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

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
          _HeaderIconButton(
            icon: Icons.person_outline_rounded,
            onTap: onProfileTap,
          ),
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
  const _HomeTabContent({
    super.key,
    required this.liveVideoFuture,
    required this.onRetry,
    required this.trendingNewsFuture,
    required this.onTrendingRetry,
  });

  final Future<VideoApiResponse> liveVideoFuture;
  final VoidCallback onRetry;
  final Future<NewsResponse> trendingNewsFuture;
  final VoidCallback onTrendingRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
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
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _LiveTvCard(
            liveVideoFuture: liveVideoFuture,
            onRetry: onRetry,
          ),
        ),
        const SizedBox(height: 18),
        const Center(
          child: Text(
            'ADVERTISEMENT',
            style: TextStyle(color: Color(0xFF9A9A9A), fontSize: 14),
          ),
        ),
        const SizedBox(height: 22),
        _TrendingNewsSection(
          trendingNewsFuture: trendingNewsFuture,
          onRetry: onTrendingRetry,
        ),
        const SizedBox(height: 18),
        const _LatestContentSection(),
        const SizedBox(height: 12),
        const SizedBox(height: 180),
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
  const _CategoryNewsList({
    required this.articlesFuture,
    required this.onRetry,
    required this.categoryName,
  });

  final Future<ArticlesResponse> articlesFuture;
  final VoidCallback onRetry;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArticlesResponse>(
      future: articlesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 28),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          );
        }

        final articles = snapshot.data?.articles ?? <Article>[];
        if (articles.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Text(
              'No articles found.',
              style: TextStyle(fontSize: 15, color: Color(0xFF6B7280)),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Color(0xFFE6E6E6)),
          itemBuilder: (context, index) {
            final article = articles[index];
            final title =
                article.title?.en?.trim().isNotEmpty == true
                ? article.title!.en!.trim()
                : article.title?.hi?.trim().isNotEmpty == true
                ? article.title!.hi!.trim()
                : 'Untitled';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryArticleDetailScreen(article: article),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.25,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _ArticleThumb(
                        index: index,
                        categoryName: categoryName,
                        imageUrl: article.featuredImage?.url,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ArticleThumb extends StatelessWidget {
  const _ArticleThumb({
    required this.index,
    required this.categoryName,
    this.imageUrl,
  });

  final int index;
  final String categoryName;
  final String? imageUrl;

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
      child: SizedBox(
        width: 182,
        height: 102,
        child: imageUrl == null || imageUrl!.trim().isEmpty
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
              )
            : Image.network(
                imageUrl!,
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
              ),
      ),
    );
  }
}

class _LiveTvCard extends StatefulWidget {
  const _LiveTvCard({required this.liveVideoFuture, required this.onRetry});

  final Future<VideoApiResponse> liveVideoFuture;
  final VoidCallback onRetry;

  @override
  State<_LiveTvCard> createState() => _LiveTvCardState();
}

class _LiveTvCardState extends State<_LiveTvCard> {
  YoutubePlayerController? _inlineController;
  String? _activeVideoId;
  bool _showInlinePlayer = false;

  void _hideInlinePlayer() {
    _inlineController?.pauseVideo();
    if (mounted) {
      setState(() {
        _showInlinePlayer = false;
      });
    }
  }

  String? _resolveThumbUrl(VideoItem item) {
    final thumbs = item.snippet?.thumbnails;
    return thumbs?.maxres?.url ??
        thumbs?.standard?.url ??
        thumbs?.high?.url ??
        thumbs?.medium?.url ??
        thumbs?.defaultThumb?.url;
  }

  String? _resolveVideoId(VideoItem? item) {
    return item?.id?.videoId ?? item?.snippet?.resourceId?.videoId;
  }

  void _playVideo(BuildContext context, VideoItem? item) {
    final videoId = _resolveVideoId(item);
    if (videoId == null || videoId.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Video is not available right now.')),
      );
      return;
    }
    if (_activeVideoId != videoId || _inlineController == null) {
      _inlineController?.close();
      _inlineController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          enableJavaScript: true,
          strictRelatedVideos: true,
        ),
      );
      _activeVideoId = videoId;
    } else {
      _inlineController!.playVideo();
    }

    if (!_showInlinePlayer) {
      setState(() {
        _showInlinePlayer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<VideoApiResponse>(
      future: widget.liveVideoFuture,
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final hasError = snapshot.hasError;
        final item = snapshot.data?.video?.items?.isNotEmpty == true
            ? snapshot.data!.video!.items!.first
            : null;
        final imageUrl = item == null ? null : _resolveThumbUrl(item);
        final title = item?.snippet?.title?.trim().isNotEmpty == true
            ? item!.snippet!.title!.trim()
            : 'Live TV';
        final chipText = snapshot.data?.isLive == true ? 'LIVE NOW' : 'LATEST';

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
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _showInlinePlayer &&
                        _inlineController != null &&
                        !isLoading &&
                        !hasError
                    ? Stack(
                        children: [
                          SizedBox(
                            height: 320,
                            width: double.infinity,
                            child: YoutubePlayer(
                              controller: _inlineController!,
                              aspectRatio: 16 / 9,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: _hideInlinePlayer,
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0x66000000),
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.close),
                            ),
                          ),
                        ],
                      )
                    : Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (isLoading || hasError)
                              ? null
                              : () => _playVideo(context, item),
                          child: Stack(
                            children: [
                              if (imageUrl != null && !isLoading && !hasError)
                                Image.network(
                                  imageUrl,
                                  height: 320,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _buildFallbackBanner(),
                                )
                              else
                                _buildFallbackBanner(),
                              const Positioned.fill(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0x20000000),
                                        Color(0x7F000000),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: DecoratedBox(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD70000),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      chipText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (isLoading)
                                const Positioned.fill(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              else if (hasError)
                                Positioned.fill(
                                  child: Center(
                                    child: ElevatedButton.icon(
                                      onPressed: widget.onRetry,
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Retry'),
                                    ),
                                  ),
                                )
                              else
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
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 8,
                      backgroundColor: Color(0xFFEB4350),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.open_in_full, size: 23),
                    const SizedBox(width: 12),
                    const Icon(Icons.volume_off_rounded, size: 23),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _inlineController?.close();
    super.dispose();
  }

  Widget _buildFallbackBanner() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3C3C3C), Color(0xFF1D1D1D)],
        ),
      ),
    );
  }
}

class _TrendingNewsSection extends StatelessWidget {
  const _TrendingNewsSection({
    required this.trendingNewsFuture,
    required this.onRetry,
  });

  final Future<NewsResponse> trendingNewsFuture;
  final VoidCallback onRetry;

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
        FutureBuilder<NewsResponse>(
          future: trendingNewsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ),
              );
            }

            final items = snapshot.data?.items ?? <NewsItem>[];
            if (items.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  'No trending news found.',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFE8E8E8)),
              itemBuilder: (context, index) {
                return _TrendingNewsRow(item: items[index], index: index);
              },
            );
          },
        ),
      ],
    );
  }
}

class _TrendingNewsRow extends StatelessWidget {
  const _TrendingNewsRow({required this.item, required this.index});

  final NewsItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final badgeColors = [
      const Color(0xFFEA0000),
      const Color(0xFF1D4F8E),
      const Color(0xFF2F6B44),
      const Color(0xFF6B4A1F),
    ];

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TrendingNewsDetailScreen(news: item),
          ),
        );
      },
      child: Padding(
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
                    item.title?.en?.trim().isNotEmpty == true
                        ? item.title!.en!.trim()
                        : item.title?.hi?.trim().isNotEmpty == true
                        ? item.title!.hi!.trim()
                        : 'Untitled',
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.category?.trim().isNotEmpty == true
                        ? item.category!.trim()
                        : 'General',
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

class _LatestItem {
  const _LatestItem({required this.title, required this.label});

  final String title;
  final String label;
}

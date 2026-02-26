import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<_ProfileStat> _stats = [
    _ProfileStat(label: 'Saved', value: '128'),
    _ProfileStat(label: 'Following', value: '42'),
    _ProfileStat(label: 'Read Today', value: '19'),
  ];

  static const List<_ProfileAction> _quickActions = [
    _ProfileAction(
      title: 'Saved Articles',
      subtitle: 'Read your bookmarked stories',
      icon: Icons.bookmark_border_rounded,
    ),
    _ProfileAction(
      title: 'Notifications',
      subtitle: 'Manage breaking news alerts',
      icon: Icons.notifications_none_rounded,
    ),
    _ProfileAction(
      title: 'Language Preferences',
      subtitle: 'English, Hindi',
      icon: Icons.language_rounded,
    ),
    _ProfileAction(
      title: 'Subscription',
      subtitle: 'Premium active until Dec 2026',
      icon: Icons.workspace_premium_outlined,
    ),
  ];

  static const List<String> _recentTopics = [
    'India',
    'Cricket',
    'Business',
    'Elections',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFD10000),
        foregroundColor: Colors.white,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const _ProfileHeaderCard(),
          const SizedBox(height: 14),
          Row(
            children: _stats
                .map((item) => Expanded(child: _StatCard(item: item)))
                .toList(),
          ),
          const SizedBox(height: 18),
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ..._quickActions.map((item) => _ActionCard(item: item)),
          const SizedBox(height: 18),
          const Text(
            'Recently Followed Topics',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentTopics
                .map(
                  (topic) => Chip(
                    label: Text(topic),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFD7DCE2)),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFFB10000),
              side: const BorderSide(color: Color(0xFFB10000)),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE10600), Color(0xFF8F0000)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person_rounded, color: Colors.white, size: 42),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Ravi Kumar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'ravi.kumar@apnews.app',
                  style: TextStyle(
                    color: Color(0xFFFFD5D5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.item});

  final _ProfileStat item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.item});

  final _ProfileAction item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFFDE8E8),
          child: Icon(item.icon, color: const Color(0xFFC10000)),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          item.subtitle,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {},
      ),
    );
  }
}

class _ProfileStat {
  const _ProfileStat({required this.label, required this.value});

  final String label;
  final String value;
}

class _ProfileAction {
  const _ProfileAction({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

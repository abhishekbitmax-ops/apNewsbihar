import 'package:flutter/material.dart';

class ElectionResultScreen extends StatelessWidget {
  const ElectionResultScreen({super.key});

  static const List<_PartyResult> _partyResults = [
    _PartyResult(
      party: 'NDA',
      shortName: 'NDA',
      seats: 302,
      target: 272,
      color: Color(0xFFEA580C),
    ),
    _PartyResult(
      party: 'INDIA',
      shortName: 'INDIA',
      seats: 221,
      target: 272,
      color: Color(0xFF2563EB),
    ),
    _PartyResult(
      party: 'OTH',
      shortName: 'OTH',
      seats: 20,
      target: 272,
      color: Color(0xFF6B7280),
    ),
  ];

  static const List<_ConstituencyUpdate> _updates = [
    _ConstituencyUpdate(
      constituency: 'Patna Sahib',
      candidate: 'R. Prasad',
      party: 'NDA',
      status: 'Leading by 42,315 votes',
    ),
    _ConstituencyUpdate(
      constituency: 'Begusarai',
      candidate: 'A. Yadav',
      party: 'INDIA',
      status: 'Leading by 18,210 votes',
    ),
    _ConstituencyUpdate(
      constituency: 'Muzaffarpur',
      candidate: 'S. Kumar',
      party: 'NDA',
      status: 'Won by 12,044 votes',
    ),
    _ConstituencyUpdate(
      constituency: 'Darbhanga',
      candidate: 'N. Jha',
      party: 'INDIA',
      status: 'Trailing by 5,902 votes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final totalCounted = _partyResults.fold<int>(0, (sum, e) => sum + e.seats);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF9B0000),
        foregroundColor: Colors.white,
        title: const Text(
          'Election Results',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ResultHero(totalCounted: totalCounted),
              const SizedBox(height: 16),
              _MajorityBanner(totalCounted: totalCounted),
              const SizedBox(height: 20),
              const Text(
                'Party Tally',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _partyResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _PartyResultCard(item: _partyResults[index]);
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Latest Constituency Updates',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _updates.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _ConstituencyCard(item: _updates[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultHero extends StatelessWidget {
  const _ResultHero({required this.totalCounted});

  final int totalCounted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB91C1C), Color(0xFF7F1D1D)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lok Sabha 2026',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Counting in progress',
            style: TextStyle(
              color: Color(0xFFFECACA),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _HeroStat(label: 'Total Seats', value: '543'),
              const SizedBox(width: 10),
              _HeroStat(label: 'Counted', value: '$totalCounted'),
              const SizedBox(width: 10),
              const _HeroStat(label: 'Majority', value: '272'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0x22FFFFFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFF3F4F6),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MajorityBanner extends StatelessWidget {
  const _MajorityBanner({required this.totalCounted});

  final int totalCounted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Text(
        'Majority mark is 272 seats. $totalCounted seats counted so far.',
        style: const TextStyle(
          color: Color(0xFF9A3412),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PartyResultCard extends StatelessWidget {
  const _PartyResultCard({required this.item});

  final _PartyResult item;

  @override
  Widget build(BuildContext context) {
    final progress = (item.seats / item.target).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: item.color,
                child: Text(
                  item.shortName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item.party,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                '${item.seats}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFF3F4F6),
              color: item.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.seats >= item.target
                ? 'Crossed majority mark'
                : '${item.target - item.seats} more needed for majority',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConstituencyCard extends StatelessWidget {
  const _ConstituencyCard({required this.item});

  final _ConstituencyUpdate item;

  @override
  Widget build(BuildContext context) {
    final isNda = item.party == 'NDA';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.constituency,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isNda
                      ? const Color(0xFFFFEDD5)
                      : const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.party,
                  style: TextStyle(
                    color: isNda
                        ? const Color(0xFF9A3412)
                        : const Color(0xFF1E3A8A),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.candidate,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.status,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PartyResult {
  const _PartyResult({
    required this.party,
    required this.shortName,
    required this.seats,
    required this.target,
    required this.color,
  });

  final String party;
  final String shortName;
  final int seats;
  final int target;
  final Color color;
}

class _ConstituencyUpdate {
  const _ConstituencyUpdate({
    required this.constituency,
    required this.candidate,
    required this.party,
    required this.status,
  });

  final String constituency;
  final String candidate;
  final String party;
  final String status;
}

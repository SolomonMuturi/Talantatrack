import 'package:flutter/material.dart';
import '../../models/player.dart';
import '../../widgets/player_management/player_book.dart';
import 'package:intl/intl.dart';

class PlayerDetailsScreen extends StatefulWidget {
  final int playerId;

  const PlayerDetailsScreen({super.key, required this.playerId});

  @override
  State<PlayerDetailsScreen> createState() => _PlayerDetailsScreenState();
}

class _PlayerDetailsScreenState extends State<PlayerDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Player? _player;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _fetchPlayer();
  }

  Future<void> _fetchPlayer() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _player = Player(
        id: widget.playerId,
        name: 'Alex Johnson',
        age: 16,
        position: 'Midfielder',
        avatarUrl: '',
        team: 'U-17',
        attendance: 94.5,
        disciplineScore: 98,
        rank: 12,
        points: 450,
        stats: PlayerStats(played: 15, wins: 10, draws: 3, losses: 2),
        highlights: ['Top scorer in Regional Cup', 'Clean sheet streak: 3 matches'],
        gpsData: GpsData(maxSpeed: 32.4, distanceCovered: 10.2, playerLoad: 450),
        performanceMetrics: PerformanceMetrics(
          physical: {'Speed': 85, 'Stamina': 90, 'Strength': 78},
          technical: {'Dribbling': 88, 'Shooting': 82, 'Passing': 92},
          tactical: {'Positioning': 85, 'Game Reading': 88},
          psychoSocial: {'Leadership': 80, 'Teamwork': 95},
        ),
        disciplinaryLog: [],
        injuryLog: [
          InjuryEntry(id: 1, date: DateTime.now().subtract(const Duration(days: 30)), injury: 'Ankle Sprain', severity: 'Medium', rtpStatus: 'Cleared to Play'),
        ],
        certificates: [
          Certificate(id: 'c1', moduleName: 'Advanced Passing', date: DateTime.now().subtract(const Duration(days: 60))),
        ],
      );
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_player == null) return const Scaffold(body: Center(child: Text('Player not found')));

    return Scaffold(
      appBar: AppBar(
        title: Text(_player!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            onPressed: () => _showPlayerBook(),
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: ID Card & Highlights
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildIdCard(),
                  const SizedBox(height: 16),
                  _buildHighlights(),
                ],
              ),
            ),
          ),
          // Right Side: Tabs
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Performance'),
                    Tab(text: 'Stats'),
                    Tab(text: 'GPS'),
                    Tab(text: 'Discipline'),
                    Tab(text: 'Injuries'),
                    Tab(text: 'Achievements'),
                    Tab(text: 'Details'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildPerformanceTab(),
                      _buildStatsTab(),
                      _buildGpsTab(),
                      _buildDisciplineTab(),
                      _buildInjuriesTab(),
                      _buildAchievementsTab(),
                      _buildDetailsTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCard() {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Digital ID', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('TT-${String.fromCharCodes([65 + widget.playerId % 26])}${widget.playerId}', style: TextStyle(color: theme.colorScheme.primary, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),
            CircleAvatar(radius: 40, backgroundColor: theme.colorScheme.surfaceVariant),
            const SizedBox(height: 16),
            Text(_player!.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(_player!.position, style: const TextStyle(color: Colors.grey)),
            const Divider(height: 32),
            _buildIdInfoRow('Team', _player!.team),
            _buildIdInfoRow('Rank', '#${_player!.rank}'),
            _buildIdInfoRow('Attendance', '${_player!.attendance}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildIdInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHighlights() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Performance Highlights', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ..._player!.highlights.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(h, style: const TextStyle(fontSize: 12))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildMetricSection('Physical', _player!.performanceMetrics.physical),
        const SizedBox(height: 32),
        _buildMetricSection('Technical', _player!.performanceMetrics.technical),
        const SizedBox(height: 32),
        _buildMetricSection('Tactical', _player!.performanceMetrics.tactical),
      ],
    );
  }

  Widget _buildMetricSection(String title, Map<String, int> metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 16),
        ...metrics.entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key),
                  Text('${e.value}/100', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: e.value / 100),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildStatsTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildStatCard('Played', _player!.stats.played.toString()),
          _buildStatCard('Wins', _player!.stats.wins.toString(), color: Colors.green),
          _buildStatCard('Draws', _player!.stats.draws.toString(), color: Colors.orange),
          _buildStatCard('Losses', _player!.stats.losses.toString(), color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGpsTab() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('Max Speed', '${_player!.gpsData.maxSpeed} km/h')),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard('Distance', '${_player!.gpsData.distanceCovered} km')),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Movement Heatmap', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade900, borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('GPS data visualization coming soon', style: TextStyle(color: Colors.grey))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisciplineTab() {
    return _buildLogList('Disciplinary Issues', _player!.disciplinaryLog, Icons.shield_outlined);
  }

  Widget _buildInjuriesTab() {
    return _buildLogList('Injury History', _player!.injuryLog, Icons.medical_services_outlined);
  }

  Widget _buildLogList(String title, List logs, IconData emptyIcon) {
    if (logs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 64, color: Colors.grey.shade800),
            const SizedBox(height: 16),
            Text('No records found', style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          child: ListTile(
            title: Text(log is DisciplinaryEntry ? log.infraction : (log as InjuryEntry).injury),
            subtitle: Text(DateFormat('PPP').format(log.date)),
            trailing: Chip(label: Text(log.severity, style: const TextStyle(fontSize: 10))),
          ),
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _player!.certificates.length,
      itemBuilder: (context, index) {
        final cert = _player!.certificates[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.card_membership, color: Colors.amber),
            title: Text(cert.moduleName),
            subtitle: Text(DateFormat('PPP').format(cert.date)),
          ),
        );
      },
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildDetailItem('Full Name', _player!.name),
        _buildDetailItem('Position', _player!.position),
        _buildDetailItem('Team', _player!.team),
        _buildDetailItem('Age', '${_player!.age} years'),
        _buildDetailItem('Discipline Score', '${_player!.disciplineScore}/100'),
        _buildDetailItem('Total Points', _player!.points.toString()),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
        ],
      ),
    );
  }

  void _showPlayerBook() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: PlayerBook(player: _player!),
        ),
      ),
    );
  }
}

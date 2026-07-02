import 'package:flutter/material.dart';
import '../../widgets/kpi_card.dart';
import 'enrollment_form_screen.dart';
import 'player_details_screen.dart';

class DatabasePlayer {
  final int id;
  final String name;
  final int age;
  final String position;
  final String? avatarUrl;
  final String team;
  final int points;
  final int statsPlayed;
  final double attendance;
  final int rank;

  DatabasePlayer({
    required this.id,
    required this.name,
    required this.age,
    required this.position,
    this.avatarUrl,
    required this.team,
    required this.points,
    required this.statsPlayed,
    required this.attendance,
    required this.rank,
  });
}

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({super.key});

  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final List<DatabasePlayer> _players = [
    DatabasePlayer(id: 1, name: 'Alex Johnson', age: 16, position: 'Midfielder', team: 'U-17', points: 450, statsPlayed: 15, attendance: 94.5, rank: 12),
    DatabasePlayer(id: 2, name: 'Sarah Williams', age: 15, position: 'Forward', team: 'Girls Team', points: 380, statsPlayed: 12, attendance: 98.0, rank: 5),
    DatabasePlayer(id: 3, name: 'Michael Chen', age: 18, position: 'Goalkeeper', team: 'U-19', points: 520, statsPlayed: 20, attendance: 92.0, rank: 2),
    DatabasePlayer(id: 4, name: 'John Doe', age: 22, position: 'Defender', team: 'Senior', points: 310, statsPlayed: 10, attendance: 85.0, rank: 25),
    DatabasePlayer(id: 5, name: 'David Smith', age: 16, position: 'Midfielder', team: 'U-17', points: 290, statsPlayed: 8, attendance: 88.0, rank: 18),
  ];

  String _searchQuery = '';
  String _teamFilter = 'All';
  String _positionFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Filtering logic
    final filteredPlayers = _players.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.position.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.team.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesTeam = _teamFilter == 'All' || p.team == _teamFilter;
      final matchesPosition = _positionFilter == 'All' || p.position == _positionFilter;
      return matchesSearch && matchesTeam && matchesPosition;
    }).toList();

    // Grouping logic
    final Map<String, List<DatabasePlayer>> groupedPlayers = {};
    for (var player in filteredPlayers) {
      groupedPlayers.putIfAbsent(player.team, () => []).add(player);
    }

    // KPI Calculations
    final totalPlayers = filteredPlayers.length;
    final avgAge = totalPlayers > 0 ? filteredPlayers.map((e) => e.age).reduce((a, b) => a + b) / totalPlayers : 0.0;
    
    String mostPopulousTeam = 'N/A';
    if (totalPlayers > 0) {
      final counts = <String, int>{};
      for (var p in filteredPlayers) {
        counts[p.team] = (counts[p.team] ?? 0) + 1;
      }
      mostPopulousTeam = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildKPIs(totalPlayers, avgAge, mostPopulousTeam),
            const SizedBox(height: 24),
            _buildFilters(theme),
            const SizedBox(height: 24),
            if (filteredPlayers.isEmpty)
              _buildEmptyState()
            else
              ...groupedPlayers.entries.map((entry) => _buildTeamSection(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Player Roster', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Browse and manage academy players', style: TextStyle(color: Colors.grey)),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EnrollmentFormScreen())),
          icon: const Icon(Icons.add_circle_outline),
          label: const Text('Enroll Player'),
        ),
      ],
    );
  }

  Widget _buildKPIs(int total, double age, String team) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        KpiCard(title: 'Total Players', value: total.toString(), icon: Icons.people, description: 'Active scholars'),
        KpiCard(title: 'Average Age', value: age.toStringAsFixed(1), icon: Icons.cake, description: 'Years old'),
        KpiCard(title: 'Top Team', value: team, icon: Icons.shield, description: 'Most populous'),
      ],
    );
  }

  Widget _buildFilters(ThemeData theme) {
    final teams = ['All', ..._players.map((e) => e.team).toSet()];
    final positions = ['All', ..._players.map((e) => e.position).toSet()];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by name, team or position...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _teamFilter,
                    decoration: const InputDecoration(labelText: 'Team'),
                    items: teams.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _teamFilter = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _positionFilter,
                    decoration: const InputDecoration(labelText: 'Position'),
                    items: positions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) => setState(() => _positionFilter = val!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(String teamName, List<DatabasePlayer> players) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Text(teamName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Chip(label: Text('${players.length}', style: const TextStyle(fontSize: 12))),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 1200 ? 5 : (MediaQuery.of(context).size.width > 800 ? 3 : 2),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return _buildPlayerCard(player);
          },
        ),
      ],
    );
  }

  Widget _buildPlayerCard(DatabasePlayer player) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerDetailsScreen(playerId: player.id))),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    child: Text(player.name[0], style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 12),
                  Text(player.name, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(player.position, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMiniBadge('Age: ${player.age}'),
                      const SizedBox(width: 4),
                      _buildMiniBadge('Pts: ${player.points}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMiniBadge('${player.attendance}% Attendance', isWide: true),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: player.rank == 1 ? Colors.amber : theme.colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_events, size: 10, color: Colors.white),
                    const SizedBox(width: 2),
                    Text('#${player.rank}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, {bool isWide = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(fontSize: 9, color: Colors.grey)),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.person_search, size: 64, color: Colors.grey.shade800),
            const SizedBox(height: 16),
            const Text('No players found', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Try adjusting your filters or search query', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => setState(() {
                _searchQuery = '';
                _teamFilter = 'All';
                _positionFilter = 'All';
              }),
              child: const Text('Clear all filters'),
            ),
          ],
        ),
      ),
    );
  }
}

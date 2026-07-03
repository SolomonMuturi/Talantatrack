import 'package:flutter/material.dart';
import '../../models/player.dart';
import 'package:intl/intl.dart';

class PlayerBook extends StatelessWidget {
  final Player player;

  const PlayerBook({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 40),
          _buildSkillsAssessment(theme),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 40),
          _buildLogsSection(theme),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 40),
          _buildAchievements(theme),
          const SizedBox(height: 40),
          _buildFooter(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            backgroundImage: player.avatarUrl.startsWith('http') ? NetworkImage(player.avatarUrl) : null,
            child: player.avatarUrl.isEmpty ? Text(player.name[0], style: const TextStyle(fontSize: 40)) : null,
          ),
          const SizedBox(height: 16),
          Text(player.name, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(player.position, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderInfo('Team', player.team),
              const SizedBox(width: 24),
              _buildHeaderInfo('Age', player.age.toString()),
              const SizedBox(width: 24),
              _buildHeaderInfo('Rank', '#${player.rank}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSkillsAssessment(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Skills Assessment', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildMetricGroup('Physical', player.performanceMetrics.physical, theme),
        const SizedBox(height: 24),
        _buildMetricGroup('Technical', player.performanceMetrics.technical, theme),
        const SizedBox(height: 24),
        _buildMetricGroup('Tactical & Psycho-Social', {
          ...player.performanceMetrics.tactical,
          ...player.performanceMetrics.psychoSocial,
        }, theme),
      ],
    );
  }

  Widget _buildMetricGroup(String title, Map<String, int> metrics, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4,
            crossAxisSpacing: 20,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final entry = metrics.entries.elementAt(index);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text('${entry.value}/100', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: entry.value / 100, minHeight: 4),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogsSection(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildLogTable('Disciplinary Log', player.disciplinaryLog, theme)),
        const SizedBox(width: 40),
        Expanded(child: _buildLogTable('Injury Log', player.injuryLog, theme)),
      ],
    );
  }

  Widget _buildLogTable(String title, List logs, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (logs.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('No records found.', style: TextStyle(color: Colors.grey, fontSize: 13)),
          )
        else
          Table(
            children: [
              TableRow(
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant))),
                children: const [
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text('Entry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                ],
              ),
              ...logs.map((log) => TableRow(
                children: [
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(DateFormat('yMd').format(log.date), style: const TextStyle(fontSize: 12))),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(log is DisciplinaryEntry ? log.infraction : (log as InjuryEntry).injury, style: const TextStyle(fontSize: 12))),
                ],
              )),
            ],
          ),
      ],
    );
  }

  Widget _buildAchievements(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Achievements & Certificates', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (player.certificates.isEmpty)
          const Text('No certificates earned.', style: TextStyle(color: Colors.grey, fontSize: 13))
        else
          ...player.certificates.map((cert) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.stars, size: 16, color: Colors.amber),
                const SizedBox(width: 8),
                Text(DateFormat('yMd').format(cert.date), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 8),
                Text(cert.moduleName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TalentTrack Player Book © ${DateTime.now().year}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
            Text('Generated: ${DateFormat('yMd H:m').format(DateTime.now())}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

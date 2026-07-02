import 'package:flutter/material.dart';
import '../../models/event.dart';

class TeamFormation extends StatelessWidget {
  final String formation;
  final List<LineupPlayer> squad;

  const TeamFormation({
    super.key,
    required this.formation,
    required this.squad,
  });

  @override
  Widget build(BuildContext context) {
    final goalkeepers = squad.where((p) => _isPosition(p.position, ['goalkeeper', 'gk', 'keeper'])).toList();
    final defenders = squad.where((p) => _isPosition(p.position, ['defender', 'def', 'back', 'cb', 'rb', 'lb'])).toList();
    final midfielders = squad.where((p) => _isPosition(p.position, ['midfielder', 'mid', 'cm', 'cam', 'cdm', 'lm', 'rm'])).toList();
    final forwards = squad.where((p) => _isPosition(p.position, ['forward', 'striker', 'winger', 'attacker', 'fw', 'st', 'cf', 'lw', 'rw'])).toList();

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('Formation: $formation', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 16),
        AspectRatio(
          aspectRatio: 7 / 5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade700.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24, width: 4),
            ),
            child: Stack(
              children: [
                // Pitch markings
                const CustomPaint(
                  size: Size.infinite,
                  painter: PitchPainter(),
                ),
                // Players
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPositionRow(forwards),
                    _buildPositionRow(midfielders),
                    _buildPositionRow(defenders),
                    _buildPositionRow(goalkeepers),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildRoster(context),
      ],
    );
  }

  bool _isPosition(String? position, List<String> keywords) {
    if (position == null) return false;
    final pos = position.toLowerCase();
    return keywords.any((k) => pos.contains(k));
  }

  Widget _buildPositionRow(List<LineupPlayer> players) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: players.map((p) => _PlayerMarker(player: p)).toList(),
    );
  }

  Widget _buildRoster(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Player Roster (${squad.length})', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: squad.length,
          itemBuilder: (context, index) {
            final p = squad[index];
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text('#${p.number ?? index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(p.name ?? 'Unknown', overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(p.position ?? '?', style: const TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PlayerMarker extends StatelessWidget {
  final LineupPlayer player;

  const _PlayerMarker({required this.player});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: player.name ?? '',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Center(
              child: Text(
                '${player.number ?? ''}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player.name ?? '',
              style: const TextStyle(color: Colors.white, fontSize: 8),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class PitchPainter extends CustomPainter {
  const PitchPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Center line
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    
    // Center circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 40, paint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 2, paint..style = PaintingStyle.fill);
    paint.style = PaintingStyle.stroke;

    // Penalty areas
    final boxWidth = size.width * 0.6;
    final boxHeight = size.height * 0.15;
    
    // Top box
    canvas.drawRect(Rect.fromLTWH((size.width - boxWidth) / 2, 0, boxWidth, boxHeight), paint);
    // Bottom box
    canvas.drawRect(Rect.fromLTWH((size.width - boxWidth) / 2, size.height - boxHeight, boxWidth, boxHeight), paint);
  }

  @override
  bool shouldRepaint(PitchPainter oldDelegate) => false;
}

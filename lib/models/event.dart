class AcademyEvent {
  final String id;
  final String title;
  final String? subtitle;
  final String organizer;
  final DateTime? eventDate;
  final String category;
  final String? logoUrl;
  final String? country;
  final String? location;
  final String? venue;
  final String? gameType;
  final String? tournamentType;
  final int? teamCount;
  final String? lineupFormation;
  final List<LineupPlayer>? lineupSquad;
  final String? description;

  AcademyEvent({
    required this.id,
    required this.title,
    this.subtitle,
    required this.organizer,
    this.eventDate,
    required this.category,
    this.logoUrl,
    this.country,
    this.location,
    this.venue,
    this.gameType,
    this.tournamentType,
    this.teamCount,
    this.lineupFormation,
    this.lineupSquad,
    this.description,
  });
}

class LineupPlayer {
  final String? id;
  final String? name;
  final String? position;
  final int? number;

  LineupPlayer({
    this.id,
    this.name,
    this.position,
    this.number,
  });
}

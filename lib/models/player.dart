class Player {
  final int id;
  final String name;
  final int age;
  final String position;
  final String avatarUrl;
  final String team;
  final double attendance;
  final int disciplineScore;
  final int rank;
  final int points;
  final PlayerStats stats;
  final List<String> highlights;
  final GpsData gpsData;
  final PerformanceMetrics performanceMetrics;
  final List<DisciplinaryEntry> disciplinaryLog;
  final List<InjuryEntry> injuryLog;
  final List<Certificate> certificates;

  Player({
    required this.id,
    required this.name,
    required this.age,
    required this.position,
    required this.avatarUrl,
    required this.team,
    required this.attendance,
    required this.disciplineScore,
    required this.rank,
    required this.points,
    required this.stats,
    required this.highlights,
    required this.gpsData,
    required this.performanceMetrics,
    required this.disciplinaryLog,
    required this.injuryLog,
    required this.certificates,
  });
}

class PlayerStats {
  final int played;
  final int wins;
  final int draws;
  final int losses;

  PlayerStats({
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
  });
}

class GpsData {
  final double maxSpeed;
  final double distanceCovered;
  final int playerLoad;

  GpsData({
    required this.maxSpeed,
    required this.distanceCovered,
    required this.playerLoad,
  });
}

class PerformanceMetrics {
  final Map<String, int> physical;
  final Map<String, int> technical;
  final Map<String, int> tactical;
  final Map<String, int> psychoSocial;

  PerformanceMetrics({
    required this.physical,
    required this.technical,
    required this.tactical,
    required this.psychoSocial,
  });
}

class DisciplinaryEntry {
  final int id;
  final DateTime date;
  final String infraction;
  final String severity; // Low, Medium, High
  final String sanction;

  DisciplinaryEntry({
    required this.id,
    required this.date,
    required this.infraction,
    required this.severity,
    required this.sanction,
  });
}

class InjuryEntry {
  final int id;
  final DateTime date;
  final String injury;
  final String severity; // Low, Medium, High
  final String rtpStatus; // In Treatment, Cleared for Light Training, Cleared to Play

  InjuryEntry({
    required this.id,
    required this.date,
    required this.injury,
    required this.severity,
    required this.rtpStatus,
  });
}

class Certificate {
  final String id;
  final String moduleName;
  final DateTime date;

  Certificate({
    required this.id,
    required this.moduleName,
    required this.date,
  });
}

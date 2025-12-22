class SolutionLog {
  final String id;
  final String solutionName;
  final String amount;
  final String duration;
  final DateTime loggedAt;

  SolutionLog({
    required this.id,
    required this.solutionName,
    required this.amount,
    required this.duration,
    required this.loggedAt,
  });

  Map<String, dynamic> toJson() => {
        'solutionName': solutionName,
        'amount': amount,
        'duration': duration,
        'loggedAt': loggedAt.toIso8601String(),
      };

  static SolutionLog fromJson(String id, Map<String, dynamic> json) {
    return SolutionLog(
      id: id,
      solutionName: json['solutionName'] as String? ?? '',
      amount: json['amount'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      loggedAt: DateTime.tryParse(json['loggedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}


/// Extensions de formatage pour les distances et durées
extension DistanceFormat on double {
  /// Formate une distance en mètres vers km ou m
  String toDistanceString() {
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)} km';
    }
    return '${toStringAsFixed(0)} m';
  }
}

extension DurationFormat on int {
  /// Formate une durée en secondes vers h/min
  String toDurationString() {
    if (this >= 3600) {
      final hours = this ~/ 3600;
      final minutes = (this % 3600) ~/ 60;
      return '${hours}h${minutes > 0 ? ' ${minutes}min' : ''}';
    }
    return '${(this / 60).ceil()} min';
  }
}

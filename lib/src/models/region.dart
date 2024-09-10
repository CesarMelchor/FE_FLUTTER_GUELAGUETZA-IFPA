class Region {
  final String idRegion;
  final String region;

  Region({
    required this.idRegion,
    required this.region,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      idRegion: json['id_region'],
      region: json['region'],
    );
  }
}

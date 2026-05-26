class LocationProvince {
  final String name;
  final List<String> wards;

  const LocationProvince({
    required this.name,
    required this.wards,
  });

  factory LocationProvince.fromJson(Map<String, dynamic> json) {
    final wards = (json['Wards'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map((ward) => ward['Name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();

    return LocationProvince(
      name: json['Name']?.toString() ?? '',
      wards: wards,
    );
  }
}

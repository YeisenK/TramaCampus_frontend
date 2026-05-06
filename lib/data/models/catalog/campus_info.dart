// Parsed view of a campus entry from assets/catalogs/_derived/campus.json.
// Distinct from CatalogItem: exposes campus-specific fields (emailDomains, location).
class CampusInfo {
  const CampusInfo({
    required this.id,
    required this.name,
    required this.location,
    required this.emailDomains,
  });

  final String id; // Campus code, e.g. "UAMN"
  final String name;
  final String location;
  final List<String> emailDomains; // e.g. ["@anahuac.mx"]

  factory CampusInfo.fromJson(Map<String, dynamic> json) => CampusInfo(
        id: json['id'] as String,
        name: json['label'] as String,
        location: json['location'] as String? ?? '',
        emailDomains: (json['email_domains'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  // True if the given email's domain matches any of this campus's email_domains.
  bool allowsEmail(String email) {
    final lower = email.trim().toLowerCase();
    return emailDomains.any((d) => lower.endsWith(d.toLowerCase()));
  }
}

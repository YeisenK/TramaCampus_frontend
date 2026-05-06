import 'package:flutter/material.dart';
import 'category_section.dart';

// A CategorySection variant for research faculties.
// Maps known faculty (set) IDs to icons and accent colors.
class FacultySection extends StatelessWidget {
  const FacultySection({
    super.key,
    required this.setId,
    required this.title,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.selectedCount = 0,
  });

  final String setId;
  final String title;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final int selectedCount;

  static const _icons = <String, IconData>{
    'engineering_research': Icons.engineering_outlined,
    'computer_science_research': Icons.computer_outlined,
    'data_science_research': Icons.bar_chart_outlined,
    'biomedical_research': Icons.biotech_outlined,
    'business_and_economic_research': Icons.business_center_outlined,
    'legal_research': Icons.gavel_outlined,
    'communication_research': Icons.campaign_outlined,
    'design_research': Icons.design_services_outlined,
    'architecture_research': Icons.architecture_outlined,
    'educational_research': Icons.school_outlined,
    'humanities_research': Icons.menu_book_outlined,
    'social_sciences_research': Icons.people_outlined,
    'health_and_sports_research': Icons.favorite_border,
  };

  static const _colors = <String, Color>{
    'engineering_research': Color(0xFF1565C0),
    'computer_science_research': Color(0xFF6A1B9A),
    'data_science_research': Color(0xFF00695C),
    'biomedical_research': Color(0xFFC62828),
    'business_and_economic_research': Color(0xFF2E7D32),
    'legal_research': Color(0xFF4E342E),
    'communication_research': Color(0xFFE65100),
    'design_research': Color(0xFF0277BD),
    'architecture_research': Color(0xFF558B2F),
    'educational_research': Color(0xFFAD1457),
    'humanities_research': Color(0xFF6D4C41),
    'social_sciences_research': Color(0xFF283593),
    'health_and_sports_research': Color(0xFFD84315),
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[setId];
    final color = _colors[setId];
    return CategorySection(
      title: title,
      expanded: expanded,
      onToggle: onToggle,
      selectedCount: selectedCount,
      accentColor: color,
      leading: icon != null && color != null
          ? Icon(icon, size: 18, color: color)
          : null,
      child: child,
    );
  }
}

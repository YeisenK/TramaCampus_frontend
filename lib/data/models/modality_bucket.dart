import 'package:flutter/material.dart';

// Keep ModalityType for back-compat with existing screens that import it.
// New code should use ModalityBucketId.
enum ModalityType { estudio, amistad, personal }

// Alias so both enum names coexist without duplication.
typedef ModalityBucketId = ModalityType;

// Mapping from each UI bucket to the backend modes[] it expands to.
// Per json-integration.md §2. Owned exclusively by this file + ModalityResolver.
const Map<ModalityBucketId, List<String>> kBucketDefaultModes = {
  ModalityBucketId.estudio: ['study', 'research', 'competition'],
  ModalityBucketId.amistad: [
    'social',
    'networking',
    'gaming',
    'language',
    'creative',
    'volunteer',
    'wellness',
    'lifestyle',
    'startup',
  ],
  ModalityBucketId.personal: ['eros'],
};

class ModalityBucket {
  const ModalityBucket({
    required this.id,
    required this.label,
    required this.verb,
    required this.icon,
    required this.defaultModes,
  });

  final ModalityBucketId id;
  final String label;
  final String verb;
  final IconData icon;
  final List<String> defaultModes;

  static const estudio = ModalityBucket(
    id: ModalityBucketId.estudio,
    label: 'Estudio',
    verb: 'Estudiar juntos',
    icon: Icons.menu_book_outlined,
    defaultModes: ['study', 'research', 'competition'],
  );

  static const amistad = ModalityBucket(
    id: ModalityBucketId.amistad,
    label: 'Amistad',
    verb: 'Conectar',
    icon: Icons.group_outlined,
    defaultModes: [
      'social',
      'networking',
      'gaming',
      'language',
      'creative',
      'volunteer',
      'wellness',
      'lifestyle',
      'startup',
    ],
  );

  static const personal = ModalityBucket(
    id: ModalityBucketId.personal,
    label: 'Conexión personal',
    verb: 'Conocer',
    icon: Icons.explore_outlined,
    defaultModes: ['eros'],
  );

  static const all = [estudio, amistad, personal];

  static ModalityBucket fromId(ModalityBucketId id) => switch (id) {
    ModalityBucketId.estudio => estudio,
    ModalityBucketId.amistad => amistad,
    ModalityBucketId.personal => personal,
  };

  // Back-compat alias so existing code using `m.type` continues to work.
  ModalityType get type => id;
}

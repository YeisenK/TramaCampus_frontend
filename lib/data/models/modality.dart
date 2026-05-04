import 'package:flutter/material.dart';

enum ModalityType { estudio, amistad, personal }

class Modality {
  const Modality({
    required this.type,
    required this.label,
    required this.verb,
    required this.icon,
  });

  final ModalityType type;
  final String label;
  final String verb;
  final IconData icon;

  static const estudio = Modality(
    type: ModalityType.estudio,
    label: 'Estudio',
    verb: 'Estudiar juntos',
    icon: Icons.menu_book_outlined,
  );

  static const amistad = Modality(
    type: ModalityType.amistad,
    label: 'Amistad',
    verb: 'Conectar',
    icon: Icons.group_outlined,
  );

  static const personal = Modality(
    type: ModalityType.personal,
    label: 'Conexión personal',
    verb: 'Conocer',
    icon: Icons.explore_outlined,
  );

  static const all = [estudio, amistad, personal];
}

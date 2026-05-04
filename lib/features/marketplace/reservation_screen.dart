import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/models/affiliate_business.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key, required this.business});

  final AffiliateBusiness business;

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _selectedDate;
  String? _selectedSlot;
  final _noteCtrl = TextEditingController();

  static const _slots = [
    '9:00 – 12:00 (Mañana)',
    '12:00 – 16:00 (Tarde)',
    '16:00 – 20:00 (Noche)',
  ];

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  void _confirm() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha')),
      );
      return;
    }
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un horario')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Reservación confirmada: ${_selectedDate!.day}/${_selectedDate!.month} — $_selectedSlot',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: TAppBar(title: widget.business.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Seleccionar fecha', style: AppTextStyles.titleMd(cs.onSurface)),
            const SizedBox(height: AppSpacing.space2),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.space4),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, color: cs.primary, size: 20),
                    const SizedBox(width: AppSpacing.space3),
                    Text(
                      _selectedDate == null
                          ? 'Elige una fecha'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: AppTextStyles.bodyMd(
                        _selectedDate == null ? cs.onSurfaceVariant : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.space5),
            Text('Horario disponible', style: AppTextStyles.titleMd(cs.onSurface)),
            const SizedBox(height: AppSpacing.space3),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: _slots
                  .map(
                    (slot) => TChip(
                      label: slot,
                      selected: _selectedSlot == slot,
                      onTap: () => setState(() => _selectedSlot = slot),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.space5),
            TTextField(
              controller: _noteCtrl,
              label: 'Nota (opcional)',
              hint: 'Escribe cualquier detalle adicional...',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.space6),
            TButton(
              label: 'Confirmar reservación',
              onPressed: _confirm,
              icon: Icons.check_circle_outline,
            ),
            const SizedBox(height: AppSpacing.space6),
          ],
        ),
      ),
    );
  }
}

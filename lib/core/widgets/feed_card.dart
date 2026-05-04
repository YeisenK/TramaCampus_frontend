import 'package:flutter/material.dart';
import '../../data/models/student.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import 't_chip.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.student,
    required this.onTap,
    required this.onSave,
    this.isSaved = false,
  });

  final Student student;
  final VoidCallback onTap;
  final VoidCallback onSave;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.06),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PhotoArea(student: student, onSave: onSave, isSaved: isSaved),
            _CardBody(student: student),
          ],
        ),
      ),
    );
  }
}

class _PhotoArea extends StatelessWidget {
  const _PhotoArea({required this.student, required this.onSave, required this.isSaved});

  final Student student;
  final VoidCallback onSave;
  final bool isSaved;

  ImageProvider _imageProvider(String url) =>
      url.startsWith('assets/') ? AssetImage(url) as ImageProvider : NetworkImage(url);

  Widget _gradientFallback(Student s) => Container(
        decoration: BoxDecoration(gradient: AppColors.avatarGradient(s.hue)),
        alignment: Alignment.center,
        child: Text(
          s.initials,
          style: AppTextStyles.display(Colors.white.withValues(alpha: 0.85)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: student.photoUrl != null
                  ? Image(
                      image: _imageProvider(student.photoUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) => _gradientFallback(student),
                    )
                  : _gradientFallback(student),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      cs.surfaceContainerLowest.withValues(alpha: 0.85),
                    ],
                    stops: const [0.55, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: AppSpacing.space3,
              left: AppSpacing.space3,
              child: _GlassPill(student: student),
            ),
            Positioned(
              top: AppSpacing.space3,
              right: AppSpacing.space3,
              child: _SaveButton(onSave: onSave, isSaved: isSaved),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space3,
        vertical: AppSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        student.program,
        style: AppTextStyles.labelSm(cs.onSurface),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.onSave, required this.isSaved});

  final VoidCallback onSave;
  final bool isSaved;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onSave,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest.withValues(alpha: 0.82),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          size: 20,
          color: isSaved ? cs.primary : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space4,
        AppSpacing.space3,
        AppSpacing.space4,
        AppSpacing.space4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${student.name}, ${student.age}',
                style: AppTextStyles.headlineSm(cs.onSurface),
              ),
              const Spacer(),
              if (student.compatibilityScore > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space2, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: AppColors.ctaGradient(),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '${student.compatibilityScore}%',
                    style: AppTextStyles.labelSm(Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.space1),
          Text(
            '${student.program} · Sem. ${student.semester}',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
          if (student.reasons.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space3),
            ...student.reasons.take(2).map((r) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.space1),
                  child: Row(
                    children: [
                      Icon(Icons.check, size: 14, color: cs.primary),
                      const SizedBox(width: AppSpacing.space2),
                      Text(r, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                    ],
                  ),
                )),
          ],
          if (student.bio.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space3),
            Text(
              '"${student.bio.length > 80 ? '${student.bio.substring(0, 80)}…' : student.bio}"',
              style: AppTextStyles.bodySm(cs.onSurfaceVariant).copyWith(fontStyle: FontStyle.italic),
            ),
          ],
          if (student.interests.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.space3),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: student.interests.take(3).map((i) => TChip(label: i)).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

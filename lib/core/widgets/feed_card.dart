import 'package:flutter/material.dart';
import '../../data/models/student.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
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
              color: cs.onSurface.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, 6),
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
  const _PhotoArea({
    required this.student,
    required this.onSave,
    required this.isSaved,
  });

  final Student student;
  final VoidCallback onSave;
  final bool isSaved;

  ImageProvider _imageProvider(String url) => url.startsWith('assets/')
      ? AssetImage(url) as ImageProvider
      : NetworkImage(url);

  Widget _gradientFallback(Student s) => Container(
        decoration: BoxDecoration(gradient: AppColors.avatarGradient(s.hue)),
        alignment: Alignment.center,
        child: Text(
          s.initials,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 56,
            fontWeight: FontWeight.w700,
            color: Color(0x52FFFFFF),
            letterSpacing: -1.12,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.lg),
      ),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            Positioned.fill(
              child: student.photoUrl != null
                  ? Image(
                      image: _imageProvider(student.photoUrl!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, _) =>
                          _gradientFallback(student),
                    )
                  : _gradientFallback(student),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: _CtxPill(student: student),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: _SaveButton(onSave: onSave, isSaved: isSaved),
            ),
          ],
        ),
      ),
    );
  }
}

class _CtxPill extends StatelessWidget {
  const _CtxPill({required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        student.program,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: cs.onSurface,
          letterSpacing: 0.3,
          height: 1,
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    return GestureDetector(
      onTap: onSave,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          size: 16,
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
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: name + meta / compatibility pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student.name}, ${student.age}',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                        letterSpacing: -0.19,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student.program} · Sem. ${student.semester}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: cs.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              if (student.compatibilityScore > 0) ...[
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '${student.compatibilityScore}%',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: cs.primary,
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ],
            ],
          ),
          // Reasons
          if (student.reasons.isNotEmpty) ...[
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: student.reasons
                  .take(3)
                  .map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.check_circle_outline,
                              size: 16,
                              color: cs.primary,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              r,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: cs.onSurface,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          // Quote block
          if (student.bio.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                '"${student.bio.length > 110 ? '${student.bio.substring(0, 110)}…' : student.bio}"',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                  letterSpacing: -0.07,
                  height: 1.5,
                ),
              ),
            ),
          ],
          // Interest chips
          if (student.interests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: AppSpacing.space2,
              runSpacing: AppSpacing.space2,
              children: student.interests
                  .take(3)
                  .map((i) => TChip(label: i))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

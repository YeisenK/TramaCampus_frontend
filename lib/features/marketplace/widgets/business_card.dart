import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/affiliate_business.dart';

class BusinessCard extends StatelessWidget {
  const BusinessCard({super.key, required this.business});

  final AffiliateBusiness business;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRouter.affiliateDetail, arguments: business),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            _Crest(serviceType: business.serviceType),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          business.name,
                          style: AppTextStyles.titleMd(cs.onSurface),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space1),
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: cs.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    business.serviceType.label,
                    style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.space2),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

class _Crest extends StatelessWidget {
  const _Crest({required this.serviceType});
  final AffiliateServiceType serviceType;

  IconData get _icon => switch (serviceType) {
        AffiliateServiceType.restaurant => Icons.restaurant_outlined,
        AffiliateServiceType.gym => Icons.fitness_center_outlined,
        AffiliateServiceType.salon => Icons.content_cut_outlined,
        AffiliateServiceType.copyshop => Icons.print_outlined,
        AffiliateServiceType.laundry => Icons.local_laundry_service_outlined,
        AffiliateServiceType.tutoring => Icons.school_outlined,
        AffiliateServiceType.brand => Icons.star_outline,
        AffiliateServiceType.rental => Icons.home_outlined,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.ctaGradient(),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Icon(_icon, color: Colors.white, size: 26),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/affiliate_business.dart';

class AffiliateBusinessCard extends StatelessWidget {
  const AffiliateBusinessCard({super.key, required this.business});

  final AffiliateBusiness business;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.of(
        context,
      ).pushNamed(AppRouter.affiliateDetail, arguments: business),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _BusinessIcon(serviceType: business.serviceType),
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
                      const SizedBox(width: AppSpacing.space2),
                      const _VerifiedBadge(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    business.serviceType.label,
                    style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                  ),
                  if (business.promotions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.space2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.space2,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        business.promotions.first,
                        style: AppTextStyles.labelSm(AppColors.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
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

class _BusinessIcon extends StatelessWidget {
  const _BusinessIcon({required this.serviceType});

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
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: AppColors.ctaGradient(),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      alignment: Alignment.center,
      child: Icon(_icon, color: Colors.white, size: 24),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified, size: 14, color: AppColors.primary),
        SizedBox(width: 2),
        Text(
          'Verificado',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

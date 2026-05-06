import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/marketplace_listing.dart';

class ListingCardGrid extends StatelessWidget {
  const ListingCardGrid({super.key, required this.listing});

  final MarketplaceListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRouter.listingDetail, arguments: listing),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.sm + 2),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.sm + 2),
                ),
                child: listing.imageUrls.isNotEmpty
                    ? Image.network(
                        listing.imageUrls.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => _placeholder(cs),
                      )
                    : _placeholder(cs),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space2 + 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: AppTextStyles.labelSm(cs.onSurface).copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${listing.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ColorScheme cs) => Container(
        decoration: BoxDecoration(gradient: AppColors.ctaGradient()),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: 28,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      );
}

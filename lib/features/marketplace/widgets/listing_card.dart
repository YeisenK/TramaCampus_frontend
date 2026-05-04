import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/t_chip.dart';
import '../../../data/models/marketplace_listing.dart';

class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing});

  final MarketplaceListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRouter.listingDetail, arguments: listing),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ThumbnailArea(listing: listing),
            _CardInfo(listing: listing),
          ],
        ),
      ),
    );
  }
}

class _ThumbnailArea extends StatelessWidget {
  const _ThumbnailArea({required this.listing});

  final MarketplaceListing listing;

  Widget _placeholder(ColorScheme cs) => Container(
        width: double.infinity,
        color: cs.surfaceContainerHigh,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: 36,
          color: cs.onSurfaceVariant.withValues(alpha: 0.35),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            if (listing.imageUrls.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  listing.imageUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) => _placeholder(cs),
                ),
              )
            else
              _placeholder(cs),
            if (listing.isBoosted)
              Positioned(
                top: AppSpacing.space2,
                left: AppSpacing.space2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space2,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text('Destacado', style: AppTextStyles.labelSm(Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  const _CardInfo({required this.listing});

  final MarketplaceListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listing.title,
            style: AppTextStyles.titleMd(cs.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.space1),
          Text(
            '\$${listing.price.toStringAsFixed(0)} MXN',
            style: AppTextStyles.bodyMd(cs.primary).copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.space2),
          TChip(label: listing.category.label),
        ],
      ),
    );
  }
}

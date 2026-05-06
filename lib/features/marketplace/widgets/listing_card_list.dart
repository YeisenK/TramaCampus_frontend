import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/marketplace_listing.dart';

class ListingCardList extends StatelessWidget {
  const ListingCardList({super.key, required this.listing});

  final MarketplaceListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRouter.listingDetail, arguments: listing),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Thumbnail(listing: listing, cs: cs),
                const SizedBox(width: AppSpacing.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: AppTextStyles.titleMd(cs.onSurface),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        listing.sellerName,
                        style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                      ),
                      const SizedBox(height: AppSpacing.space2),
                      Text(
                        '\$${listing.price.toStringAsFixed(0)} MXN',
                        style: TextStyle(
                          fontSize: 15,
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
          Divider(
            height: 1,
            thickness: 1,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.listing, required this.cs});
  final MarketplaceListing listing;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: SizedBox(
        width: 80,
        height: 80,
        child: listing.imageUrls.isNotEmpty
            ? Image.network(
                listing.imageUrls.first,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder,
              )
            : _placeholder,
      ),
    );
  }

  Widget get _placeholder => Container(
        color: cs.surfaceContainerHigh,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          size: 28,
          color: cs.onSurfaceVariant.withValues(alpha: 0.35),
        ),
      );
}

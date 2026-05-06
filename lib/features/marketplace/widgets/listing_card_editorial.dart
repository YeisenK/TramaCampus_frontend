import 'package:flutter/material.dart';
import '../../../core/navigation/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/marketplace_listing.dart';

class ListingCardEditorial extends StatelessWidget {
  const ListingCardEditorial({
    super.key,
    required this.listing,
    this.isSaved = false,
    this.onSave,
  });

  final MarketplaceListing listing;
  final bool isSaved;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed(AppRouter.listingDetail, arguments: listing),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md + 2),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PhotoArea(listing: listing, isSaved: isSaved, onSave: onSave),
            _InfoArea(listing: listing, cs: cs),
          ],
        ),
      ),
    );
  }
}

class _PhotoArea extends StatelessWidget {
  const _PhotoArea({
    required this.listing,
    required this.isSaved,
    required this.onSave,
  });
  final MarketplaceListing listing;
  final bool isSaved;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final aspectH = MediaQuery.sizeOf(context).width * 0.625;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.md + 2),
      ),
      child: SizedBox(
        height: aspectH.clamp(140.0, 220.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            listing.imageUrls.isNotEmpty
                ? Image.network(
                    listing.imageUrls.first,
                    fit: BoxFit.cover,
                    cacheWidth: 600,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceContainerHigh,
                      child: Icon(
                        Icons.image_outlined,
                        size: 36,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.35),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(gradient: AppColors.ctaGradient()),
                    child: Icon(
                      Icons.image_outlined,
                      size: 36,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
            Positioned(
              top: AppSpacing.space3,
              right: AppSpacing.space3,
              child: _GlassSaveButton(isSaved: isSaved, onTap: onSave),
            ),
            Positioned(
              bottom: AppSpacing.space3,
              left: AppSpacing.space3,
              child: _GlassPill(label: listing.category.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassSaveButton extends StatelessWidget {
  const _GlassSaveButton({required this.isSaved, required this.onTap});
  final bool isSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0x47000000),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class _GlassPill extends StatelessWidget {
  const _GlassPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x4D000000),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _InfoArea extends StatelessWidget {
  const _InfoArea({required this.listing, required this.cs});
  final MarketplaceListing listing;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  listing.title,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.space2),
              Text(
                '\$${listing.price.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.space2),
          _SellerLine(listing: listing, cs: cs),
        ],
      ),
    );
  }
}

class _SellerLine extends StatelessWidget {
  const _SellerLine({required this.listing, required this.cs});
  final MarketplaceListing listing;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            listing.sellerName.isNotEmpty ? listing.sellerName[0] : '?',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            listing.sellerName,
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/marketplace_listing.dart';

class FeaturedStrip extends StatelessWidget {
  const FeaturedStrip({super.key, required this.listing, this.onTap});

  final MarketplaceListing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _Background(listing: listing, cs: cs),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      stops: const [0.35, 1.0],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.space3,
                left: AppSpacing.space3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.space2,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 11, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'DESTACADO',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: AppSpacing.space4,
                left: AppSpacing.space4,
                right: AppSpacing.space4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: AppTextStyles.headlineSm(Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.space1),
                    Row(
                      children: [
                        Text(
                          '\$${listing.price.toStringAsFixed(0)} MXN',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.space3),
                        Text(
                          listing.sellerName,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.listing, required this.cs});
  final MarketplaceListing listing;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    if (listing.imageUrls.isNotEmpty) {
      return Image.network(
        listing.imageUrls.first,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) => _GradientPlaceholder(cs: cs),
      );
    }
    return _GradientPlaceholder(cs: cs);
  }
}

class _GradientPlaceholder extends StatelessWidget {
  const _GradientPlaceholder({required this.cs});
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.ctaGradient(),
      ),
    );
  }
}

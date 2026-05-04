import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_chip.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/marketplace_listing.dart';
import '../../core/widgets/t_avatar.dart';

class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key, required this.listing});

  final MarketplaceListing listing;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final listing = widget.listing;
    final imageCount = listing.imageUrls.isEmpty ? 1 : listing.imageUrls.length;

    return Scaffold(
      appBar: TAppBar(title: listing.title),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Gallery(
              listing: listing,
              page: _page,
              imageCount: imageCount,
              onPageChanged: (p) => setState(() => _page = p),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: AppTextStyles.headlineSm(cs.onSurface),
                        ),
                      ),
                      if (listing.isBoosted) ...[
                        const SizedBox(width: AppSpacing.space2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.space2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text(
                            'Destacado',
                            style: AppTextStyles.labelSm(Colors.white),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    '\$${listing.price.toStringAsFixed(0)} MXN',
                    style: AppTextStyles.headlineMd(cs.primary),
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  TChip(label: listing.category.label),
                  const SizedBox(height: AppSpacing.space5),
                  Text(
                    'Descripción',
                    style: AppTextStyles.titleMd(cs.onSurface),
                  ),
                  const SizedBox(height: AppSpacing.space2),
                  Text(
                    listing.description,
                    style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: AppSpacing.space5),
                  _SellerCard(listing: listing),
                  const SizedBox(height: AppSpacing.space5),
                  TButton(
                    label: 'Comprar / Contactar',
                    onPressed: () => _onContact(context),
                    icon: Icons.shopping_bag_outlined,
                  ),
                  const SizedBox(height: AppSpacing.space3),
                  TButton(
                    label: 'Enviar mensaje',
                    onPressed: () => _onMessage(context, listing),
                    icon: Icons.chat_bubble_outline,
                    variant: TButtonVariant.secondary,
                  ),
                  const SizedBox(height: AppSpacing.space6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onContact(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Próximamente: pago integrado')),
    );
  }

  void _onMessage(BuildContext context, MarketplaceListing listing) {
    final seller = MockData.students.firstWhere(
      (s) => s.name == listing.sellerName,
      orElse: () => MockData.students.first,
    );
    Navigator.of(context).pushNamed(AppRouter.conversation, arguments: seller);
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.listing,
    required this.page,
    required this.imageCount,
    required this.onPageChanged,
  });

  final MarketplaceListing listing;
  final int page;
  final int imageCount;
  final ValueChanged<int> onPageChanged;

  Widget _imagePlaceholder(ColorScheme cs) => Container(
    color: cs.surfaceContainerHigh,
    alignment: Alignment.center,
    child: Icon(
      Icons.image_outlined,
      size: 64,
      color: cs.onSurfaceVariant.withValues(alpha: 0.35),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: imageCount,
            onPageChanged: onPageChanged,
            itemBuilder: (context, i) {
              if (listing.imageUrls.isNotEmpty) {
                return Image.network(
                  listing.imageUrls[i],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, _) => _imagePlaceholder(cs),
                );
              }
              return _imagePlaceholder(cs);
            },
          ),
          if (imageCount > 1)
            Positioned(
              bottom: AppSpacing.space3,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageCount,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: i == page ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i == page
                          ? cs.primary
                          : cs.onSurface.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  const _SellerCard({required this.listing});

  final MarketplaceListing listing;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final seller = MockData.students
        .where((s) => s.name == listing.sellerName)
        .firstOrNull;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          TAvatar(
            initials: listing.sellerName.isNotEmpty
                ? listing.sellerName[0]
                : '?',
            hue: seller?.hue ?? 220,
            photoUrl: seller?.photoUrl,
            size: 44,
          ),
          const SizedBox(width: AppSpacing.space3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listing.sellerName,
                style: AppTextStyles.titleMd(cs.onSurface),
              ),
              Text(
                'Vendedor',
                style: AppTextStyles.bodySm(cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

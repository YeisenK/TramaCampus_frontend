import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_chip.dart';
import '../../data/models/affiliate_business.dart';
import '../../data/models/marketplace_listing.dart';
import '../../data/repositories/marketplace_repository.dart';
import 'widgets/affiliate_business_card.dart';
import 'widgets/listing_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  ListingCategory? _selectedCategory;
  bool _isLoading = true;
  List<AffiliateBusiness> _businesses = [];
  List<MarketplaceListing> _listings = [];

  static const List<ListingCategory?> _categories = [
    null,
    ListingCategory.apuntes,
    ListingCategory.servicios,
    ListingCategory.articulos,
    ListingCategory.freelance,
  ];
  static const _categoryLabels = ['Todos', 'Apuntes', 'Servicios', 'Artículos', 'Freelance'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final businesses = await MarketplaceRepository.instance.getAffiliateBusinesses();
    final listings = await MarketplaceRepository.instance.getListings(
      category: _selectedCategory,
    );
    if (!mounted) return;
    setState(() {
      _businesses = businesses;
      _listings = listings;
      _isLoading = false;
    });
  }

  Future<void> _onCategoryChanged(int index) async {
    setState(() => _selectedCategory = _categories[index]);
    await _load();
  }

  void _onVenderTap() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (sheetCtx) => _SellOptionsSheet(
        onCreateListing: () {
          Navigator.pop(sheetCtx);
          Navigator.of(context).pushNamed(AppRouter.createListing);
        },
        onMyListings: () {
          Navigator.pop(sheetCtx);
          _showMyListings();
        },
      ),
    );
  }

  void _showMyListings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const _MyListingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: 'Marketplace',
        showBack: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.space3),
          _CategoryFilter(
            selectedIndex: _categories.indexOf(_selectedCategory),
            labels: _categoryLabels,
            onChanged: _onCategoryChanged,
          ),
          const SizedBox(height: AppSpacing.space2),
          Expanded(
            child: _ExploreView(
              isLoading: _isLoading,
              businesses: _businesses,
              listings: _listings,
              onRefresh: _load,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onVenderTap,
        icon: const Icon(Icons.add),
        label: const Text('Vender'),
      ),
    );
  }
}

// ── Category filter ──────────────────────────────────────────────────────────

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.space2),
        itemBuilder: (context, i) => TChip(
          label: labels[i],
          selected: i == selectedIndex,
          onTap: () => onChanged(i),
        ),
      ),
    );
  }
}

// ── Explore view ─────────────────────────────────────────────────────────────

class _ExploreView extends StatelessWidget {
  const _ExploreView({
    required this.isLoading,
    required this.businesses,
    required this.listings,
    required this.onRefresh,
  });

  final bool isLoading;
  final List<AffiliateBusiness> businesses;
  final List<MarketplaceListing> listings;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (isLoading) return const _MarketplaceSkeleton();

    final boosted = listings.where((l) => l.isBoosted).toList();
    final rest = listings.where((l) => !l.isBoosted).toList();
    final sorted = [...boosted, ...rest];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space4,
          AppSpacing.space4,
          AppSpacing.space4,
          100,
        ),
        children: [
          if (businesses.isNotEmpty) ...[
            Text('Empresas del campus', style: AppTextStyles.headlineSm(cs.onSurface)),
            const SizedBox(height: AppSpacing.space3),
            ...businesses.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: AffiliateBusinessCard(business: b),
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Divider(color: cs.outlineVariant.withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.space4),
          ],
          if (sorted.isNotEmpty) ...[
            Text('Estudiantes', style: AppTextStyles.headlineSm(cs.onSurface)),
            const SizedBox(height: AppSpacing.space3),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.space3,
                mainAxisSpacing: AppSpacing.space3,
                mainAxisExtent: 268,
              ),
              itemCount: sorted.length,
              itemBuilder: (context, i) => ListingCard(listing: sorted[i]),
            ),
          ],
          if (businesses.isEmpty && sorted.isEmpty) const _EmptyState(),
        ],
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.space10),
      child: Column(
        children: [
          Icon(
            Icons.storefront_outlined,
            size: 64,
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.space3),
          Text('Sin publicaciones', style: AppTextStyles.headlineSm(cs.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.space2),
          Text(
            'Prueba cambiando la categoría',
            style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ── Skeleton ─────────────────────────────────────────────────────────────────

class _MarketplaceSkeleton extends StatelessWidget {
  const _MarketplaceSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: List.generate(
        5,
        (_) => const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.space3),
          child: SkeletonLoader(height: 80, borderRadius: AppRadius.lg),
        ),
      ),
    );
  }
}

// ── Sell options bottom sheet ─────────────────────────────────────────────────

class _SellOptionsSheet extends StatelessWidget {
  const _SellOptionsSheet({
    required this.onCreateListing,
    required this.onMyListings,
  });

  final VoidCallback onCreateListing;
  final VoidCallback onMyListings;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space4,
          AppSpacing.space3,
          AppSpacing.space4,
          AppSpacing.space4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text('¿Qué quieres hacer?', style: AppTextStyles.headlineSm(cs.onSurface)),
            const SizedBox(height: AppSpacing.space4),
            _SheetOption(
              icon: Icons.add_box_outlined,
              iconColor: AppColors.primary,
              title: 'Crear anuncio',
              subtitle: 'Publica apuntes, servicios, artículos o freelance',
              onTap: onCreateListing,
            ),
            const SizedBox(height: AppSpacing.space3),
            _SheetOption(
              icon: Icons.inventory_2_outlined,
              iconColor: cs.onSurfaceVariant,
              title: 'Mis publicaciones',
              subtitle: 'Revisa y administra tus anuncios activos',
              onTap: onMyListings,
            ),
            const SizedBox(height: AppSpacing.space2),
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.space4),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMd(cs.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySm(cs.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}

// ── My listings bottom sheet ──────────────────────────────────────────────────

class _MyListingsSheet extends StatelessWidget {
  const _MyListingsSheet();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space4,
          AppSpacing.space3,
          AppSpacing.space4,
          AppSpacing.space4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: cs.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
            const SizedBox(height: AppSpacing.space4),
            Text('Mis publicaciones', style: AppTextStyles.headlineSm(cs.onSurface)),
            const SizedBox(height: AppSpacing.space6),
            Icon(
              Icons.inventory_2_outlined,
              size: 56,
              color: cs.onSurfaceVariant.withValues(alpha: 0.35),
            ),
            const SizedBox(height: AppSpacing.space3),
            Text(
              'Sin publicaciones aún',
              style: AppTextStyles.titleMd(cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.space2),
            Text(
              'Tus anuncios activos aparecerán aquí.',
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.space6),
          ],
        ),
      ),
    );
  }
}

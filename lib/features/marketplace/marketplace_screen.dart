import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/skeleton_loader.dart';
import '../../core/widgets/t_chip.dart';
import '../../data/models/affiliate_business.dart';
import '../../data/models/marketplace_listing.dart';
import '../../data/repositories/marketplace_repository.dart';
import 'publish_sheet.dart';
import 'widgets/business_card.dart';
import 'widgets/featured_strip.dart';
import 'widgets/listing_card_editorial.dart';
import 'widgets/listing_card_grid.dart';
import 'widgets/listing_card_list.dart';

enum _ListingVariant { editorial, list, grid }

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  ListingCategory? _selectedCategory;
  _ListingVariant _variant = _ListingVariant.editorial;
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
  static const _categoryLabels = [
    'Todos',
    'Apuntes',
    'Servicios',
    'Artículos',
    'Freelance',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final businesses = await MarketplaceRepository.instance
        .getAffiliateBusinesses();
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

  Future<void> _load() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  Future<void> _onCategoryChanged(int index) async {
    // Keep existing data visible during filter — no skeleton flash on cached data.
    setState(() => _selectedCategory = _categories[index]);
    await _loadData();
  }

  void _onPublishTap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => PublishSheet(onPublished: _load),
    );
  }

  void _showMyListings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const _MyListingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scopeIdx = _categories.indexOf(_selectedCategory);
    final scopeLabel = scopeIdx >= 0 ? _categoryLabels[scopeIdx] : 'Todo';
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditorialHeader(
            onSavedTap: _showMyListings,
            onNotificationsTap: () {},
          ),
          _SearchBar(scope: scopeLabel, onTap: () {}),
          const SizedBox(height: AppSpacing.space1),
          _CategoryFilter(
            selectedIndex: _categories.indexOf(_selectedCategory),
            labels: _categoryLabels,
            onChanged: _onCategoryChanged,
          ),
          _VariantSwitcher(
            selected: _variant,
            onChanged: (v) => setState(() => _variant = v),
          ),
          const SizedBox(height: AppSpacing.space2),
          Expanded(
            child: _ExploreView(
              isLoading: _isLoading,
              businesses: _businesses,
              listings: _listings,
              variant: _variant,
              onRefresh: _load,
              onShowMyListings: _showMyListings,
            ),
          ),
        ],
      ),
      floatingActionButton: _PublishFab(onTap: _onPublishTap),
    );
  }
}

// ── Editorial header ──────────────────────────────────────────────────────────

class _EditorialHeader extends StatelessWidget {
  const _EditorialHeader({
    required this.onSavedTap,
    required this.onNotificationsTap,
  });
  final VoidCallback onSavedTap;
  final VoidCallback onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space5,
          AppSpacing.space4,
          AppSpacing.space4,
          AppSpacing.space2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Marketplace · Anáhuac Oaxaca',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: AppSpacing.space2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    'Mercado del campus',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                      letterSpacing: -0.025 * 30,
                      height: 1.05,
                    ),
                  ),
                ),
                _PillIconButton(
                  icon: Icons.bookmark_outline,
                  onTap: onSavedTap,
                ),
                const SizedBox(width: AppSpacing.space2),
                _PillIconButton(
                  icon: Icons.notifications_none_outlined,
                  onTap: onNotificationsTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.scope, required this.onTap});
  final String scope;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.space5,
        AppSpacing.space2,
        AppSpacing.space5,
        AppSpacing.space2,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space4),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: 18,
                color: cs.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.space2),
              Expanded(
                child: Text(
                  'Buscar en el campus…',
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  scope,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: cs.onSurface,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PillIconButton extends StatelessWidget {
  const _PillIconButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glassBg = isDark ? AppColors.darkGlassBg : AppColors.lightGlassBg;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: glassBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: cs.onSurface),
          ),
        ),
      ),
    );
  }
}

// ── Variant switcher ──────────────────────────────────────────────────────────

class _VariantSwitcher extends StatelessWidget {
  const _VariantSwitcher({required this.selected, required this.onChanged});
  final _ListingVariant selected;
  final ValueChanged<_ListingVariant> onChanged;

  static const _variants = [
    (_ListingVariant.editorial, Icons.view_agenda_outlined, 'Editorial'),
    (_ListingVariant.list, Icons.list_outlined, 'Lista'),
    (_ListingVariant.grid, Icons.grid_view_outlined, 'Grid'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space5,
        vertical: AppSpacing.space2,
      ),
      child: Row(
        children: _variants.map((entry) {
          final (variant, icon, label) = entry;
          final isActive = selected == variant;
          return GestureDetector(
            onTap: () => onChanged(variant),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: AppSpacing.space2),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.space3,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: isActive ? cs.onSurface : cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: isActive ? cs.surface : cs.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isActive ? cs.surface : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Category filter ───────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space5),
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

// ── Explore view ──────────────────────────────────────────────────────────────

class _ExploreView extends StatelessWidget {
  const _ExploreView({
    required this.isLoading,
    required this.businesses,
    required this.listings,
    required this.variant,
    required this.onRefresh,
    required this.onShowMyListings,
  });

  final bool isLoading;
  final List<AffiliateBusiness> businesses;
  final List<MarketplaceListing> listings;
  final _ListingVariant variant;
  final Future<void> Function() onRefresh;
  final VoidCallback onShowMyListings;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _MarketplaceSkeleton();

    final featured = listings.where((l) => l.isBoosted).toList();
    final rest = listings.where((l) => !l.isBoosted).toList();

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.space5,
          AppSpacing.space3,
          AppSpacing.space5,
          120,
        ),
        children: [
          if (featured.isNotEmpty) ...[
            FeaturedStrip(listing: featured.first, onTap: () {}),
            const SizedBox(height: AppSpacing.space5),
          ],
          if (businesses.isNotEmpty) ...[
            _SectionTitle(title: 'Empresas del campus'),
            const SizedBox(height: AppSpacing.space3),
            ...businesses.map(
              (b) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.space3),
                child: BusinessCard(business: b),
              ),
            ),
            const SizedBox(height: AppSpacing.space3),
          ],
          if (rest.isNotEmpty) ...[
            _SectionTitle(title: 'Estudiantes'),
            const SizedBox(height: AppSpacing.space3),
            _ListingsBody(listings: rest, variant: variant),
            const SizedBox(height: AppSpacing.space5),
          ],
          if (businesses.isNotEmpty || listings.isNotEmpty)
            _StatsBar(
              listingCount: listings.length,
              businessCount: businesses.length,
            ),
          if (businesses.isEmpty && listings.isEmpty) const _EmptyState(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(title, style: AppTextStyles.headlineSm(cs.onSurface));
  }
}

class _ListingsBody extends StatelessWidget {
  const _ListingsBody({required this.listings, required this.variant});
  final List<MarketplaceListing> listings;
  final _ListingVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == _ListingVariant.list) {
      return Column(
        children: listings.map((l) => ListingCardList(listing: l)).toList(),
      );
    }
    if (variant == _ListingVariant.grid) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.space3,
          mainAxisSpacing: AppSpacing.space3,
          childAspectRatio: 1.0,
        ),
        itemCount: listings.length,
        itemBuilder: (context, i) => ListingCardGrid(listing: listings[i]),
      );
    }
    // Editorial (default)
    return Column(
      children: listings
          .map(
            (l) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space4),
              child: ListingCardEditorial(listing: l),
            ),
          )
          .toList(),
    );
  }
}

// ── Stats bar ─────────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar({required this.listingCount, required this.businessCount});
  final int listingCount;
  final int businessCount;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ghost = isDark
        ? AppColors.darkOutlineGhost
        : AppColors.lightOutlineGhost;
    final stats = [
      ('Publicaciones', '$listingCount'),
      ('Empresas', '$businessCount'),
      ('Categorías', '4'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            for (int i = 0; i < stats.length; i++) ...[
              if (i > 0) VerticalDivider(width: 1, thickness: 1, color: ghost),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stats[i].$2,
                      style: AppTextStyles.headlineSm(cs.primary),
                    ),
                    Text(
                      stats[i].$1,
                      style: AppTextStyles.labelSm(cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
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
          Text(
            'Sin publicaciones',
            style: AppTextStyles.headlineSm(cs.onSurfaceVariant),
          ),
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

// ── Skeleton ──────────────────────────────────────────────────────────────────

class _MarketplaceSkeleton extends StatelessWidget {
  const _MarketplaceSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.space4),
      children: [
        SkeletonLoader(height: 200, borderRadius: AppRadius.lg),
        const SizedBox(height: AppSpacing.space3),
        ...List.generate(
          4,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.space3),
            child: SkeletonLoader(height: 80, borderRadius: AppRadius.md),
          ),
        ),
      ],
    );
  }
}

// ── Publish FAB ───────────────────────────────────────────────────────────────

class _PublishFab extends StatelessWidget {
  const _PublishFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.space5),
        decoration: BoxDecoration(
          gradient: AppColors.ctaGradient(),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          boxShadow: AppColors.shadowFabLight,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white, size: 20),
            SizedBox(width: AppSpacing.space2),
            Text(
              'Publicar',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── My listings sheet ─────────────────────────────────────────────────────────

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
            Text(
              'Mis publicaciones',
              style: AppTextStyles.headlineSm(cs.onSurface),
            ),
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

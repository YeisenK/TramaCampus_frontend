import 'dart:async';
import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../error_state.dart';
import '../skeleton_loader.dart';
import '../t_chip.dart';
import 'affinity_suggestion_strip.dart';
import 'bucket_header.dart';
import 'catalog_picker_sheet.dart';
import 'category_section.dart';
import 'faculty_section.dart';
import 'icon_option_card.dart';
import 'relevance_chip.dart';
import 'selection_preview_bar.dart';
import 'selection_search_bar.dart';
import 'sport_frequency_tile.dart';
import 'trait_card.dart';
import '../../../data/models/catalog/catalog.dart';
import '../../../data/models/catalog/catalog_item.dart';
import '../../../data/models/catalog/relevance_data.dart';
import '../../../data/models/modality_bucket.dart';
import '../../../data/models/profile/profile_attribute.dart';
import '../../../data/repositories/catalog_repository.dart';
import '../../../data/services/selection_relevance_engine.dart';

enum SelectionVariant {
  bucketed,
  chipCloud,
  traitCards,
  iconCards,
  facultyFaceted,
}

const kKeystonePersonalityTraits = {
  'introvertido',
  'extrovertido',
  'ambicioso',
  'tranquilo',
  'competitivo',
  'creativo',
  'analítico',
  'espontáneo',
  'líder',
  'disciplinado',
  'empático',
  'adaptable',
};

const _kDietIcons = <String, IconData>{
  'omnivoro': Icons.restaurant_menu_outlined,
  'vegetariano': Icons.eco_outlined,
  'vegano': Icons.spa_outlined,
  'sin_gluten': Icons.grain_outlined,
  'halal': Icons.star_outline,
  'kosher': Icons.verified_outlined,
  'sin_lactosa': Icons.no_drinks_outlined,
};

// Max chips rendered per bucket/set before showing a "Ver más" button.
const _kItemCap = 30;

class SelectionExperience extends StatefulWidget {
  const SelectionExperience({
    super.key,
    required this.catalogName,
    required this.variant,
    required this.initialSelected,
    required this.onChanged,
    this.careerId,
    this.campusId,
    this.activeBuckets = const [],
    this.currentGoals = const {},
    this.min,
    this.max,
    this.allowSearch = true,
    this.allowAffinitySuggestions = true,
    this.keystoneFilter,
    this.sportFrequencies = const {},
    this.onSportFrequencyChanged,
  });

  final String catalogName;
  final SelectionVariant variant;
  final Set<String> initialSelected;
  final ValueChanged<Set<String>> onChanged;
  final String? careerId;
  final String? campusId;
  final List<ModalityBucketId> activeBuckets;
  final Set<String> currentGoals;
  final int? min;
  final int? max;
  final bool allowSearch;
  final bool allowAffinitySuggestions;
  final Set<String>? keystoneFilter;
  final Map<String, SportFrequency> sportFrequencies;
  final void Function(String sportId, SportFrequency freq)?
  onSportFrequencyChanged;

  @override
  State<SelectionExperience> createState() => _SelectionExperienceState();
}

class _SelectionExperienceState extends State<SelectionExperience> {
  bool _loading = true;
  Object? _error;
  Catalog? _catalog;
  RelevanceData _relevance = RelevanceData.empty();
  String? _areaId;
  String? _areaLabel;

  late Set<String> _selected;

  final _searchCtrl = TextEditingController();
  // _query and _searchResults update together after the debounce fires.
  String _query = '';
  List<CatalogItem> _searchResults = [];
  Timer? _searchDebounce;

  Set<String> _expandedBuckets = {'recommended'};
  Set<String> _expandedSets = {};
  // Tracks which buckets/sets have their full item list visible (past _kItemCap).
  final Set<String> _fullExpanded = {};

  List<CatalogItem> _suggestions = [];
  Timer? _suggestionTimer;

  SelectionBuckets? _buckets;
  List<RankedCatalogSet>? _rankedSets;
  // Items grouped by set.id — computed once after catalog loads, reused on every build.
  Map<String, List<CatalogItem>> _itemsBySet = {};

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelected);
    _searchCtrl.addListener(_onSearchChanged);
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchDebounce?.cancel();
    _suggestionTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      final q = _searchCtrl.text;
      final results = q.trim().isEmpty
          ? <CatalogItem>[]
          : (_catalog?.search(q) ?? []);
      setState(() {
        _query = q;
        _searchResults = results;
      });
    });
  }

  Future<void> _load() async {
    try {
      // Fire all async reads concurrently — all are memoized so subsequent
      // calls return instantly from cache.
      final catalogF = BundledCatalogRepository.instance.load(
        widget.catalogName,
      );
      final relevanceF = BundledCatalogRepository.instance.loadRelevance();
      final academicF = widget.careerId != null
          ? BundledCatalogRepository.instance.load('academic')
          : Future<Catalog?>.value(null);

      final catalog = await catalogF;
      final relevance = await relevanceF;
      final academic = await academicF;

      String? areaId;
      String? areaLabel;
      if (academic != null && widget.careerId != null) {
        final item = academic.byId(widget.careerId!);
        // _parseAcademicCatalog lowercases area IDs; relevance.json uses uppercase.
        // Normalize to uppercase so areaMatchScoreFor comparisons work correctly.
        areaId = item?.sets.firstOrNull?.toUpperCase();
        if (areaId != null) {
          areaLabel = academic.sets
              .where((s) => s.id.toUpperCase() == areaId)
              .map((s) => s.label)
              .firstOrNull;
        }
      }

      if (!mounted) return;
      setState(() {
        _catalog = catalog;
        _relevance = relevance;
        _areaId = areaId;
        _areaLabel = areaLabel;
        _loading = false;
        _computeDerived(catalog, relevance);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e;
      });
    }
  }

  SelectionContext _ctx() => SelectionContext(
    academicAreaId: _areaId,
    campusId: widget.campusId,
    buckets: widget.activeBuckets,
    currentSelections: {'goal': widget.currentGoals},
  );

  void _computeDerived(Catalog catalog, RelevanceData relevance) {
    // Build the set→items map once; queries into it are O(1) vs O(n) per build.
    _itemsBySet = {};
    for (final item in catalog.items) {
      for (final setId in item.sets) {
        (_itemsBySet[setId] ??= []).add(item);
      }
    }
    final ctx = _ctx();
    if (widget.variant == SelectionVariant.bucketed) {
      final ranked = SelectionRelevanceEngine.rankItems(
        catalogName: widget.catalogName,
        items: catalog.items,
        context: ctx,
        relevance: relevance,
      );
      _buckets = SelectionRelevanceEngine.bucketize(ranked, ctx);
      _expandedBuckets = _buckets!.recommended.isNotEmpty
          ? {'recommended'}
          : {'exploreMore'};
    } else if (widget.variant == SelectionVariant.facultyFaceted) {
      _rankedSets = SelectionRelevanceEngine.rankSets(
        sets: catalog.sets,
        context: ctx,
        relevance: relevance,
      );
      _expandedSets = _rankedSets!.isNotEmpty ? {_rankedSets!.first.id} : {};
    } else {
      _expandedSets = catalog.sets.map((s) => s.id).toSet();
    }
  }

  bool _canSelect(String id) =>
      _selected.contains(id) ||
      widget.max == null ||
      _selected.length < widget.max!;

  void _toggle(String id) {
    if (!_canSelect(id) && !_selected.contains(id)) return;
    final wasSelected = _selected.contains(id);
    setState(() {
      if (wasSelected) {
        _selected.remove(id);
        _suggestions = [];
        _suggestionTimer?.cancel();
      } else {
        _selected.add(id);
        _maybeSuggest(id);
      }
    });
    widget.onChanged(Set.unmodifiable(_selected));
  }

  void _maybeSuggest(String seedId) {
    if (!widget.allowAffinitySuggestions || _catalog == null) return;
    final sugg = SelectionRelevanceEngine.suggestFromSeed(
      catalogName: widget.catalogName,
      seedItemId: seedId,
      items: _catalog!.items,
      alreadySelected: _selected,
      relevance: _relevance,
    );
    if (sugg.isEmpty) return;
    _suggestionTimer?.cancel();
    setState(() => _suggestions = sugg);
    _suggestionTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) setState(() => _suggestions = []);
    });
  }

  String _labelFor(String id) => _catalog?.byId(id)?.label ?? id;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorState(
        message: 'Error cargando opciones.',
        onRetry: () {
          setState(() {
            _error = null;
            _loading = true;
          });
          _load();
        },
      );
    }
    if (_loading || _catalog == null) return const SkeletonLoader();

    return Column(
      children: [
        Expanded(child: _buildVariant()),
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            child: _selected.isEmpty
                ? const SizedBox.shrink()
                : SelectionPreviewBar(
                    selectedLabels: {
                      for (final id in _selected) id: _labelFor(id),
                    },
                    onRemove: _toggle,
                    min: widget.min,
                    max: widget.max,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariant() => switch (widget.variant) {
    SelectionVariant.bucketed => _buildBucketed(),
    SelectionVariant.chipCloud => _buildChipCloud(),
    SelectionVariant.traitCards => _buildTraitCards(),
    SelectionVariant.iconCards => _buildIconCards(),
    SelectionVariant.facultyFaceted => _buildFacultyFaceted(),
  };

  // ── Bucketed ──────────────────────────────────────────────────────────────

  Widget _buildBucketed() {
    final searching = _query.trim().isNotEmpty;
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.space5),
      children: [
        if (widget.allowSearch) ...[
          SelectionSearchBar(
            controller: _searchCtrl,
            hint: 'Buscar…',
            resultCount: searching ? _searchResults.length : null,
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SizeTransition(sizeFactor: animation, child: child),
          ),
          child: (_suggestions.isNotEmpty && !searching)
              ? Column(
                  key: const ValueKey('strip'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AffinitySuggestionStrip(
                      suggestions: _suggestions,
                      onSelect: _toggle,
                    ),
                    const SizedBox(height: AppSpacing.space2),
                  ],
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
        if (searching)
          _cappedChipsFlat('search', _searchResults)
        else ...[
          _bucketBlock(
            'recommended',
            BucketType.recommended,
            _buckets!.recommended,
          ),
          _bucketBlock(
            'popularInMajor',
            BucketType.popularInMajor,
            _buckets!.popularInMajor,
          ),
          _bucketBlock(
            'popularOnCampus',
            BucketType.popularOnCampus,
            _buckets!.popularOnCampus,
          ),
          _bucketBlock(
            'exploreMore',
            BucketType.exploreMore,
            _buckets!.exploreMore,
          ),
          _bucketBlock(
            'otherAreas',
            BucketType.otherAreas,
            _buckets!.otherAreas,
          ),
        ],
      ],
    );
  }

  Widget _bucketBlock(
    String key,
    BucketType type,
    List<RankedItem<CatalogItem>> items,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    final selectedHere = items
        .where((ri) => _selected.contains(ri.item.id))
        .length;
    return CategorySection(
      title: _bucketLabel(type),
      expanded: _expandedBuckets.contains(key),
      onToggle: () => setState(() {
        if (!_expandedBuckets.remove(key)) _expandedBuckets.add(key);
      }),
      selectedCount: selectedHere,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BucketHeader(type: type, areaLabel: _areaLabel),
          _cappedChipsRanked(key, items),
        ],
      ),
    );
  }

  String _bucketLabel(BucketType t) => switch (t) {
    BucketType.recommended => 'Recomendado para ti',
    BucketType.popularInMajor => 'Popular en tu carrera',
    BucketType.popularOnCampus => 'Popular en tu campus',
    BucketType.exploreMore => 'Explorar más',
    BucketType.otherAreas => 'Otras áreas',
  };

  // Renders up to _kItemCap chips; adds a "Ver más" tap if the list is bigger.
  Widget _cappedChipsRanked(String key, List<RankedItem<CatalogItem>> items) {
    final showAll = _fullExpanded.contains(key);
    final visible = showAll || items.length <= _kItemCap
        ? items
        : items.take(_kItemCap).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: visible.map((ri) {
            final sel = _selected.contains(ri.item.id);
            return RelevanceChip(
              label: ri.item.label,
              selected: sel,
              reason: ri.reason,
              onTap: _canSelect(ri.item.id) || sel
                  ? () => _toggle(ri.item.id)
                  : null,
            );
          }).toList(),
        ),
        if (!showAll && items.length > _kItemCap)
          _showMoreButton(key, items.length - _kItemCap),
      ],
    );
  }

  Widget _cappedChipsFlat(String key, List<CatalogItem> items) {
    final showAll = _fullExpanded.contains(key);
    final visible = showAll || items.length <= _kItemCap
        ? items
        : items.take(_kItemCap).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: visible.map((item) {
            final sel = _selected.contains(item.id);
            return TChip(
              label: item.label,
              selected: sel,
              onTap: _canSelect(item.id) || sel ? () => _toggle(item.id) : null,
            );
          }).toList(),
        ),
        if (!showAll && items.length > _kItemCap)
          _showMoreButton(key, items.length - _kItemCap),
      ],
    );
  }

  Widget _showMoreButton(String key, int remaining) {
    final cs = Theme.of(context).colorScheme;
    return TextButton(
      onPressed: () => setState(() => _fullExpanded.add(key)),
      child: Text(
        'Ver $remaining más',
        style: AppTextStyles.labelSm(cs.primary),
      ),
    );
  }

  // ── Chip cloud ────────────────────────────────────────────────────────────

  Widget _buildChipCloud() {
    final catalog = _catalog!;
    final searching = _query.trim().isNotEmpty;
    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.space5),
      children: [
        if (widget.allowSearch) ...[
          SelectionSearchBar(
            controller: _searchCtrl,
            hint: 'Buscar…',
            resultCount: searching ? _searchResults.length : null,
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
        if (searching)
          _cappedChipsFlat('search', _searchResults)
        else
          ...catalog.sets.map((set) {
            final items = _itemsBySet[set.id] ?? const [];
            if (items.isEmpty) return const SizedBox.shrink();
            final selectedHere = items
                .where((i) => _selected.contains(i.id))
                .length;
            return CategorySection(
              title: set.label,
              expanded: _expandedSets.contains(set.id),
              onToggle: () => setState(() {
                if (!_expandedSets.remove(set.id)) _expandedSets.add(set.id);
              }),
              selectedCount: selectedHere,
              child: _buildSetContent(set.id, items),
            );
          }),
      ],
    );
  }

  Widget _buildSetContent(String setId, List<CatalogItem> items) {
    final isSport = widget.catalogName == 'sport';
    if (!isSport) return _cappedChipsFlat(setId, items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.space2,
          runSpacing: AppSpacing.space2,
          children: items.map((item) {
            final sel = _selected.contains(item.id);
            return TChip(
              label: item.label,
              selected: sel,
              onTap: _canSelect(item.id) || sel ? () => _toggle(item.id) : null,
            );
          }).toList(),
        ),
        ..._selected.where((id) => items.any((i) => i.id == id)).map((sportId) {
          final freq =
              widget.sportFrequencies[sportId] ?? SportFrequency.casual;
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.space3),
            child: SportFrequencyTile(
              label: _labelFor(sportId),
              frequency: freq,
              onFrequencyChanged: (f) =>
                  widget.onSportFrequencyChanged?.call(sportId, f),
              onRemove: () => _toggle(sportId),
            ),
          );
        }),
      ],
    );
  }

  // ── Trait cards ───────────────────────────────────────────────────────────

  static const _traitIcons = <String, IconData>{
    'introvertido': Icons.self_improvement_outlined,
    'extrovertido': Icons.groups_outlined,
    'ambicioso': Icons.trending_up_outlined,
    'tranquilo': Icons.waves_outlined,
    'competitivo': Icons.emoji_events_outlined,
    'creativo': Icons.lightbulb_outline,
    'analítico': Icons.analytics_outlined,
    'espontáneo': Icons.bolt_outlined,
    'líder': Icons.star_outline,
    'disciplinado': Icons.schedule_outlined,
    'empático': Icons.favorite_border,
    'adaptable': Icons.swap_horiz_outlined,
  };

  Widget _buildTraitCards() {
    final catalog = _catalog!;
    final keystone = widget.keystoneFilter ?? kKeystonePersonalityTraits;
    final visible = catalog.items
        .where((i) => keystone.contains(i.id) || _selected.contains(i.id))
        .toList();
    final cs = Theme.of(context).colorScheme;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.space5),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.space3,
            mainAxisSpacing: AppSpacing.space3,
            childAspectRatio: 1.6,
          ),
          itemCount: visible.length,
          itemBuilder: (_, i) {
            final item = visible[i];
            final sel = _selected.contains(item.id);
            return TraitCard(
              label: item.label,
              selected: sel,
              icon: _traitIcons[item.id],
              enabled: _canSelect(item.id) || sel,
              onTap: () => _toggle(item.id),
            );
          },
        ),
        const SizedBox(height: AppSpacing.space4),
        OutlinedButton.icon(
          onPressed: () async {
            final result = await CatalogPickerSheet.show(
              context,
              catalogName: widget.catalogName,
              initialSelected: Set.from(_selected),
              title: 'Más rasgos',
              max: widget.max,
            );
            if (result != null) {
              setState(() => _selected = result);
              widget.onChanged(Set.unmodifiable(_selected));
            }
          },
          icon: const Icon(Icons.tune_outlined, size: 18),
          label: const Text('Ver más rasgos'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space3),
        if (widget.max != null)
          Text(
            'Selecciona hasta ${widget.max}',
            style: AppTextStyles.labelSm(cs.onSurfaceVariant),
          ),
      ],
    );
  }

  // ── Icon cards (diet) ─────────────────────────────────────────────────────

  Widget _buildIconCards() {
    final items = _catalog!.items;
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.space5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.space3,
        mainAxisSpacing: AppSpacing.space3,
        mainAxisExtent: 72,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final item = items[i];
        final sel = _selected.contains(item.id);
        return IconOptionCard(
          label: item.label,
          selected: sel,
          icon: _kDietIcons[item.id],
          enabled: _canSelect(item.id) || sel,
          onTap: () => _toggle(item.id),
        );
      },
    );
  }

  // ── Faculty faceted (research) ────────────────────────────────────────────

  Widget _buildFacultyFaceted() {
    final catalog = _catalog!;
    final ranked =
        _rankedSets ??
        catalog.sets.map((s) => RankedCatalogSet(set: s, score: 0)).toList();
    final searching = _query.trim().isNotEmpty;

    return ListView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.space5),
      children: [
        if (widget.allowSearch) ...[
          SelectionSearchBar(
            controller: _searchCtrl,
            hint: 'Buscar intereses…',
            resultCount: searching ? _searchResults.length : null,
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
        if (searching)
          _cappedChipsFlat('search', _searchResults)
        else
          ...ranked.map((rs) {
            final items = _itemsBySet[rs.id] ?? const [];
            if (items.isEmpty) return const SizedBox.shrink();
            final selectedHere = items
                .where((i) => _selected.contains(i.id))
                .length;
            return FacultySection(
              setId: rs.id,
              title: rs.label,
              expanded: _expandedSets.contains(rs.id),
              onToggle: () => setState(() {
                if (!_expandedSets.remove(rs.id)) _expandedSets.add(rs.id);
              }),
              selectedCount: selectedHere,
              child: _cappedChipsFlat(rs.id, items),
            );
          }),
      ],
    );
  }
}

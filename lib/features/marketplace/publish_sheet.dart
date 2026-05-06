import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_grab_bar.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/marketplace_listing.dart';
import '../../data/repositories/marketplace_repository.dart';

class PublishSheet extends StatefulWidget {
  const PublishSheet({super.key, this.onPublished});

  final VoidCallback? onPublished;

  @override
  State<PublishSheet> createState() => _PublishSheetState();
}

class _PublishSheetState extends State<PublishSheet> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  int _categoryIndex = 0;
  bool _isLoading = false;

  static const _categories = [
    ListingCategory.apuntes,
    ListingCategory.servicios,
    ListingCategory.articulos,
    ListingCategory.freelance,
  ];
  static const _categoryLabels = ['Apuntes', 'Servicios', 'Artículos', 'Freelance'];
  static const _categoryIcons = [
    Icons.menu_book_outlined,
    Icons.build_outlined,
    Icons.shopping_bag_outlined,
    Icons.work_outline,
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    if (title.isEmpty || desc.isEmpty || price <= 0) return;

    setState(() => _isLoading = true);
    final listing = MarketplaceListing(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: desc,
      price: price,
      category: _categories[_categoryIndex],
      type: ListingType.studentListing,
      isBoosted: false,
      isAffiliate: false,
      sellerName: MockData.currentUser.name,
      imageUrls: const [],
      publishedAt: DateTime.now(),
    );
    await MarketplaceRepository.instance.createListing(listing);
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context);
    widget.onPublished?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.space4,
            AppSpacing.space3,
            AppSpacing.space4,
            AppSpacing.space4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: TGrabBar()),
              const SizedBox(height: AppSpacing.space4),
              Text(
                'Publicar anuncio',
                style: AppTextStyles.headlineSm(cs.onSurface),
              ),
              const SizedBox(height: AppSpacing.space4),
              Text(
                'Categoría',
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space2),
              _CategoryGrid(
                labels: _categoryLabels,
                icons: _categoryIcons,
                selected: _categoryIndex,
                onChanged: (i) => setState(() => _categoryIndex = i),
              ),
              const SizedBox(height: AppSpacing.space4),
              _SheetField(
                controller: _titleCtrl,
                label: 'Título',
                hint: 'Ej. Apuntes de Cálculo III',
              ),
              const SizedBox(height: AppSpacing.space3),
              _SheetField(
                controller: _descCtrl,
                label: 'Descripción',
                hint: 'Describe tu producto o servicio...',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.space3),
              _SheetField(
                controller: _priceCtrl,
                label: 'Precio (MXN)',
                hint: 'Ej. 150',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: AppSpacing.space4),
              _PhotoGrid(),
              const SizedBox(height: AppSpacing.space5),
              TButton(
                label: _isLoading ? 'Publicando...' : 'Publicar',
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.labels,
    required this.icons,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final List<IconData> icons;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppSpacing.space2,
        mainAxisSpacing: AppSpacing.space2,
        mainAxisExtent: 72,
      ),
      itemCount: labels.length,
      itemBuilder: (context, i) {
        final isActive = i == selected;
        return GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isActive ? cs.onSurface : cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icons[i],
                  size: 22,
                  color: isActive ? cs.surface : cs.onSurfaceVariant,
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isActive ? cs.surface : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SheetField extends StatelessWidget {
  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
  });
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: AppTextStyles.bodyMd(cs.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            filled: true,
            fillColor: cs.surfaceContainerHigh,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space3,
              vertical: AppSpacing.space3,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: BorderSide(color: cs.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Fotos', style: AppTextStyles.labelSm(cs.onSurfaceVariant)),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: AppSpacing.space2,
            mainAxisSpacing: AppSpacing.space2,
            mainAxisExtent: 72,
          ),
          itemCount: 4,
          itemBuilder: (context, i) => Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.5),
                style: BorderStyle.solid,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              i == 0 ? Icons.add_photo_alternate_outlined : Icons.add,
              size: i == 0 ? 24 : 18,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}

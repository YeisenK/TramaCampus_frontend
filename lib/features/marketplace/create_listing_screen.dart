import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/segmented_control.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../core/widgets/t_text_field.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/marketplace_listing.dart';
import '../../data/repositories/marketplace_repository.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  int _categoryIndex = 0;
  bool _isBoosted = false;
  bool _isLoading = false;

  static const _categories = [
    ListingCategory.apuntes,
    ListingCategory.servicios,
    ListingCategory.articulos,
    ListingCategory.freelance,
  ];
  static const _categoryLabels = [
    'Apuntes',
    'Servicios',
    'Artículos',
    'Freelance',
  ];

  @override
  void initState() {
    super.initState();
    // Check institutional email verification — always passes in mock
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkVerification());
  }

  void _checkVerification() {
    // In production: show a modal if user doesn't have @anahuac.mx verified.
    // Mock: all users are considered verified.
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    final listing = MarketplaceListing(
      id: 'new_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
      category: _categories[_categoryIndex],
      type: ListingType.studentListing,
      isBoosted: _isBoosted,
      isAffiliate: false,
      sellerName: MockData.currentUser.name,
      imageUrls: const [],
      publishedAt: DateTime.now(),
    );
    await MarketplaceRepository.instance.createListing(listing);
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Publicación creada con éxito')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const TAppBar(title: 'Nueva publicación'),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TTextField(
                controller: _titleCtrl,
                label: 'Título',
                hint: 'Ej. Apuntes de Cálculo II',
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Escribe un título'
                    : null,
              ),
              const SizedBox(height: AppSpacing.space4),
              TTextField(
                controller: _descCtrl,
                label: 'Descripción',
                hint: 'Describe tu producto o servicio...',
                maxLines: 4,
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Escribe una descripción'
                    : null,
              ),
              const SizedBox(height: AppSpacing.space4),
              TTextField(
                controller: _priceCtrl,
                label: 'Precio (MXN)',
                hint: '0',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un precio';
                  if (double.tryParse(v.trim()) == null)
                    return 'Precio inválido';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.space5),
              Text(
                'Categoría',
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space2),
              SegmentedControl(
                segments: _categoryLabels,
                selectedIndex: _categoryIndex,
                onChanged: (i) => setState(() => _categoryIndex = i),
              ),
              const SizedBox(height: AppSpacing.space5),
              Text(
                'Imágenes (máx. 4)',
                style: AppTextStyles.labelSm(cs.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.space2),
              const _ImagePickerRow(),
              const SizedBox(height: AppSpacing.space5),
              _BoostToggle(
                isBoosted: _isBoosted,
                onChanged: (v) => setState(() => _isBoosted = v),
              ),
              const SizedBox(height: AppSpacing.space6),
              TButton(
                label: 'Publicar',
                onPressed: _submit,
                isLoading: _isLoading,
                icon: Icons.check,
              ),
              const SizedBox(height: AppSpacing.space6),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImagePickerRow extends StatelessWidget {
  const _ImagePickerRow();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.space2),
        itemBuilder: (context, i) => Container(
          width: 100,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: cs.outlineVariant),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: cs.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}

class _BoostToggle extends StatelessWidget {
  const _BoostToggle({required this.isBoosted, required this.onChanged});

  final bool isBoosted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: isBoosted
            ? AppColors.primary.withValues(alpha: 0.07)
            : cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: isBoosted
              ? AppColors.primary.withValues(alpha: 0.4)
              : cs.outlineVariant,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Destacar publicación',
                      style: AppTextStyles.titleMd(cs.onSurface),
                    ),
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
                        'Boost',
                        style: AppTextStyles.labelSm(Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Próximamente gratuito en beta',
                  style: AppTextStyles.bodySm(cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Switch(
            value: isBoosted,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

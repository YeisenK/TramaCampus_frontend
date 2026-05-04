import 'package:flutter/material.dart';
import '../../core/navigation/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/t_app_bar.dart';
import '../../core/widgets/t_button.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/affiliate_business.dart';

class AffiliateDetailScreen extends StatelessWidget {
  const AffiliateDetailScreen({super.key, required this.business});

  final AffiliateBusiness business;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(title: business.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BusinessHeader(business: business),
            const SizedBox(height: AppSpacing.space5),
            if (business.description.isNotEmpty) ...[
              _SectionLabel('Descripción'),
              const SizedBox(height: AppSpacing.space2),
              Text(
                business.description,
                style: AppTextStyles.bodyMd(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.space5),
            ],
            if (business.promotions.isNotEmpty) ...[
              _SectionLabel('Promociones activas'),
              const SizedBox(height: AppSpacing.space2),
              ...business.promotions.map((p) => _PromotionRow(promotion: p)),
              const SizedBox(height: AppSpacing.space5),
            ],
            _ActionButtons(business: business),
            const SizedBox(height: AppSpacing.space6),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.titleMd(Theme.of(context).colorScheme.onSurface),
    );
  }
}

class _BusinessHeader extends StatelessWidget {
  const _BusinessHeader({required this.business});

  final AffiliateBusiness business;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.space4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: AppColors.ctaGradient(),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Icon(
              _iconFor(business.serviceType),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.space4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name,
                  style: AppTextStyles.headlineSm(cs.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  business.serviceType.label,
                  style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.space2),
                const Row(
                  children: [
                    Icon(Icons.verified, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Verificado por TramaCampus',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(AffiliateServiceType type) => switch (type) {
    AffiliateServiceType.restaurant => Icons.restaurant_outlined,
    AffiliateServiceType.gym => Icons.fitness_center_outlined,
    AffiliateServiceType.salon => Icons.content_cut_outlined,
    AffiliateServiceType.copyshop => Icons.print_outlined,
    AffiliateServiceType.laundry => Icons.local_laundry_service_outlined,
    AffiliateServiceType.tutoring => Icons.school_outlined,
    AffiliateServiceType.brand => Icons.star_outline,
    AffiliateServiceType.rental => Icons.home_outlined,
  };
}

class _PromotionRow extends StatelessWidget {
  const _PromotionRow({required this.promotion});

  final String promotion;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.local_offer_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: AppSpacing.space2),
          Expanded(
            child: Text(
              promotion,
              style: AppTextStyles.bodyMd(cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.business});

  final AffiliateBusiness business;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (business.serviceType == AffiliateServiceType.restaurant &&
            business.menuPdfUrl != null) ...[
          TButton(
            label: 'Ver menú',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Abriendo: ${business.menuPdfUrl}')),
            ),
            icon: Icons.menu_book_outlined,
            variant: TButtonVariant.secondary,
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
        if (business.acceptsReservations) ...[
          TButton(
            label: business.serviceType == AffiliateServiceType.restaurant
                ? 'Hacer reservación'
                : 'Agendar cita',
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRouter.reservation, arguments: business),
            icon: Icons.calendar_today_outlined,
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
        if (business.acceptsOrders) ...[
          TButton(
            label: 'Hacer pedido',
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Próximamente'))),
            icon: Icons.shopping_cart_outlined,
            variant: TButtonVariant.secondary,
          ),
          const SizedBox(height: AppSpacing.space3),
        ],
        TButton(
          label: 'Enviar mensaje directo',
          onPressed: () => Navigator.of(context).pushNamed(
            AppRouter.conversation,
            arguments: MockData.students.first,
          ),
          icon: Icons.chat_bubble_outline,
          variant: TButtonVariant.ghost,
        ),
      ],
    );
  }
}

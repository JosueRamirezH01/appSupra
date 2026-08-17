import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../data/models/search/search_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../utils/technician_display_name.dart';

class GlobalSearchSuggestionList extends StatelessWidget {
  const GlobalSearchSuggestionList({
    super.key,
    required this.query,
    required this.suggestions,
    required this.onSeeAll,
  });

  final String query;
  final SearchSuggestResult suggestions;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        _SeeAllTile(query: query, onTap: onSeeAll),
        if (suggestions.technicians.isNotEmpty) ...[
          const _SectionTitle('Profesionales'),
          ...suggestions.technicians.map(
            (technician) => _TechnicianSuggestionTile(technician: technician),
          ),
        ],
        if (suggestions.products.isNotEmpty) ...[
          const _SectionTitle('Materiales'),
          ...suggestions.products.map(
            (product) => _ProductSuggestionTile(product: product),
          ),
        ],
        if (suggestions.categories.isNotEmpty) ...[
          const _SectionTitle('Categorías del catálogo'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.categories.map((item) {
              final label = item.isSubcategory
                  ? item.name
                  : '${item.subcategoryName ?? item.name} · ${item.name}';
              return ActionChip(
                label: Text(label),
                onPressed: () {
                  final subcategoryId =
                      item.isSubcategory ? item.id : item.subcategoryId;
                  if (subcategoryId != null) {
                    context.push(
                      RoutePaths.productsBrowsePath(subcategoryId: subcategoryId),
                    );
                  }
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _SeeAllTile extends StatelessWidget {
  const _SeeAllTile({required this.query, required this.onTap});

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(
          Icons.search_rounded,
          color: AppBrandColors.primaryGreen,
        ),
        title: Text(
          'Ver todos los resultados para «$query»',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppBrandColors.textMuted,
        ),
      ),
    );
  }
}

class _TechnicianSuggestionTile extends StatelessWidget {
  const _TechnicianSuggestionTile({required this.technician});

  final TechnicianPublicModel technician;

  @override
  Widget build(BuildContext context) {
    final subtitle = technician.subcategories.isNotEmpty
        ? technician.subcategories.first.name
        : (technician.specialty ?? 'Profesional');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppBrandColors.fieldFill,
          child: const Icon(
            Icons.engineering_outlined,
            color: AppBrandColors.primaryGreen,
          ),
        ),
        title: Text(
          technician.publicDisplayName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        onTap: () => context.push(RoutePaths.technicianDetailPath(technician.id)),
      ),
    );
  }
}

class _ProductSuggestionTile extends StatelessWidget {
  const _ProductSuggestionTile({required this.product});

  final ProductPublicModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppBrandColors.fieldFill,
          child: const Icon(
            Icons.inventory_2_outlined,
            color: AppBrandColors.primaryGreen,
          ),
        ),
        title: Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(product.subcategoryName),
        onTap: () => context.push(
          RoutePaths.sellerCatalogPath(
            product.sellerId,
            currentProductId: product.id,
          ),
        ),
      ),
    );
  }
}

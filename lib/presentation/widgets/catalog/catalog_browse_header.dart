import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_browse_constants.dart';
import '../../../core/theme/app_colors.dart';

class CatalogBrowseHeader extends StatefulWidget {
  const CatalogBrowseHeader({
    super.key,
    required this.searchController,
    required this.searchHint,
    required this.onSearch,
    required this.subcategoriesSection,
    this.activeFiltersSection,
    this.searchMinLength = CatalogBrowseConstants.searchMinLength,
    this.title,
  });

  final TextEditingController searchController;
  final String searchHint;
  final ValueChanged<String> onSearch;
  final Widget subcategoriesSection;
  final Widget? activeFiltersSection;
  final int searchMinLength;
  final String? title;

  static const headerColor = Color(0xFF0B1C15);

  @override
  State<CatalogBrowseHeader> createState() => _CatalogBrowseHeaderState();
}

class _CatalogBrowseHeaderState extends State<CatalogBrowseHeader> {
  Timer? _debounce;
  String? _searchHintMessage;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.searchController.removeListener(_onQueryChanged);
    super.dispose();
  }

  void _onQueryChanged() {
    if (!mounted) return;
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: CatalogBrowseConstants.searchDebounceMs),
      () {
        if (!mounted) return;
        final query = widget.searchController.text.trim();
        if (query.isNotEmpty && query.length < widget.searchMinLength) {
          setState(() {
            _searchHintMessage =
                'Escribe al menos ${widget.searchMinLength} caracteres';
          });
          return;
        }
        setState(() => _searchHintMessage = null);
        widget.onSearch(query.isEmpty ? '' : query);
      },
    );
  }

  void _clearSearch() {
    widget.searchController.clear();
    setState(() => _searchHintMessage = null);
    widget.onSearch('');
  }

  void _submitSearch() {
    final query = widget.searchController.text.trim();
    if (query.isNotEmpty && query.length < widget.searchMinLength) {
      setState(() {
        _searchHintMessage =
            'Escribe al menos ${widget.searchMinLength} caracteres';
      });
      return;
    }
    setState(() => _searchHintMessage = null);
    widget.onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    final hasQuery = widget.searchController.text.trim().isNotEmpty;

    return Container(
      color: CatalogBrowseHeader.headerColor,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.searchController,
                        style: GoogleFonts.poppins(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: widget.searchHint,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppBrandColors.textMuted,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          isDense: true,
                        ),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _submitSearch(),
                      ),
                    ),
                    if (hasQuery)
                      IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppBrandColors.textMuted,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    Material(
                      color: AppBrandColors.primaryGreen,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: _submitSearch,
                        borderRadius: BorderRadius.circular(8),
                        child: const SizedBox(
                          width: 38,
                          height: 38,
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_searchHintMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  _searchHintMessage!,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            widget.subcategoriesSection,
            if (widget.activeFiltersSection != null) ...[
              const SizedBox(height: 8),
              widget.activeFiltersSection!,
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

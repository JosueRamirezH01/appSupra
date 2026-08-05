import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_browse_constants.dart';
import '../../../data/models/search/search_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/repository_providers.dart';
import '../../providers/search/global_search_provider.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/search/global_search_suggestion_list.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;
  String _debouncedQuery = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller
      ..removeListener(_onQueryChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: CatalogBrowseConstants.searchDebounceMs),
      () {
        if (!mounted) return;
        setState(() => _debouncedQuery = _controller.text.trim());
      },
    );
  }

  void _openResults([String? query]) {
    FocusScope.of(context).unfocus();
    final value = (query ?? _controller.text).trim();
    if (value.length < CatalogBrowseConstants.searchMinLength) return;
    context.push(RoutePaths.globalSearchResultsPath(value)).then((_) {
      if (!mounted) return;
      ref.invalidate(globalSearchBootstrapProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final query = _debouncedQuery;
    final hasQuery = query.length >= CatalogBrowseConstants.searchMinLength;
    final bootstrapAsync = ref.watch(globalSearchBootstrapProvider);
    final suggestionsAsync = hasQuery ? ref.watch(globalSearchSuggestionsProvider(query)) : null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7FAF4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: AppBrandColors.textDark,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: _openResults,
              style: GoogleFonts.poppins(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar profesionales y productos',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppBrandColors.textMuted,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppBrandColors.fieldFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _controller.clear();
                          setState(() => _debouncedQuery = '');
                        },
                        icon: const Icon(Icons.close_rounded, size: 20),
                      )
                    : null,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => _openResults(),
              icon: const Icon(Icons.search_rounded),
              color: AppBrandColors.primaryGreen,
            ),
          ],
        ),
        body: !hasQuery
            ? bootstrapAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorView(
                  error: error,
                  onRetry: () => ref.invalidate(globalSearchBootstrapProvider),
                ),
                data: (bootstrap) => _IdleSearchBody(
                  recent: bootstrap.recent,
                  popular: bootstrap.popular,
                  onTermTap: (term) {
                    _controller.text = term;
                    setState(() => _debouncedQuery = term);
                    _openResults(term);
                  },
                  onDeleteRecent: (historyId) async {
                    await ref.read(searchRepositoryProvider).deleteHistoryItem(historyId);
                    ref.invalidate(globalSearchBootstrapProvider);
                  },
                  onClearRecent: () async {
                    await ref.read(searchRepositoryProvider).clearHistory();
                    ref.invalidate(globalSearchBootstrapProvider);
                  },
                ),
              )
            : suggestionsAsync!.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No pudimos cargar sugerencias. Intenta de nuevo.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(color: AppBrandColors.textMuted),
                    ),
                  ),
                ),
                data: (suggestions) {
                  if (!suggestions.hasMatches) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sin coincidencias para «$query»',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AuthPrimaryButton(
                              label: 'Ver todos los resultados',
                              onPressed: () => _openResults(query),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GlobalSearchSuggestionList(
                    query: query,
                    suggestions: suggestions,
                    onSeeAll: () => _openResults(query),
                  );
                },
              ),
      ),
    );
  }
}

class _IdleSearchBody extends StatelessWidget {
  const _IdleSearchBody({
    required this.recent,
    required this.popular,
    required this.onTermTap,
    required this.onDeleteRecent,
    required this.onClearRecent,
  });

  final List<SearchHistoryItemModel> recent;
  final List<String> popular;
  final ValueChanged<String> onTermTap;
  final ValueChanged<int> onDeleteRecent;
  final VoidCallback onClearRecent;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      children: [
        Text(
          '¿Qué estás buscando?',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Escribe al menos ${CatalogBrowseConstants.searchMinLength} caracteres. '
          'Buscaremos en profesionales y materiales.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppBrandColors.textMuted,
            height: 1.4,
          ),
        ),
        if (recent.isNotEmpty) ...[
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tus búsquedas recientes',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              TextButton(onPressed: onClearRecent, child: const Text('Borrar')),
            ],
          ),
          const SizedBox(height: 8),
          ...recent.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.history_rounded),
                title: Text(item.term),
                trailing: IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18),
                  onPressed: () => onDeleteRecent(item.id),
                ),
                onTap: () => onTermTap(item.term),
              ),
            ),
          ),
        ],
        if (popular.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(
            'Búsquedas populares',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popular
                .map(
                  (term) => ActionChip(
                    label: Text(term),
                    onPressed: () => onTermTap(term),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

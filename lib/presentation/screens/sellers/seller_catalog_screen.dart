import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/my_seller_products_provider.dart';
import '../../providers/sellers/seller_catalog_provider.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../utils/seller_product_publish_status.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/home_media_image.dart';
import '../../widgets/products/product_grid_card.dart';
import '../../widgets/sellers/seller_catalog_header.dart';
import '../../widgets/sellers/seller_category_carousel_section.dart';
import '../../widgets/sellers/seller_contact_lead_sheet.dart';
import '../../widgets/sellers/seller_product_field_sheets.dart';
import '../../widgets/sellers/seller_store_info_sheet.dart';
import '../../widgets/sellers/seller_store_sticky_chrome.dart';

class SellerCatalogScreen extends ConsumerStatefulWidget {
  const SellerCatalogScreen({
    super.key,
    required this.sellerId,
    this.currentProductId,
  });

  final int sellerId;
  final int? currentProductId;

  @override
  ConsumerState<SellerCatalogScreen> createState() =>
      _SellerCatalogScreenState();
}

class _SellerCatalogScreenState extends ConsumerState<SellerCatalogScreen> {
  static const _heroHeight = 240.0;
  static const _heroOverlap = 48.0;

  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final _sectionKeys = <int, GlobalKey>{};
  final _chipKeys = <int, GlobalKey>{};
  List<_StoreCategorySection> _sections = const [];
  final _sectionOffsets = <int, double>{};
  String _searchQuery = '';
  int? _activeCategoryId;
  int? _uploadingProductId;
  bool _jumpingToCategory = false;
  bool _updatingLogo = false;
  bool _offsetCacheScheduled = false;
  double _bottomPad = 0;

  bool get _isOwner {
    final user = ref.read(authNotifierProvider).valueOrNull;
    return user != null && user.id == widget.sellerId;
  }

  bool get _searchMode =>
      _searchFocus.hasFocus || _searchQuery.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchFocus.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  double _pinHeight({required bool chipsVisible}) {
    return SellerStoreStickyChrome.pinHeightFor(
      context,
      chipsVisible: chipsVisible,
    );
  }

  bool _areChipsVisible(double offset) {
    if (_searchMode || _sections.length < 2) return false;
    final firstReveal = _sectionOffsets[_sections.first.id];
    if (firstReveal == null) return false;
    return offset + SellerStoreStickyChrome.compactHeightFor(context) >=
        firstReveal - 12;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 280) {
      ref.read(sellerCatalogControllerProvider(widget.sellerId).notifier).loadNextPage();
    }
    _collectSectionOffsets();
    if (_jumpingToCategory || _searchMode) return;

    final chipsVisible = _areChipsVisible(position.pixels);
    final spied = _spyCategory(
      offset: position.pixels,
      stickyHeight: _pinHeight(chipsVisible: chipsVisible),
    );
    if (spied != null && spied != _activeCategoryId) {
      setState(() => _activeCategoryId = spied);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ensureChipVisible(spied);
      });
    }
  }

  void _rememberSections(List<_StoreCategorySection> sections) {
    _sections = sections;
    for (final section in sections) {
      _sectionKeys.putIfAbsent(section.id, GlobalKey.new);
      _chipKeys.putIfAbsent(section.id, GlobalKey.new);
    }
    _scheduleOffsetCache();
  }

  void _scheduleOffsetCache() {
    if (_offsetCacheScheduled) return;
    _offsetCacheScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _offsetCacheScheduled = false;
      _cacheSectionOffsets();
    });
  }

  void _cacheSectionOffsets() {
    if (!mounted) return;
    _collectSectionOffsets();
    final pad = _computeBottomPad();
    if ((_bottomPad - pad).abs() < 1) return;
    setState(() => _bottomPad = pad);
  }

  void _collectSectionOffsets() {
    for (final section in _sections) {
      final offset = _sectionScrollOffset(_sectionKeys[section.id]);
      if (offset != null) {
        _sectionOffsets[section.id] = offset;
      }
    }
  }

  double _computeBottomPad() {
    if (!_scrollController.hasClients || _sections.isEmpty) return 0;
    final viewport = _scrollController.position.viewportDimension;
    if (viewport <= 0) return 0;
    final lastBox = _sectionKeys[_sections.last.id]
        ?.currentContext
        ?.findRenderObject();
    final lastHeight = lastBox is RenderBox && lastBox.hasSize
        ? lastBox.size.height
        : 280.0;
    return (viewport - _pinHeight(chipsVisible: _sections.length >= 2) - lastHeight)
        .clamp(0.0, viewport);
  }

  double? _sectionScrollOffset(GlobalKey? key) {
    if (key == null || !_scrollController.hasClients) return null;
    final sectionContext = key.currentContext;
    final viewportContext =
        _scrollController.position.context.notificationContext;
    if (sectionContext == null || viewportContext == null) return null;

    final sectionBox = sectionContext.findRenderObject();
    final viewportBox = viewportContext.findRenderObject();
    if (sectionBox is! RenderBox || viewportBox is! RenderBox) return null;
    if (!sectionBox.attached ||
        !viewportBox.attached ||
        !sectionBox.hasSize ||
        !viewportBox.hasSize) {
      return null;
    }

    final dy = sectionBox.localToGlobal(Offset.zero).dy -
        viewportBox.localToGlobal(Offset.zero).dy;
    return _scrollController.offset + dy;
  }

  int? _spyCategory({
    required double offset,
    required double stickyHeight,
  }) {
    if (_sections.isEmpty) return null;

    final pin = offset + stickyHeight;
    int? current;
    for (final section in _sections) {
      final start = _sectionOffsets[section.id];
      if (start == null) continue;
      if (start <= pin + 8) {
        current = section.id;
      }
    }
    return current ?? _sections.first.id;
  }

  void _ensureChipVisible(int id) {
    final context = _chipKeys[id]?.currentContext;
    if (context == null) return;
    Scrollable.ensureVisible(
      context,
      alignment: 0.45,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  Future<void> _jumpToCategory(int id) async {
    final key = _sectionKeys[id];
    if (key == null || !_scrollController.hasClients) return;

    setState(() {
      _activeCategoryId = id;
      _jumpingToCategory = true;
    });
    _ensureChipVisible(id);

    final reveal = _sectionOffsets[id] ?? _sectionScrollOffset(key);
    if (reveal != null) {
      final target = (reveal - _pinHeight(chipsVisible: _sections.length >= 2))
          .clamp(0.0, _scrollController.position.maxScrollExtent);
      await _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    }

    if (mounted) setState(() => _jumpingToCategory = false);
  }

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  void _onStoreBack() {
    if (_searchMode) {
      _searchController.clear();
      _searchFocus.unfocus();
      setState(() => _searchQuery = '');
      return;
    }
    context.pop();
  }

  List<ProductPublicModel> _productsMatching(List<ProductPublicModel> products) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return [
      for (final product in products)
        if (_productMatches(product, query)) product,
    ];
  }

  bool _productMatches(ProductPublicModel product, String query) {
    if (product.title.toLowerCase().contains(query)) return true;
    if (product.subcategoryName.toLowerCase().contains(query)) return true;
    final description = product.description?.toLowerCase();
    if (description != null && description.contains(query)) return true;
    for (final item in product.subSubCategories) {
      if (item.name.toLowerCase().contains(query)) return true;
    }
    return false;
  }

  SellerStoreStickyChrome _stickyChrome({
    required SellerPublicModel seller,
    required List<_StoreCategorySection> sections,
    required int? selectedCategoryId,
    required double barOpacity,
    required bool showCategories,
  }) {
    return SellerStoreStickyChrome(
      storeName: seller.businessName,
      searchController: _searchController,
      searchFocus: _searchFocus,
      onBack: _onStoreBack,
      onQueryChanged: _onSearchChanged,
      barOpacity: barOpacity,
      showCategories: showCategories,
      categories: [
        for (final section in sections) (id: section.id, name: section.name),
      ],
      selectedCategoryId: selectedCategoryId,
      onCategorySelected: _jumpToCategory,
      chipKeys: _chipKeys,
    );
  }

  Future<void> _openProduct(int productId) async {
    await context.push(RoutePaths.productDetailPath(productId));
    if (_isOwner && mounted) await _refreshOwnerCatalog();
  }

  Future<void> _refreshOwnerCatalog() async {
    ref.invalidate(mySellerProductsPreviewProvider);
    ref.invalidate(mySellerProductsControllerProvider);
    await ref.read(sellerCatalogControllerProvider(widget.sellerId).notifier).refresh();
  }

  bool get _sellerApproved {
    final application = ref.read(mySellerApplicationProvider).valueOrNull;
    if (application == null) return false;
    return application.verificationStatus == 'aprobado' || application.verified;
  }

  Future<void> _openNewProduct({int? subcategoryId}) async {
    var selectedSubcategoryId = subcategoryId;
    if (selectedSubcategoryId == null) {
      final items = await ref.read(sellerProductSubcategoriesProvider.future);
      if (!mounted) return;
      if (items.isEmpty) {
        showErrorSnackBar(context, 'Aún no hay rubros disponibles');
        return;
      }
      selectedSubcategoryId = await showSubcategoryPickSheet(context, items: items);
      if (selectedSubcategoryId == null || !mounted) return;
    }

    HapticFeedback.selectionClick();
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;

    final name = await showProductNameSheet(context);
    if (name == null || !mounted) return;

    await _createProduct(
      subcategoryId: selectedSubcategoryId,
      photo: file,
      name: name,
    );
  }

  Future<void> _createProduct({
    required int subcategoryId,
    required File photo,
    required String name,
  }) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(22),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );

    try {
      final urls = await MediaUploadUtils.uploadTechnicianReferences(
        repository: ref.read(uploadsRepositoryProvider),
        category: UploadCategory.productImage,
        files: [photo],
      );
      await ref.read(sellersRepositoryProvider).createProduct(
            CreateProductRequest(
              subcategoryId: subcategoryId,
              title: name.trim(),
              subSubCategoryIds: const [],
              offerings: const [],
              status: sellerProductApiStatus(
                published: true,
                sellerApproved: _sellerApproved,
              ),
              imageUrls: urls,
            ),
          );
      ref.invalidate(mySellerApplicationProvider);
      ref.invalidate(productsListProvider);
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      await _refreshOwnerCatalog();
      if (!mounted) return;
      _jumpToCategory(subcategoryId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _sellerApproved
                      ? 'Producto publicado en tu vitrina'
                      : 'Guardado. Se publicará cuando tu tienda esté aprobada',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppBrandColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        showErrorSnackBar(context, error);
      }
    }
  }

  Future<void> _editProductPhoto(ProductPublicModel product) async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;
    setState(() => _uploadingProductId = product.id);
    try {
      final uploaded = await MediaUploadUtils.uploadTechnicianReferences(
        repository: ref.read(uploadsRepositoryProvider),
        category: UploadCategory.productImage,
        files: [file],
      );
      final rest = product.images.skip(1).map((e) => e.imageUrl);
      await ref.read(sellersRepositoryProvider).updateProduct(
            product.id,
            UpdateProductRequest(
              imageUrls: [uploaded.first, ...rest],
            ),
          );
      ref.invalidate(productDetailProvider(product.id));
      await _refreshOwnerCatalog();
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _uploadingProductId = null);
    }
  }

  Future<void> _editProductName(ProductPublicModel product) async {
    final name = await showProductNameSheet(context, initialName: product.title);
    if (name == null || !mounted) return;
    try {
      await ref.read(sellersRepositoryProvider).updateProduct(
            product.id,
            UpdateProductRequest(title: name),
          );
      ref.invalidate(productDetailProvider(product.id));
      await _refreshOwnerCatalog();
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    }
  }

  Future<void> _editProductPrice(ProductPublicModel product) async {
    final result = await showProductPriceSheet(
      context,
      initialPrice: product.price,
      initialCompareAt: product.compareAtPrice,
    );
    if (result == null || !mounted) return;
    try {
      await ref.read(sellersRepositoryProvider).updateProduct(
            product.id,
            UpdateProductRequest(
              price: result.price,
              compareAtPrice: result.compareAt,
              setPricing: true,
            ),
          );
      ref.invalidate(productDetailProvider(product.id));
      await _refreshOwnerCatalog();
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    }
  }

  Future<void> _openContact({required SellerPublicModel seller, required SellerContactLeadMode mode}) async {
    try {
      await SellerContactLeadSheet.show(
        context: context,
        mode: mode,
        sellerUserId: seller.id,
        sellerName: seller.businessName,
        sellerPhone: seller.phone,
      );
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    }
  }

  Future<void> _openSellerInfo(SellerPublicModel seller) {
    final isOwner = _isOwner;
    return showSellerStoreInfoSheet(
      context,
      seller: seller,
      canEdit: isOwner,
      onSaveBusinessName: isOwner ? (name) async {
        await ref.read(sellersRepositoryProvider).updateProfile(UpdateSellerProfileRequest(businessName: name));
        await _refreshOwnerStore();
        await ref.read(authNotifierProvider.notifier).refreshProfile();
      } : null,
      onSaveDescription: isOwner ? (description) async {
        await ref.read(sellersRepositoryProvider).updateProfile(UpdateSellerProfileRequest(description: description));
        await _refreshOwnerStore();
      } : null,
      onEditLocation: isOwner ? _openLocation : null,
    );
  }

  Future<void> _refreshOwnerStore() async {
    ref.invalidate(sellerPublicProfileProvider(widget.sellerId));
    ref.invalidate(mySellerApplicationProvider);
    await ref.read(sellerPublicProfileProvider(widget.sellerId).future);
  }

  Future<void> _openOwnerRoute(String path) async {
    await context.push(path);
    if (!mounted) return;
    await _refreshOwnerStore();
  }

  Future<void> _openCover() => _openOwnerRoute(RoutePaths.sellerCover);

  Future<void> _openLocation() async {
    final application = ref.read(mySellerApplicationProvider).valueOrNull;
    if (application?.canSubmitVerification == true) {
      await _openOwnerRoute(RoutePaths.sellerVerification);
      return;
    }
    await _openOwnerRoute(RoutePaths.sellerLocation);
  }

  Future<void> _editLogo() async {
    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file == null || !mounted) return;

    setState(() => _updatingLogo = true);
    try {
      final urls = await MediaUploadUtils.uploadMixedReferences(
        repository: ref.read(uploadsRepositoryProvider),
        tasks: [
          MediaUploadTaskItem(
            file: file,
            category: UploadCategory.companyLogo,
          ),
        ],
      );
      await ref.read(sellersRepositoryProvider).updateProfile(UpdateSellerProfileRequest(logoUrl: urls.first));
      await _refreshOwnerStore();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Logo actualizado',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _updatingLogo = false);
    }
  }

  SellerCatalogHeader _headerFor(SellerPublicModel seller, {List<String> categoryLabels = const []}) {
    final isOwner = _isOwner;
    return SellerCatalogHeader(
      seller: seller,
      categoryLabels: categoryLabels,
      updatingLogo: _updatingLogo,
      onCall: isOwner ? null : () => _openContact(
        seller: seller,
        mode: SellerContactLeadMode.phone,
      ),
      onWhatsApp: isOwner ? null : () => _openContact(
        seller: seller,
        mode: SellerContactLeadMode.whatsApp,
      ),
      onInfoTap: () => _openSellerInfo(seller),
      onEditLogo: isOwner ? _editLogo : null,
    );
  }

  List<_StoreCategorySection> _sectionsFor(List<ProductPublicModel> products) {
    final byId = <int, List<ProductPublicModel>>{};
    final names = <int, String>{};

    for (final product in products) {
      if (product.subcategoryId <= 0) continue;
      byId.putIfAbsent(product.subcategoryId, () => []).add(product);
      final name = product.subcategoryName.trim();
      names[product.subcategoryId] = name.isEmpty ? 'Categoría' : name;
    }

    int? firstCategoryId;
    final highlightedId = widget.currentProductId;
    if (highlightedId != null) {
      for (final product in products) {
        if (product.id == highlightedId) {
          firstCategoryId = product.subcategoryId;
          break;
        }
      }
    }

    final ids = byId.keys.toList()
      ..sort((left, right) {
        if (left == firstCategoryId) return -1;
        if (right == firstCategoryId) return 1;
        return (names[left] ?? '').toLowerCase().compareTo(
              (names[right] ?? '').toLowerCase(),
            );
      });

    return [
      for (final id in ids)
        _StoreCategorySection(
          id: id,
          name: names[id] ?? 'Categoría',
          products: _orderedProducts(byId[id]!, highlightedId),
        ),
    ];
  }

  List<ProductPublicModel> _orderedProducts(List<ProductPublicModel> products, int? highlightedId,) {
    if (highlightedId == null) return products;
    final copy = [...products];
    copy.sort((left, right) {
      if (left.id == highlightedId) return -1;
      if (right.id == highlightedId) return 1;
      return 0;
    });
    return copy;
  }

  String? _heroImageUrl({required SellerPublicModel seller, ProductPublicModel? highlighted}) {
    final cover = seller.coverUrl?.trim();
    if (cover != null && cover.isNotEmpty) return cover;
    if (widget.currentProductId == null) return null;
    final fromHighlight = highlighted?.primaryImageUrl?.trim();
    if (fromHighlight != null && fromHighlight.isNotEmpty) {
      return fromHighlight;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isOwner = ref.watch(authNotifierProvider).valueOrNull?.id == widget.sellerId;
    if (isOwner) {
      ref.watch(mySellerApplicationProvider);
      ref.watch(sellerProductSubcategoriesProvider);
    }
    final sellerAsync = ref.watch(sellerPublicProfileProvider(widget.sellerId));
    final catalogAsync = ref.watch(sellerCatalogControllerProvider(widget.sellerId));
    final highlightedAsync = widget.currentProductId == null ? null : ref.watch(productDetailProvider(widget.currentProductId!));

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      body: sellerAsync.when(
        loading: () => const LoadingView(message: 'Cargando vendedor...'),
        error: (error, _) => SafeArea(
          child: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(sellerPublicProfileProvider(widget.sellerId)),
          ),
        ),
        data: (seller) {
          return catalogAsync.when(
            loading: () => _StoreScaffold(
              heroHeight: _heroHeight,
              overlap: _heroOverlap,
              heroImageUrl: _heroImageUrl(
                seller: seller,
                highlighted: highlightedAsync?.asData?.value,
              ),
              onBack: () => context.pop(),
              onEditCover: isOwner ? _openCover : null,
              isOwner: isOwner,
              header: _headerFor(seller),
              body: const Padding(
                padding: EdgeInsets.only(top: 48),
                child: LoadingView(message: 'Cargando catálogo...'),
              ),
            ),
            error: (error, _) => _StoreScaffold(
              heroHeight: _heroHeight,
              overlap: _heroOverlap,
              heroImageUrl: _heroImageUrl(
                seller: seller,
                highlighted: highlightedAsync?.asData?.value,
              ),
              onBack: () => context.pop(),
              onEditCover: isOwner ? _openCover : null,
              isOwner: isOwner,
              header: _headerFor(seller),
              body: ErrorView(
                error: error,
                onRetry: () => ref.invalidate(sellerCatalogControllerProvider(widget.sellerId)),
              ),
            ),
            data: (catalog) {
              final highlightedFromCatalog = () {
                final id = widget.currentProductId;
                if (id == null) return null;
                for (final item in catalog.products) {
                  if (item.id == id) return item;
                }
                return null;
              }();
              final highlighted = highlightedAsync?.asData?.value ?? highlightedFromCatalog;
              final sections = _sectionsFor(catalog.products);
              final categoryLabels = [
                for (final section in sections) section.name,
              ];
              final header = _headerFor(
                seller,
                categoryLabels: categoryLabels,
              );

              _rememberSections(sections);
              final selectedCategoryId =
                  _activeCategoryId ?? (sections.isEmpty ? null : sections.first.id);

              if (catalog.products.isEmpty) {
                return _StoreScaffold(
                  heroHeight: _heroHeight,
                  overlap: _heroOverlap,
                  heroImageUrl: _heroImageUrl(
                    seller: seller,
                    highlighted: highlighted,
                  ),
                  onBack: () => context.pop(),
                  onEditCover: isOwner ? _openCover : null,
                  isOwner: isOwner,
                  header: header,
                  body: isOwner
                      ? _OwnerEmptyCatalog(
                          onAdd: () => _openNewProduct(),
                          onViewDrafts: () => context.push(RoutePaths.sellerProducts),
                          onRefresh: _refreshOwnerCatalog,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(top: 32),
                          child: EmptyView(
                            message: 'Este vendedor aún no tiene productos publicados.',
                          ),
                        ),
                );
              }

              return Stack(
                children: [
                  RefreshIndicator(
                    color: AppBrandColors.primaryGreen,
                    onRefresh: () async {
                      if (isOwner) {
                        ref.invalidate(sellerPublicProfileProvider(widget.sellerId));
                      }
                      await ref.read(sellerCatalogControllerProvider(widget.sellerId).notifier).refresh();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      clipBehavior: Clip.none,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: _StoreHeroBlock(
                            heroHeight: _heroHeight,
                            overlap: _heroOverlap,
                            imageUrl: _heroImageUrl(
                              seller: seller,
                              highlighted: highlighted,
                            ),
                            onBack: () => context.pop(),
                            onEditCover: isOwner ? _openCover : null,
                            isOwner: isOwner,
                            header: header,
                          ),
                        ),
                        for (final section in sections)
                          SliverToBoxAdapter(
                            child: SellerCategoryCarouselSection(
                              key: _sectionKeys[section.id],
                              title: section.name,
                              products: section.products,
                              highlightedProductId: widget.currentProductId,
                              onProductTap: _openProduct,
                              onAdd: isOwner
                                  ? () => _openNewProduct(subcategoryId: section.id)
                                  : null,
                              onEditPhoto: isOwner ? _editProductPhoto : null,
                              onEditName: isOwner ? _editProductName : null,
                              onEditPrice: isOwner ? _editProductPrice : null,
                              uploadingProductId: isOwner ? _uploadingProductId : null,
                            ),
                          ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (isOwner) _AddAnotherCategoryCta(onTap: () => _openNewProduct()),
                              if (catalog.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 8),
                                  child: Center(
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                        if (_bottomPad > 0)
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: _bottomPad,
                              child: const DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Color(0xFFE8ECE9)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: _searchMode ? 0 : null,
                    child: AnimatedBuilder(
                      animation: _scrollController,
                      builder: (context, _) {
                        final offset = _scrollController.hasClients
                            ? _scrollController.offset
                            : 0.0;
                        final compactOpacity = _searchMode
                            ? 1.0
                            : ((offset - 56) / 90).clamp(0.0, 1.0);
                        final showChips = _areChipsVisible(offset);

                        return Column(
                          mainAxisSize: _searchMode
                              ? MainAxisSize.max
                              : MainAxisSize.min,
                          children: [
                            _stickyChrome(
                              seller: seller,
                              sections: sections,
                              selectedCategoryId: selectedCategoryId,
                              barOpacity: compactOpacity,
                              showCategories: showChips,
                            ),
                            if (_searchMode)
                              Expanded(
                                child: ColoredBox(
                                  color: AppBrandColors.scaffoldBackground,
                                  child: _StoreSearchResults(
                                    query: _searchQuery,
                                    products: _productsMatching(catalog.products),
                                    onProductTap: _openProduct,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _StoreCategorySection {
  const _StoreCategorySection({
    required this.id,
    required this.name,
    required this.products,
  });

  final int id;
  final String name;
  final List<ProductPublicModel> products;
}

class _StoreSearchResults extends StatelessWidget {
  const _StoreSearchResults({
    required this.query,
    required this.products,
    required this.onProductTap,
  });

  final String query;
  final List<ProductPublicModel> products;
  final ValueChanged<int> onProductTap;

  @override
  Widget build(BuildContext context) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'Busca un material de esta tienda',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppBrandColors.textMuted,
            ),
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No encontramos “$trimmed” en esta tienda',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppBrandColors.textMuted,
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: ProductGridCard.gridAspectRatio(showSellerInfo: false),
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductGridCard(
          product: product,
          showSellerInfo: false,
          onTap: () => onProductTap(product.id),
        );
      },
    );
  }
}

class _OwnerEmptyCatalog extends StatelessWidget {
  const _OwnerEmptyCatalog({
    required this.onAdd,
    required this.onViewDrafts,
    required this.onRefresh,
  });

  final VoidCallback onAdd;
  final VoidCallback onViewDrafts;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppBrandColors.primaryGreen,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8ECE9)),
            ),
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart_rounded,
                    size: 30,
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tu vitrina está vacía',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toca Agregar: saca una foto y ponle nombre. El producto entra al anaquel; el precio y más fotos los completas después en la ficha.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.45,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onAdd,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      'Agregar primer producto',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppBrandColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onViewDrafts,
                  child: Text(
                    'Ver borradores en Mis productos',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddAnotherCategoryCta extends StatelessWidget {
  const _AddAnotherCategoryCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: Text(
          'Agregar en otra categoría',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppBrandColors.primaryGreen,
          side: BorderSide(
            color: AppBrandColors.primaryGreen.withValues(alpha: 0.4),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _StoreScaffold extends StatelessWidget {
  const _StoreScaffold({
    required this.heroHeight,
    required this.overlap,
    required this.onBack,
    required this.header,
    required this.body,
    this.heroImageUrl,
    this.onEditCover,
    this.isOwner = false,
  });

  final double heroHeight;
  final double overlap;
  final VoidCallback onBack;
  final Widget header;
  final Widget body;
  final String? heroImageUrl;
  final VoidCallback? onEditCover;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StoreHeroBlock(
          heroHeight: heroHeight,
          overlap: overlap,
          imageUrl: heroImageUrl,
          onBack: onBack,
          onEditCover: onEditCover,
          isOwner: isOwner,
          header: header,
        ),
        Expanded(child: body),
      ],
    );
  }
}

class _StoreHeroBlock extends StatelessWidget {
  const _StoreHeroBlock({
    required this.heroHeight,
    required this.overlap,
    required this.onBack,
    required this.header,
    this.imageUrl,
    this.onEditCover,
    this.isOwner = false,
  });

  final double heroHeight;
  final double overlap;
  final VoidCallback onBack;
  final Widget header;
  final String? imageUrl;
  final VoidCallback? onEditCover;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: heroHeight - overlap,
          width: double.infinity,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: heroHeight,
                child: _StoreHero(
                  height: heroHeight,
                  imageUrl: imageUrl,
                  onBack: onBack,
                  onEditCover: onEditCover,
                  isOwner: isOwner,
                ),
              ),
            ],
          ),
        ),
        header,
      ],
    );
  }
}

class _StoreHero extends StatelessWidget {
  const _StoreHero({
    required this.height,
    required this.onBack,
    this.imageUrl,
    this.onEditCover,
    this.isOwner = false,
  });

  final double height;
  final VoidCallback onBack;
  final String? imageUrl;
  final VoidCallback? onEditCover;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: onEditCover,
            child: HomeMediaImage.heroBackground(
              context: context,
              imageUrl: imageUrl,
              height: height,
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x00000000),
                  Color(0x33000000),
                ],
                stops: [0, 0.45, 1],
              ),
            ),
          ),
          Positioned(
            top: top + 8,
            left: 12,
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onBack,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
            ),
          ),
          if (isOwner)
            Positioned(
              top: top + 14,
              left: 64,
              right: onEditCover == null ? 16 : 64,
              child: Text(
                'Así te ven los clientes. Toca para editar.',
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: const [
                    Shadow(color: Color(0x88000000), blurRadius: 8),
                  ],
                ),
              ),
            ),
          if (onEditCover != null)
            Positioned(
              top: top + 8,
              right: 12,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onEditCover,
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 20,
                      color: AppBrandColors.textDark,
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/product_sale_unit.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/media_upload_utils.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../data/models/sellers/seller_product_subcategory_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../../routes/route_paths.dart';
import '../../models/seller_product_preview_model.dart';
import '../../providers/products/home_featured_products_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/my_seller_products_provider.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../utils/seller_product_publish_status.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/home_media_image.dart';
import '../../widgets/sellers/product_referential_pricing_fields.dart';
import '../../widgets/sellers/seller_product_field_sheets.dart';
import '../../widgets/sellers/seller_product_publish_selector.dart';
import '../../widgets/sellers/seller_product_starred_selector.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/upload_progress_overlay.dart';

class SellerProductFormScreen extends ConsumerStatefulWidget {
  const SellerProductFormScreen({
    super.key,
    this.productId,
    this.initialSubcategoryId,
  });

  final int? productId;
  final int? initialSubcategoryId;

  bool get isEditing => productId != null;

  @override
  ConsumerState<SellerProductFormScreen> createState() =>
      _SellerProductFormScreenState();
}

class _SellerProductFormScreenState
    extends ConsumerState<SellerProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _compareAtController = TextEditingController();
  bool _showCompareAt = false;
  String? _saleUnit;

  final List<String> _existingImageUrls = [];
  final List<File> _newImages = [];

  SellerProductSubcategoryModel? _selectedSubcategory;
  bool _isPublished = false;
  bool _isStarred = false;
  int _starredCount = 0;
  bool _sellerApproved = false;
  String _sellerBusinessName = '';
  String? _sellerLogoUrl;
  bool _sellerVerified = false;
  bool _loading = true;
  bool _submitting = false;
  int _uploadCompleted = 0;
  int _uploadTotal = 0;

  static const _maxImages = 6;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onTitleChanged);
    _bootstrap();
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _compareAtController.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _bootstrap() async {
    try {
      final application = await ref.read(sellersRepositoryProvider).getMyApplication();
      final approved = application.verificationStatus == 'aprobado' || application.verified;

      ProductPublicModel? product;
      if (widget.isEditing) {
        product = await ref
            .read(sellersRepositoryProvider)
            .getMyProduct(widget.productId!);
        _descriptionController.text = product.description ?? '';
        if (product.price != null) {
          _priceController.text = product.price! % 1 == 0
              ? product.price!.toInt().toString()
              : product.price!.toStringAsFixed(2);
          _saleUnit =
              normalizeProductSaleUnit(product.saleUnit) ??
              kDefaultProductSaleUnit;
        }
        if (product.compareAtPrice != null) {
          _showCompareAt = true;
          _compareAtController.text = product.compareAtPrice! % 1 == 0
              ? product.compareAtPrice!.toInt().toString()
              : product.compareAtPrice!.toStringAsFixed(2);
        }
        _existingImageUrls.addAll(product.images.map((e) => e.imageUrl));
        _isPublished = sellerProductPublishedFromApi(product.status);
        _isStarred = product.isStarred;
        _titleController.text = product.title;
      }

      final myProducts = await ref.read(sellersRepositoryProvider).listMyProducts(
            const MyProductsQuery(page: 1, limit: 1),
          );
      _starredCount = myProducts.counts.starred;

      final subcategories = await ref.read(
        sellerProductSubcategoriesProvider.future,
      );
      SellerProductSubcategoryModel? selected;
      if (product != null) {
        for (final item in subcategories) {
          if (item.id == product.subcategoryId) {
            selected = item;
            break;
          }
        }
      } else if (widget.initialSubcategoryId != null) {
        for (final item in subcategories) {
          if (item.id == widget.initialSubcategoryId) {
            selected = item;
            break;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _sellerApproved = approved;
        _sellerBusinessName = application.businessName;
        _sellerLogoUrl = application.logoUrl;
        _sellerVerified = application.verified;
        _selectedSubcategory = selected;
        if (!_sellerApproved) {
          _isPublished = false;
        }
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      showErrorSnackBar(context, e);
    }
  }

  int get _totalImages => _existingImageUrls.length + _newImages.length;

  Future<void> _pickImages() async {
    if (_totalImages >= _maxImages) {
      showErrorSnackBar(context, 'Máximo $_maxImages imágenes por producto');
      return;
    }

    final file = await ImagePickerUtils.pickPublicCatalogImage(context);
    if (file != null) {
      setState(() => _newImages.add(file));
    }
  }

  void _removeExistingImage(int index) {
    setState(() => _existingImageUrls.removeAt(index));
  }

  void _removeNewImage(int index) {
    setState(() => _newImages.removeAt(index));
  }

  SellerProductPreviewModel _buildPreviewModel() {
    final description = _descriptionController.text.trim();

    return SellerProductPreviewModel(
      title: _titleController.text.trim(),
      subcategoryName: _selectedSubcategory?.name ?? 'Subcategoría',
      description: description.isEmpty ? null : description,
      price: parseProductMoney(_priceController.text),
      compareAtPrice:
          _showCompareAt ? parseProductMoney(_compareAtController.text) : null,
      saleUnit: parseProductMoney(_priceController.text) == null
          ? null
          : (normalizeProductSaleUnit(_saleUnit) ?? kDefaultProductSaleUnit),
      materialLabels: const [],
      images: [
        ..._existingImageUrls.map(SellerProductPreviewImage.network),
        ..._newImages.map(SellerProductPreviewImage.local),
      ],
      sellerBusinessName: _sellerBusinessName.isEmpty
          ? 'Tu negocio'
          : _sellerBusinessName,
      sellerLogoUrl: _sellerLogoUrl,
      sellerVerified: _sellerVerified,
    );
  }

  void _openClientPreview() {
    context.push(RoutePaths.sellerProductPreview, extra: _buildPreviewModel());
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSubcategory == null) {
      showErrorSnackBar(context, 'Selecciona una subcategoría');
      return;
    }

    if (_totalImages == 0) {
      showErrorSnackBar(context, 'Agrega al menos una imagen');
      return;
    }

    if (_isPublished && !_sellerApproved) {
      showErrorSnackBar(
        context,
        'Verifica tu negocio antes de publicar productos',
      );
      return;
    }

    final apiStatus = sellerProductApiStatus(
      published: _isPublished,
      sellerApproved: _sellerApproved,
    );

    final productTitle = _titleController.text.trim();

    setState(() {
      _submitting = true;
      _uploadCompleted = 0;
      _uploadTotal = _newImages.length;
    });

    try {
      final uploadsRepo = ref.read(uploadsRepositoryProvider);
      final sellersRepo = ref.read(sellersRepositoryProvider);

      final uploadedUrls = _newImages.isEmpty
          ? <String>[]
          : await MediaUploadUtils.uploadTechnicianReferences(
              repository: uploadsRepo,
              category: UploadCategory.productImage,
              files: _newImages,
              onProgress: (completed, total) {
                if (!mounted) return;
                setState(() {
                  _uploadCompleted = completed;
                  _uploadTotal = total;
                });
              },
            );

      final imageUrls = [..._existingImageUrls, ...uploadedUrls];
      final price = parseProductMoney(_priceController.text);
      final compareAtPrice =
          _showCompareAt ? parseProductMoney(_compareAtController.text) : null;
      final saleUnit = price == null
          ? null
          : (normalizeProductSaleUnit(_saleUnit) ?? kDefaultProductSaleUnit);

      if (widget.isEditing) {
        await sellersRepo.updateProduct(
          widget.productId!,
          UpdateProductRequest(
            subcategoryId: _selectedSubcategory!.id,
            title: productTitle,
            description: _descriptionController.text.trim(),
            price: price,
            compareAtPrice: compareAtPrice,
            saleUnit: saleUnit,
            subSubCategoryIds: const [],
            offerings: const [],
            status: apiStatus,
            imageUrls: imageUrls,
            setPricing: true,
            isStarred: _isStarred,
          ),
        );
      } else {
        await sellersRepo.createProduct(
          CreateProductRequest(
            subcategoryId: _selectedSubcategory!.id,
            title: productTitle,
            description: _descriptionController.text.trim(),
            price: price,
            compareAtPrice: compareAtPrice,
            saleUnit: saleUnit,
            subSubCategoryIds: const [],
            offerings: const [],
            status: apiStatus,
            imageUrls: imageUrls,
            isStarred: _isStarred,
          ),
        );
      }

      ref.invalidate(mySellerApplicationProvider);
      ref.invalidate(mySellerProductsPreviewProvider);
      ref.invalidate(mySellerProductsControllerProvider);
      ref.invalidate(productsListProvider);
      ref.invalidate(homeFeaturedProductsProvider);
      if (widget.productId case final productId?) {
        ref.invalidate(productDetailProvider(productId));
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing ? 'Producto actualizado' : 'Producto creado',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: TechnicianPanelColors.primary,
        ),
      );
      context.pop();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) {
        setState(() {
          _submitting = false;
          _uploadCompleted = 0;
          _uploadTotal = 0;
        });
      }
    }
  }

  Widget _buildImageGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (var i = 0; i < _existingImageUrls.length; i++)
          _ImageTile(
            imageUrl: _existingImageUrls[i],
            onRemove: () => _removeExistingImage(i),
          ),
        for (var i = 0; i < _newImages.length; i++)
          _ImageTile(file: _newImages[i], onRemove: () => _removeNewImage(i)),
        if (_totalImages < _maxImages) _AddImageTile(onTap: _pickImages),
      ],
    );
  }

  Widget _buildPublishSelector() {
    return SellerProductPublishSelector(
      isPublished: _isPublished,
      sellerApproved: _sellerApproved,
      enabled: !_submitting,
      onChanged: (value) => setState(() => _isPublished = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: TechnicianPanelColors.background,
        body: LoadingView(message: 'Cargando producto...'),
      );
    }

    final subcategories = ref.watch(sellerProductSubcategoriesProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          TechnicianPanelScaffold(
            title: widget.isEditing ? 'Editar catálogo' : 'Agregar al catálogo',
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded , size: 18),
              onPressed: _submitting ? null : () => context.pop(),
            ),
            actions: [
              TextButton.icon(
                onPressed: _submitting ? null : _openClientPreview,
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text('Vista cliente', style: TextStyle(fontSize: 12),),
              ),
            ],
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  TechnicianPanelCard(
                    child: Text(
                      'Elige el rubro y escribe el nombre como lo vende tu negocio. Así lo verá el cliente en la vitrina.',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: const Color(0xFF4B5563),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  subcategories.when(
                    loading: () => const LoadingView(),
                    error: (e, _) => ErrorView(
                      error: e,
                      onRetry: () =>
                          ref.invalidate(sellerProductSubcategoriesProvider),
                    ),
                    data: (items) {
                      return FormField<int>(
                        key: ValueKey<int?>(_selectedSubcategory?.id),
                        initialValue: _selectedSubcategory?.id,
                        validator: (value) => value == null
                            ? 'Selecciona una subcategoría'
                            : null,
                        builder: (field) {
                          Future<void> openPicker() async {
                            if (_submitting) return;
                            final pickedId = await showSubcategoryPickSheet(
                              context,
                              items: items,
                              onCreateCustom: (name) async {
                                final created = await ref
                                    .read(sellersRepositoryProvider)
                                    .createMyProductSubcategory(name);
                                ref.invalidate(
                                  sellerProductSubcategoriesProvider,
                                );
                                return created;
                              },
                            );
                            if (pickedId == null || !mounted) return;

                            var nextItems = items;
                            SellerProductSubcategoryModel? picked;
                            for (final item in nextItems) {
                              if (item.id == pickedId) {
                                picked = item;
                                break;
                              }
                            }
                            if (picked == null) {
                              nextItems = await ref.read(
                                sellerProductSubcategoriesProvider.future,
                              );
                              for (final item in nextItems) {
                                if (item.id == pickedId) {
                                  picked = item;
                                  break;
                                }
                              }
                            }
                            if (picked == null) return;
                            field.didChange(picked.id);
                            setState(() => _selectedSubcategory = picked);
                          }

                          final hasError = field.hasError;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Material(
                                color: _submitting
                                    ? AppBrandColors.inputFill
                                        .withValues(alpha: 0.6)
                                    : AppBrandColors.inputFill,
                                borderRadius: BorderRadius.circular(14),
                                child: InkWell(
                                  onTap: _submitting ? null : openPicker,
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      12,
                                      12,
                                      12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: hasError
                                            ? Colors.redAccent
                                            : AppBrandColors.inputBorder,
                                        width: hasError ? 1.8 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.category_outlined,
                                          size: 20,
                                          color: _submitting
                                              ? AppBrandColors.textMuted
                                              : AppBrandColors.primaryGreen,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Subcategoría *',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      AppBrandColors.textMuted,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                _selectedSubcategory?.name ??
                                                    'Elegir subcategoría',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: _selectedSubcategory ==
                                                          null
                                                      ? AppBrandColors
                                                          .textMuted
                                                      : AppBrandColors
                                                          .textDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppBrandColors.textMuted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _selectedSubcategory?.isSellerOwned == true
                                    ? 'Rubro propio: solo tú lo usas al publicar.'
                                    : 'Rubro del catálogo o crea el tuyo si no está.',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFF6B7280),
                                ),
                              ),
                              if (hasError) ...[
                                const SizedBox(height: 6),
                                Text(
                                  field.errorText!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  AuthRoundedField(
                    controller: _titleController,
                    label: 'Nombre del producto *',
                    maxLength: 150,
                    validator: (value) {
                      final title = value?.trim() ?? '';
                      if (title.length < 3) {
                        return 'Escribe un nombre de al menos 3 caracteres';
                      }
                      return null;
                    },
                  ),
                  ProductNameSuggestionChips(
                    suggestions: _selectedSubcategory?.suggestions ?? const [],
                    currentName: _titleController.text,
                    onSelected: (value) {
                      setState(() {
                        _titleController.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(offset: value.length),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _selectedSubcategory?.suggestions.isNotEmpty == true
                        ? 'Puedes usar una sugerencia o escribir el nombre como lo vende tu negocio.'
                        : 'Ejemplo: Cemento Holcim 50 kg, Ladrillo tipo 4.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AuthRoundedField(
                    controller: _descriptionController,
                    label: 'Descripción',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                  ProductReferentialPricingFields(
                    priceController: _priceController,
                    compareAtController: _compareAtController,
                    showCompareAt: _showCompareAt,
                    saleUnit: _saleUnit,
                    enabled: !_submitting,
                    onSaleUnitChanged: (value) {
                      setState(() => _saleUnit = value);
                    },
                    onShowCompareAtChanged: (value) {
                      setState(() {
                        _showCompareAt = value;
                        if (!value) _compareAtController.clear();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Imágenes *',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _buildImageGrid(),
                  const SizedBox(height: 20),
                  _buildPublishSelector(),
                  const SizedBox(height: 20),
                  SellerProductStarredSelector(
                    isStarred: _isStarred,
                    starredCount: _starredCount,
                    enabled: !_submitting,
                    onChanged: (value) => setState(() => _isStarred = value),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TechnicianPanelSecondaryButton(
                      label: 'Ver como lo verá el cliente',
                      onPressed: _submitting ? null : _openClientPreview,
                    ),
                    const SizedBox(height: 10),
                    TechnicianPanelPrimaryButton(
                      label: widget.isEditing
                          ? 'Guardar cambios'
                          : 'Agregar al catálogo',
                      isLoading: _submitting,
                      icon: Icons.save_outlined,
                      onPressed: _submitting ? null : _save,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_submitting)
            UploadProgressOverlay(
              completed: _uploadCompleted,
              total: _uploadTotal,
            ),
        ],
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({this.imageUrl, this.file, required this.onRemove});

  final String? imageUrl;
  final File? file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 96,
            height: 96,
            child: file != null
                ? Image.file(file!, fit: BoxFit.cover)
                : HomeMediaImage.workGalleryThumb(
                    context: context,
                    imageUrl: MediaUrlUtils.resolve(imageUrl)!,
                    width: 96,
                    height: 96,
                  ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              minimumSize: const Size(28, 28),
              iconSize: 16,
            ),
            onPressed: onRemove,
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD1D5DB), width: 1.5),
          color: Colors.white,
        ),
        child: const Icon(Icons.add_photo_alternate_outlined),
      ),
    );
  }
}

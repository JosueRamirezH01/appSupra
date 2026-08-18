import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../auth/auth_ui.dart';
import '../technician/maps_launch_actions.dart';

enum _StoreInlineEdit { none, name, about }

Future<void> showSellerStoreInfoSheet(
  BuildContext context, {
  required SellerPublicModel seller,
  bool canEdit = false,
  Future<void> Function(String businessName)? onSaveBusinessName,
  Future<void> Function(String description)? onSaveDescription,
  VoidCallback? onEditLocation,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppBrandColors.scaffoldBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _SellerStoreInfoSheet(
      seller: seller,
      canEdit: canEdit,
      onSaveBusinessName: onSaveBusinessName,
      onSaveDescription: onSaveDescription,
      onEditLocation: onEditLocation,
    ),
  );
}

class _SellerStoreInfoSheet extends StatefulWidget {
  const _SellerStoreInfoSheet({
    required this.seller,
    required this.canEdit,
    this.onSaveBusinessName,
    this.onSaveDescription,
    this.onEditLocation,
  });

  final SellerPublicModel seller;
  final bool canEdit;
  final Future<void> Function(String businessName)? onSaveBusinessName;
  final Future<void> Function(String description)? onSaveDescription;
  final VoidCallback? onEditLocation;

  @override
  State<_SellerStoreInfoSheet> createState() => _SellerStoreInfoSheetState();
}

class _SellerStoreInfoSheetState extends State<_SellerStoreInfoSheet> {
  final _sheetController = DraggableScrollableController();
  final _formKey = GlobalKey<FormState>();

  late String _businessName;
  late String? _description;
  _StoreInlineEdit _editing = _StoreInlineEdit.none;
  bool _saving = false;
  TextEditingController? _nameController;
  TextEditingController? _aboutController;

  bool get _canEditName =>
      widget.canEdit && widget.onSaveBusinessName != null;
  bool get _canEditAbout =>
      widget.canEdit && widget.onSaveDescription != null;
  bool get _canEditLocation =>
      widget.canEdit && widget.onEditLocation != null;

  bool get _hasAbout =>
      _description != null && _description!.trim().isNotEmpty;

  String? get _address {
    final value = widget.seller.locationAddress?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  @override
  void initState() {
    super.initState();
    _businessName = widget.seller.businessName.trim();
    final about = widget.seller.description?.trim();
    _description = (about == null || about.isEmpty) ? null : about;
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _nameController?.dispose();
    _aboutController?.dispose();
    super.dispose();
  }

  void _openLocationEdit() {
    final action = widget.onEditLocation;
    if (action == null || _saving) return;
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }

  void _expandSheet() {
    if (!_sheetController.isAttached) return;
    _sheetController.animateTo(
      0.92,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _startEdit(_StoreInlineEdit target) {
    if (_saving || _editing == target) return;
    final previousName = _nameController;
    final previousAbout = _aboutController;
    setState(() {
      _nameController = null;
      _aboutController = null;
      _editing = target;
      if (target == _StoreInlineEdit.name) {
        _nameController = TextEditingController(text: _businessName);
      } else if (target == _StoreInlineEdit.about) {
        _aboutController = TextEditingController(text: _description ?? '');
      }
    });
    previousName?.dispose();
    previousAbout?.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _expandSheet();
    });
  }

  void _cancelEdit() {
    if (_saving) return;
    final previousName = _nameController;
    final previousAbout = _aboutController;
    setState(() {
      _nameController = null;
      _aboutController = null;
      _editing = _StoreInlineEdit.none;
    });
    previousName?.dispose();
    previousAbout?.dispose();
  }

  Future<void> _saveName() async {
    final save = widget.onSaveBusinessName;
    final controller = _nameController;
    if (save == null || controller == null) return;
    if (_formKey.currentState?.validate() == false) return;

    final text = controller.text.trim();
    setState(() => _saving = true);
    try {
      await save(text);
      if (!mounted) return;
      final previousName = _nameController;
      setState(() {
        _businessName = text;
        _nameController = null;
        _editing = _StoreInlineEdit.none;
        _saving = false;
      });
      previousName?.dispose();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackBar(context, error);
    }
  }

  Future<void> _saveAbout() async {
    final save = widget.onSaveDescription;
    final controller = _aboutController;
    if (save == null || controller == null) return;
    if (_formKey.currentState?.validate() == false) return;

    final text = controller.text.trim();
    setState(() => _saving = true);
    try {
      await save(text);
      if (!mounted) return;
      final previousAbout = _aboutController;
      setState(() {
        _description = text.isEmpty ? null : text;
        _aboutController = null;
        _editing = _StoreInlineEdit.none;
        _saving = false;
      });
      previousAbout?.dispose();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      controller: _sheetController,
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Sobre el negocio',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppBrandColors.textMuted,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 28 + bottomInset),
                  children: [
                    _buildNameCard(),
                    _buildAboutCard(),
                    _buildLocationCard(),
                    _buildTrustCard(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNameCard() {
    final editing = _editing == _StoreInlineEdit.name;
    return _SectionCard(
      title: 'Nombre',
      icon: Icons.storefront_outlined,
      highlighted: editing,
      onEdit: _canEditName && !editing && !_saving
          ? () => _startEdit(_StoreInlineEdit.name)
          : null,
      child: editing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthRoundedField(
                  controller: _nameController!,
                  label: 'Nombre del negocio',
                  maxLength: 150,
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Mínimo 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  'Así aparece en tu tienda y en las cards de producto.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.35,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                _InlineEditActions(
                  saving: _saving,
                  onCancel: _cancelEdit,
                  onSave: _saveName,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    _businessName,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                ),
                if (widget.seller.verified) ...[
                  const SizedBox(width: 8),
                  const _VerifiedChip(),
                ],
              ],
            ),
    );
  }

  Widget _buildAboutCard() {
    final editing = _editing == _StoreInlineEdit.about;
    final showCard = _hasAbout || widget.canEdit;
    if (!showCard) return const SizedBox.shrink();

    return _SectionCard(
      title: 'Presentación',
      icon: Icons.notes_outlined,
      highlighted: editing,
      onEdit: _canEditAbout && !editing && !_saving
          ? () => _startEdit(_StoreInlineEdit.about)
          : null,
      child: editing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthRoundedField(
                  controller: _aboutController!,
                  label: 'Presentación del negocio',
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 2000,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cuéntales qué venden y qué los diferencia. Sin celular ni WhatsApp.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.35,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                _InlineEditActions(
                  saving: _saving,
                  onCancel: _cancelEdit,
                  onSave: _saveAbout,
                ),
              ],
            )
          : _hasAbout
              ? Text(
                  _description!.trim(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.5,
                    color: AppBrandColors.textDark,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aún no hay presentación. Los clientes verán este espacio vacío.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.45,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: _saving
                          ? null
                          : () => _startEdit(_StoreInlineEdit.about),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppBrandColors.primaryGreen,
                      ),
                      label: Text(
                        'Escribir ahora',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLocationCard() {
    final address = _address;
    final canOpenMaps = MapsLaunchActions.canOpen(address: address);
    final showCard = address != null || widget.canEdit;
    if (!showCard) return const SizedBox.shrink();

    return _SectionCard(
      title: 'Ubicación',
      icon: Icons.location_on_outlined,
      onEdit: _canEditLocation && !_saving ? _openLocationEdit : null,
      child: address == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aún no hay dirección. Los clientes la verán aquí.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.45,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _saving ? null : _openLocationEdit,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppBrandColors.primaryGreen,
                  ),
                  label: Text(
                    'Agregar ubicación',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppBrandColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textDark,
                  ),
                ),
                if (canOpenMaps) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => MapsLaunchActions.openLocation(
                      context,
                      address: address,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppBrandColors.primaryGreen,
                      padding: EdgeInsets.zero,
                    ),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: Text(
                      'Cómo llegar',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildTrustCard() {
    final ruc = widget.seller.ruc.trim();
    if (ruc.isEmpty && !widget.seller.verified) {
      return const SizedBox.shrink();
    }

    return _SectionCard(
      title: 'Confianza',
      icon: Icons.verified_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (ruc.isNotEmpty) ...[
            Text(
              'RUC',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              ruc,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppBrandColors.textDark,
                letterSpacing: 0.3,
              ),
            ),
          ],
          if (widget.seller.verified) ...[
            if (ruc.isNotEmpty) const SizedBox(height: 12),
            Text(
              'Negocio verificado en la plataforma.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.4,
                color: AppBrandColors.textDark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.onEdit,
    this.highlighted = false,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final VoidCallback? onEdit;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 10, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: highlighted
              ? AppBrandColors.primaryGreen.withValues(alpha: 0.45)
              : const Color(0xFFE8EAED),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppBrandColors.primaryGreen),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppBrandColors.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InlineEditActions extends StatelessWidget {
  const _InlineEditActions({
    required this.saving,
    required this.onCancel,
    required this.onSave,
  });

  final bool saving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: saving ? null : onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppBrandColors.textDark,
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: saving ? null : onSave,
            style: FilledButton.styleFrom(
              backgroundColor: AppBrandColors.primaryGreen,
              disabledBackgroundColor:
                  AppBrandColors.primaryGreen.withValues(alpha: 0.45),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Guardar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF16A34A)),
          const SizedBox(width: 4),
          Text(
            'Verificado',
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }
}

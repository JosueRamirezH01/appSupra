import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/work_portfolio_constants.dart';
import '../../../core/utils/media_url_utils.dart';
import '../auth/auth_ui.dart';

/// Borrador editable de un caso de trabajo (imagen + descripción + estimado).
class WorkCaseDraft {
  WorkCaseDraft({
    this.existingUrl,
    this.newFile,
    this.caption = '',
    this.estimatedCostText = '',
  });

  final String? existingUrl;
  final File? newFile;
  String caption;
  String estimatedCostText;

  bool get hasImage =>
      (existingUrl != null && existingUrl!.trim().isNotEmpty) || newFile != null;
}

/// Editor de casos de trabajo para el dueño del servicio.
class TechnicianWorkCasesEditor extends StatelessWidget {
  const TechnicianWorkCasesEditor({
    super.key,
    required this.cases,
    required this.enabled,
    required this.onAdd,
    required this.onRemove,
    required this.onEdit,
  });

  final List<WorkCaseDraft> cases;
  final bool enabled;
  final VoidCallback? onAdd;
  final void Function(int index) onRemove;
  final void Function(int index) onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < cases.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _WorkCaseEditorTile(
            draft: cases[i],
            enabled: enabled,
            onEdit: () => onEdit(i),
            onRemove: enabled ? () => onRemove(i) : null,
          ),
        ],
        if (enabled && onAdd != null) ...[
          if (cases.isNotEmpty) const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: Text(
              cases.isEmpty ? 'Agregar trabajo realizado' : 'Agregar otro',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppBrandColors.primaryGreen,
              side: BorderSide(
                color: AppBrandColors.primaryGreen.withValues(alpha: 0.45),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _WorkCaseEditorTile extends StatelessWidget {
  const _WorkCaseEditorTile({
    required this.draft,
    required this.enabled,
    required this.onEdit,
    this.onRemove,
  });

  final WorkCaseDraft draft;
  final bool enabled;
  final VoidCallback onEdit;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final caption = draft.caption.trim();
    final cost = draft.estimatedCostText.trim();
    final incomplete = caption.length < WorkPortfolioConstants.minCaptionLength ||
        cost.isEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: enabled ? onEdit : null,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: incomplete
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFFE8EAED),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    width: 72,
                    height: 72,
                    child: _thumb(draft),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        caption.isEmpty ? 'Sin descripción' : caption,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: caption.isEmpty
                              ? AppBrandColors.textMuted
                              : AppBrandColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        cost.isEmpty ? 'Falta estimación' : 'Estimado S/ $cost',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: cost.isEmpty
                              ? const Color(0xFFB45309)
                              : AppBrandColors.primaryGreen,
                        ),
                      ),
                      if (incomplete) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Toca para completar',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppBrandColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (onRemove != null)
                  IconButton(
                    onPressed: onRemove,
                    icon: const Icon(Icons.close_rounded, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumb(WorkCaseDraft draft) {
    if (draft.newFile != null) {
      return Image.file(draft.newFile!, fit: BoxFit.cover);
    }
    final url = draft.existingUrl;
    final provider = MediaUrlUtils.networkImage(url);
    if (provider == null) {
      return const ColoredBox(
        color: Color(0xFFE8EAED),
        child: Icon(Icons.broken_image_outlined),
      );
    }
    return Image(image: provider, fit: BoxFit.cover);
  }
}

Future<WorkCaseDraft?> showWorkCaseEditorSheet({
  required BuildContext context,
  required WorkCaseDraft draft,
}) {
  return showModalBottomSheet<WorkCaseDraft>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (ctx) => _WorkCaseEditorSheet(initial: draft),
  );
}

class _WorkCaseEditorSheet extends StatefulWidget {
  const _WorkCaseEditorSheet({required this.initial});

  final WorkCaseDraft initial;

  @override
  State<_WorkCaseEditorSheet> createState() => _WorkCaseEditorSheetState();
}

class _WorkCaseEditorSheetState extends State<_WorkCaseEditorSheet> {
  late final TextEditingController _captionController;
  late final TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _captionController = TextEditingController(text: widget.initial.caption);
    _costController =
        TextEditingController(text: widget.initial.estimatedCostText);
  }

  @override
  void dispose() {
    _captionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _submit() {
    final caption = _captionController.text.trim();
    final costRaw = _costController.text.trim().replaceAll(',', '.');
    final cost = double.tryParse(costRaw);

    if (caption.length < WorkPortfolioConstants.minCaptionLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Describe el trabajo (mínimo 3 caracteres)'),
        ),
      );
      return;
    }
    if (cost == null || cost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa una estimación válida en soles')),
      );
      return;
    }

    Navigator.pop(
      context,
      WorkCaseDraft(
        existingUrl: widget.initial.existingUrl,
        newFile: widget.initial.newFile,
        caption: caption,
        estimatedCostText: cost == cost.roundToDouble()
            ? cost.toStringAsFixed(0)
            : cost.toStringAsFixed(2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + keyboardInset),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Caso de trabajo',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Describe lo realizado y una estimación referencial. '
                'No reemplaza la cotización del servicio.',
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: widget.initial.newFile != null
                      ? Image.file(widget.initial.newFile!, fit: BoxFit.cover)
                      : Builder(
                          builder: (context) {
                            final provider = MediaUrlUtils.networkImage(
                              widget.initial.existingUrl,
                            );
                            if (provider == null) {
                              return const ColoredBox(
                                color: Color(0xFFE8EAED),
                                child: Icon(Icons.broken_image_outlined),
                              );
                            }
                            return Image(image: provider, fit: BoxFit.cover);
                          },
                        ),
                ),
              ),
              const SizedBox(height: 14),
              AuthRoundedField(
                controller: _captionController,
                label: 'Descripción *',
                maxLines: 3,
                maxLength: WorkPortfolioConstants.maxCaptionLength,
              ),
              const SizedBox(height: 12),
              AuthRoundedField(
                controller: _costController,
                label: 'Estimación (S/) *',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppBrandColors.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Guardar caso',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/auth/profile_photo_field.dart';
import '../../widgets/common_widgets.dart';

class ClientEditProfileScreen extends ConsumerStatefulWidget {
  const ClientEditProfileScreen({super.key});

  @override
  ConsumerState<ClientEditProfileScreen> createState() =>
      _ClientEditProfileScreenState();
}

class _ClientEditProfileScreenState extends ConsumerState<ClientEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _technicianPhoneController = TextEditingController();
  final _sellerPhoneController = TextEditingController();

  File? _profilePhoto;
  bool _initialized = false;
  bool _submitting = false;

  String _originalName = '';
  String _originalClientPhone = '';
  String _originalTechnicianPhone = '';
  String _originalSellerPhone = '';

  bool _hasTechnician = false;
  bool _hasSeller = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _technicianPhoneController.dispose();
    _sellerPhoneController.dispose();
    super.dispose();
  }

  void _initializeFields(UserModel user) {
    if (_initialized) return;

    _hasTechnician = user.hasTechnicianProfile;
    _hasSeller = user.hasSellerProfile;

    _originalName = user.name;
    _originalClientPhone = user.views?.client?.phone?.trim() ?? '';
    _originalTechnicianPhone = user.views?.technician?.phone?.trim() ?? '';
    _originalSellerPhone = user.views?.seller?.phone?.trim() ?? '';

    _nameController.text = _originalName;
    _phoneController.text = _originalClientPhone;
    _technicianPhoneController.text = _originalTechnicianPhone;
    _sellerPhoneController.text = _originalSellerPhone;

    _initialized = true;
  }

  String? _validatePhone(String? value, {required bool required}) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) {
      return required ? 'Ingresa tu celular' : null;
    }
    if (phone.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  Future<void> _pickProfilePhoto() async {
    final file = await ImagePickerUtils.pickImage(context);
    if (file != null) {
      setState(() => _profilePhoto = file);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final name = _nameController.text.trim();
    final clientPhone = _phoneController.text.trim();
    final technicianPhone = _technicianPhoneController.text.trim();
    final sellerPhone = _sellerPhoneController.text.trim();

    final clientChanged = name != _originalName ||
        clientPhone != _originalClientPhone ||
        _profilePhoto != null;
    final technicianChanged =
        _hasTechnician && technicianPhone != _originalTechnicianPhone;
    final sellerChanged = _hasSeller && sellerPhone != _originalSellerPhone;

    if (!clientChanged && !technicianChanged && !sellerChanged) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No hay cambios para guardar',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
      return;
    }

    final failures = <String>[];
    var anySuccess = false;

    try {
      if (clientChanged) {
        try {
          String? profilePhotoUrl;
          String? uploadSessionId;

          if (_profilePhoto != null) {
            final upload =
                await ref.read(uploadsRepositoryProvider).uploadTechnicianFile(
                      category: UploadCategory.profilePhoto,
                      file: _profilePhoto!,
                    );
            profilePhotoUrl = upload.file.url;
            uploadSessionId = upload.sessionId;
          }

          await ref.read(authNotifierProvider.notifier).updateClientProfile(
                UpdateClientProfileRequest(
                  name: name,
                  phone: clientPhone,
                  profilePhotoUrl: profilePhotoUrl,
                  uploadSessionId: uploadSessionId,
                ),
              );
          anySuccess = true;
          _originalName = name;
          _originalClientPhone = clientPhone;
        } catch (e) {
          failures.add('Cuenta: ${errorMessage(e)}');
        }
      }

      if (technicianChanged) {
        try {
          await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
                UpdateTechnicianProfileRequest(phone: technicianPhone),
              );
          anySuccess = true;
          _originalTechnicianPhone = technicianPhone;
        } catch (e) {
          failures.add('Perfil técnico: ${errorMessage(e)}');
        }
      }

      if (sellerChanged) {
        try {
          await ref.read(sellersRepositoryProvider).updateProfile(
                UpdateSellerProfileRequest(phone: sellerPhone),
              );
          ref.invalidate(mySellerApplicationProvider);
          anySuccess = true;
          _originalSellerPhone = sellerPhone;
        } catch (e) {
          failures.add('Perfil vendedor: ${errorMessage(e)}');
        }
      }

      if (anySuccess) {
        await ref.read(authNotifierProvider.notifier).refreshProfile();
      }

      if (!mounted) return;

      if (failures.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Perfil actualizado',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            backgroundColor: AppBrandColors.primaryGreen,
          ),
        );
        Navigator.pop(context);
        return;
      }

      final message = anySuccess
          ? 'Algunos cambios se guardaron, pero hubo errores:\n${failures.join('\n')}'
          : failures.join('\n');
      showErrorSnackBar(context, message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final isLoading = auth.isLoading || _submitting;

    return AppScaffold(
      title: 'Editar perfil',
      body: auth.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(authNotifierProvider),
        ),
        data: (user) {
          if (user == null) return const LoadingView();

          _initializeFields(user);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _ProfileSectionHeader(
                    title: 'Cuenta',
                    subtitle:
                        'Datos de tu cuenta. Este celular no se muestra en tu perfil técnico o de vendedor.',
                  ),
                  const SizedBox(height: 12),
                  ProfilePhotoField(
                    photo: _profilePhoto,
                    onPick: _pickProfilePhoto,
                    enabled: !isLoading,
                    required: false,
                  ),
                  const SizedBox(height: 14),
                  AuthRoundedField(
                    controller: _nameController,
                    label: 'Nombre',
                    validator: (value) =>
                        value == null || value.trim().length < 2
                            ? 'Mínimo 2 caracteres'
                            : null,
                  ),
                  const SizedBox(height: 14),
                  AuthRoundedField(
                    controller: _phoneController,
                    label: 'Celular de la cuenta',
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    validator: (value) =>
                        _validatePhone(value, required: true),
                  ),
                  if (_hasTechnician) ...[
                    const SizedBox(height: 28),
                    const _ProfileSectionHeader(
                      title: 'Perfil técnico',
                      subtitle:
                          'Celular de contacto público. Es el que ven los clientes al contactarte.',
                    ),
                    const SizedBox(height: 12),
                    AuthRoundedField(
                      controller: _technicianPhoneController,
                      label: 'Celular de contacto (técnico)',
                      keyboardType: TextInputType.phone,
                      maxLength: 9,
                      validator: (value) =>
                          _validatePhone(value, required: true),
                    ),
                  ],
                  if (_hasSeller) ...[
                    const SizedBox(height: 28),
                    const _ProfileSectionHeader(
                      title: 'Perfil vendedor',
                      subtitle:
                          'Celular de contacto del negocio. Es el que ven los clientes al contactarte.',
                    ),
                    const SizedBox(height: 12),
                    AuthRoundedField(
                      controller: _sellerPhoneController,
                      label: 'Celular de contacto (vendedor)',
                      keyboardType: TextInputType.phone,
                      maxLength: 9,
                      validator: (value) =>
                          _validatePhone(value, required: true),
                    ),
                  ],
                  const SizedBox(height: 28),
                  AuthPrimaryButton(
                    label: 'Guardar cambios',
                    isLoading: isLoading,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileSectionHeader extends StatelessWidget {
  const _ProfileSectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            height: 1.35,
            color: AppBrandColors.textMuted,
          ),
        ),
      ],
    );
  }
}

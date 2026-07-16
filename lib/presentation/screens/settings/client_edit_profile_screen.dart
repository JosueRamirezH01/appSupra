import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
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
  File? _profilePhoto;
  bool _initialized = false;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeFields(UserModel user) {
    if (_initialized) return;
    _nameController.text = user.name;
    _phoneController.text = user.views?.client?.phone ?? '';
    _initialized = true;
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

    try {
      String? profilePhotoUrl;
      String? uploadSessionId;

      if (_profilePhoto != null) {
        final upload = await ref.read(uploadsRepositoryProvider).uploadTechnicianFile(
              category: UploadCategory.profilePhoto,
              file: _profilePhoto!,
            );
        profilePhotoUrl = upload.file.url;
        uploadSessionId = upload.sessionId;
      }

      await ref.read(authNotifierProvider.notifier).updateClientProfile(
            UpdateClientProfileRequest(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              profilePhotoUrl: profilePhotoUrl,
              uploadSessionId: uploadSessionId,
            ),
          );

      if (!mounted) return;

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
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
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
                    label: 'Celular',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      final phone = value?.trim() ?? '';
                      if (phone.isEmpty) return 'Ingresa tu celular';
                      if (phone.length < 6) return 'Mínimo 6 caracteres';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
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

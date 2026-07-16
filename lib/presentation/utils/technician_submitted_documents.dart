import 'package:flutter/material.dart';

import '../../data/models/technicians/technician_model.dart';

class TechnicianSubmittedDocument {
  const TechnicianSubmittedDocument({
    required this.id,
    required this.title,
    required this.url,
    required this.icon,
    this.subtitle,
  });

  final String id;
  final String title;
  final String url;
  final IconData icon;
  final String? subtitle;
}

/// Agrupa todos los documentos enviados del técnico (extensible a nuevos campos).
abstract final class TechnicianSubmittedDocuments {
  static List<TechnicianSubmittedDocument> fromProfile(
    TechnicianApplicationModel profile,
  ) {
    final docs = <TechnicianSubmittedDocument>[];

    void add({
      required String id,
      required String title,
      required String? url,
      required IconData icon,
      String? subtitle,
    }) {
      if (url == null || url.trim().isEmpty) return;
      docs.add(
        TechnicianSubmittedDocument(
          id: id,
          title: title,
          url: url,
          icon: icon,
          subtitle: subtitle,
        ),
      );
    }

    if (profile.profileType == 'empresa') {
      add(
        id: 'ruc',
        title: 'Ficha RUC',
        url: profile.rucDocumentUrl,
        icon: Icons.description_outlined,
        subtitle: profile.businessName != null
            ? '${profile.businessName} · RUC ${profile.ruc}'
            : profile.ruc != null
                ? 'RUC ${profile.ruc}'
                : null,
      );
      add(
        id: 'company_logo',
        title: 'Logo de la empresa',
        url: profile.companyLogoUrl,
        icon: Icons.storefront_outlined,
      );
      add(
        id: 'legal_representative_front',
        title: 'DNI representante legal (frontal)',
        url: profile.legalRepresentativeDocumentFrontUrl ??
            profile.legalRepresentativeDocumentUrl,
        icon: Icons.badge_outlined,
        subtitle: profile.legalRepresentativeName,
      );
      add(
        id: 'legal_representative_back',
        title: 'DNI representante legal (reverso)',
        url: profile.legalRepresentativeDocumentBackUrl,
        icon: Icons.badge_outlined,
      );
      return docs;
    }

    add(
      id: 'identity_front',
      title: 'DNI frontal',
      url: profile.documentFrontImageUrl ?? profile.documentImageUrl,
      icon: Icons.credit_card_outlined,
      subtitle: profile.documentType,
    );
    add(
      id: 'identity_back',
      title: 'DNI reverso',
      url: profile.documentBackImageUrl,
      icon: Icons.credit_card_outlined,
    );
    add(
      id: 'face_photo',
      title: 'Foto de rostro',
      url: profile.facePhotoUrl,
      icon: Icons.face_retouching_natural_outlined,
    );

    for (final workPhoto in profile.workPhotos) {
      add(
        id: 'work_${workPhoto.id}',
        title: 'Trabajo realizado',
        url: workPhoto.imageUrl,
        icon: Icons.photo_library_outlined,
        subtitle: workPhoto.caption,
      );
    }

    for (final license in profile.licenses) {
      add(
        id: 'license_${license.id}',
        title: license.name,
        url: license.imageUrl,
        icon: Icons.card_membership_outlined,
        subtitle: license.licenseNumber,
      );
    }

    for (final cert in profile.certifications) {
      add(
        id: 'cert_${cert.id}',
        title: cert.name,
        url: cert.imageUrl,
        icon: Icons.school_outlined,
        subtitle: cert.issuer,
      );
    }

    return docs;
  }

  static bool hasAny(TechnicianApplicationModel profile) =>
      fromProfile(profile).isNotEmpty;
}

bool technicianDocumentLooksLikeImage(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  return path.endsWith('.jpg') ||
      path.endsWith('.jpeg') ||
      path.endsWith('.png') ||
      path.endsWith('.webp') ||
      path.endsWith('.gif') ||
      path.endsWith('.heic') ||
      !path.contains('.');
}

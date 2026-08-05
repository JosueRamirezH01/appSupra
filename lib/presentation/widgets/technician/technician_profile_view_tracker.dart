import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/viewer_identity_service.dart';
import '../../providers/repository_providers.dart';

class TechnicianProfileViewTracker extends ConsumerStatefulWidget {
  const TechnicianProfileViewTracker({
    super.key,
    required this.technicianUserId,
    required this.child,
  });

  final int technicianUserId;
  final Widget child;

  @override
  ConsumerState<TechnicianProfileViewTracker> createState() =>
      _TechnicianProfileViewTrackerState();
}

class _TechnicianProfileViewTrackerState extends ConsumerState<TechnicianProfileViewTracker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordView());
  }

  Future<void> _recordView() async {
    try {
      final viewerKey = await ViewerIdentityService.getViewerKey();
      await ref.read(techniciansRepositoryProvider).recordProfileView(
            technicianUserId: widget.technicianUserId,
            viewerKey: viewerKey,
          );
    } catch (_) {
      // Tracking must not block profile UX.
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

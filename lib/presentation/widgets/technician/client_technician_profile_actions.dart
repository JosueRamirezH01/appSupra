import 'package:flutter/material.dart';

import '../../../core/utils/contact_launch_actions.dart';

abstract final class ClientTechnicianProfileActions {
  static Future<void> call(BuildContext context, String? phone) =>
      ContactLaunchActions.call(context, phone);

  static Future<void> whatsApp(
    BuildContext context,
    String? phone, {
    String? message,
  }) =>
      ContactLaunchActions.whatsApp(context, phone, message: message);

  static void requestService(BuildContext context, {required String name}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pronto podrás solicitar servicio a $name desde la app.'),
      ),
    );
  }
}

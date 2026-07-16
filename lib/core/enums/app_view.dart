enum AppView {
  client,
  technician,
  seller,
  admin;

  static AppView? tryParse(String? value) {
    return switch (value) {
      'client' => AppView.client,
      'technician' => AppView.technician,
      'seller' => AppView.seller,
      'admin' => AppView.admin,
      _ => null,
    };
  }

  String get apiValue => switch (this) {
        AppView.client => 'client',
        AppView.technician => 'technician',
        AppView.seller => 'seller',
        AppView.admin => 'admin',
      };

  String get label => switch (this) {
        AppView.client => 'Cliente',
        AppView.technician => 'Técnico',
        AppView.seller => 'Vendedor',
        AppView.admin => 'Admin',
      };
}

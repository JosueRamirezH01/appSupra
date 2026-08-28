class GuestContactDraft {
  const GuestContactDraft({
    this.name = '',
    this.email = '',
    this.phone = '',
  });

  final String name;
  final String email;
  final String phone;

  bool get isEmpty => name.isEmpty && email.isEmpty && phone.isEmpty;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };

  factory GuestContactDraft.fromJson(Map<String, dynamic> json) {
    return GuestContactDraft(
      name: (json['name'] as String?)?.trim() ?? '',
      email: (json['email'] as String?)?.trim() ?? '',
      phone: (json['phone'] as String?)?.trim() ?? '',
    );
  }
}

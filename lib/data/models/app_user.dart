class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.country,
    required this.currency,
  });

  final String uid;
  final String name;
  final String phone;
  final String email;
  final String country;
  final String currency;

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'email': email,
        'country': country,
        'currency': currency,
      };

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
        uid: uid,
        name: m['name'] as String? ?? '',
        phone: m['phone'] as String? ?? '',
        email: m['email'] as String? ?? '',
        country: m['country'] as String? ?? '',
        currency: m['currency'] as String? ?? 'USD',
      );
}

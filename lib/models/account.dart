class Account {
  final String fullName;
  final String email;

  Account({required this.fullName, required this.email});

  Account.fromData(Map<String, dynamic> data)
      : fullName = data['fullName'],
        email = data['email'];

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
    };
  }
}

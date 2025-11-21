class Lead {
  String id;
  String name;
  String email;
  String phone;
  String source;
  String notes;
  String status; // New, Contacted, Converted, Lost
  DateTime createdAt;


  Lead({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.source = '',
    this.notes = '',
    this.status = 'New',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();


  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'source': source,
    'notes': notes,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };


  static Lead fromMap(Map<String, dynamic> m) => Lead(
    id: m['id'] as String,
    name: m['name'] as String? ?? '',
    email: m['email'] as String? ?? '',
    phone: m['phone'] as String? ?? '',
    source: m['source'] as String? ?? '',
    notes: m['notes'] as String? ?? '',
    status: m['status'] as String? ?? 'New',
    createdAt: DateTime.parse(m['createdAt'] as String),
  );
}
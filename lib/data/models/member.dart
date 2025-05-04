import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';

/// Üye veri modeli
class Member {
  final String id;
  final String fullName;
  final String? phoneNumber;
  final String? email;
  final DateTime? birthDate;
  final DateTime startDate;
  final String status;
  final String? notes;
  final String? profileImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Member({
    String? id,
    required this.fullName,
    this.phoneNumber,
    this.email,
    this.birthDate,
    DateTime? startDate,
    String? status,
    this.notes,
    this.profileImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    id = id ?? const Uuid().v4(),
    startDate = startDate ?? DateTime.now(),
    status = status ?? AppConstants.statusActive,
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();
  
  // Veritabanı için modeli Map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'birthDate': birthDate?.millisecondsSinceEpoch,
      'startDate': startDate.millisecondsSinceEpoch,
      'status': status,
      'notes': notes,
      'profileImagePath': profileImagePath,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Map'ten model oluştur
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      fullName: map['fullName'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      birthDate: map['birthDate'] != null 
        ? DateTime.fromMillisecondsSinceEpoch(map['birthDate']) 
        : null,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate']),
      status: map['status'],
      notes: map['notes'],
      profileImagePath: map['profileImagePath'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
  
  // Mevcut nesneyi güncelleyerek yeni bir kopya oluştur
  Member copyWith({
    String? fullName,
    String? phoneNumber,
    String? email,
    DateTime? birthDate,
    DateTime? startDate,
    String? status,
    String? notes,
    String? profileImagePath,
    DateTime? updatedAt,
  }) {
    return Member(
      id: this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  // İlgili üyenin aktif olup olmadığını kontrol et
  bool get isActive => status == AppConstants.statusActive;
  
  // Profil resmi var mı kontrol et
  bool get hasProfileImage => profileImagePath != null && profileImagePath!.isNotEmpty;
  
  // İletişim bilgilerinden en az biri var mı?
  bool get hasContactInfo => (phoneNumber != null && phoneNumber!.isNotEmpty) || 
                             (email != null && email!.isNotEmpty);
  
  // Doğum tarihi bilgisi var mı?
  bool get hasBirthDate => birthDate != null;
  
  // Üyeliğin başlangıcından bu yana geçen gün sayısı
  int get membershipDuration {
    final now = DateTime.now();
    return now.difference(startDate).inDays;
  }
  
  @override
  String toString() {
    return 'Member(id: $id, fullName: $fullName, status: $status)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Member && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
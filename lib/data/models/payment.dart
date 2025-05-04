import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';

/// Ödeme veri modeli
class Payment {
  final String id;
  final String memberId;
  final double amount;
  final DateTime paymentDate;
  final DateTime expiryDate;
  final String type;
  final String status;
  final String? description;
  final String? paymentMethod;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  Payment({
    String? id,
    required this.memberId,
    required this.amount,
    DateTime? paymentDate,
    required this.expiryDate,
    String? type,
    String? status,
    this.description,
    this.paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : 
    id = id ?? const Uuid().v4(),
    paymentDate = paymentDate ?? DateTime.now(),
    type = type ?? AppConstants.paymentTypeRenewal,
    status = status ?? AppConstants.paymentStatusPaid,
    createdAt = createdAt ?? DateTime.now(),
    updatedAt = updatedAt ?? DateTime.now();
  
  // Veritabanı için modeli Map'e dönüştür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'memberId': memberId,
      'amount': amount,
      'paymentDate': paymentDate.millisecondsSinceEpoch,
      'expiryDate': expiryDate.millisecondsSinceEpoch,
      'type': type,
      'status': status,
      'description': description,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
  
  // Map'ten model oluştur
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      memberId: map['memberId'],
      amount: map['amount'] is int 
          ? (map['amount'] as int).toDouble()
          : map['amount'],
      paymentDate: DateTime.fromMillisecondsSinceEpoch(map['paymentDate']),
      expiryDate: DateTime.fromMillisecondsSinceEpoch(map['expiryDate']),
      type: map['type'],
      status: map['status'],
      description: map['description'],
      paymentMethod: map['paymentMethod'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
  
  // Mevcut nesneyi güncelleyerek yeni bir kopya oluştur
  Payment copyWith({
    String? memberId,
    double? amount,
    DateTime? paymentDate,
    DateTime? expiryDate,
    String? type,
    String? status,
    String? description,
    String? paymentMethod,
    DateTime? updatedAt,
  }) {
    return Payment(
      id: this.id,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      expiryDate: expiryDate ?? this.expiryDate,
      type: type ?? this.type,
      status: status ?? this.status,
      description: description ?? this.description,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
  
  // Ödemenin tamamlandığını kontrol et
  bool get isPaid => status == AppConstants.paymentStatusPaid;
  
  // İndirimli bir ödeme mi?
  bool get isDiscounted => type == AppConstants.paymentTypeDiscount;
  
  // Yeni üyelik ödemesi mi?
  bool get isNewMembership => type == AppConstants.paymentTypeNew;
  
  // Ödeme açıklaması var mı?
  bool get hasDescription => description != null && description!.isNotEmpty;
  
  // Geçerliliğin dolmasına kalan gün sayısı
  int get daysLeft {
    final now = DateTime.now();
    if (expiryDate.isBefore(now)) return 0;
    return expiryDate.difference(now).inDays;
  }
  
  // Ödeme geçerliliği devam ediyor mu?
  bool get isValid {
    return expiryDate.isAfter(DateTime.now());
  }
  
  // Üyelik süresi (gün olarak)
  int get membershipDurationInDays {
    return expiryDate.difference(paymentDate).inDays;
  }
  
  @override
  String toString() {
    return 'Payment(id: $id, memberId: $memberId, amount: $amount, status: $status)';
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Payment && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
}
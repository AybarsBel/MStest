part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  
  @override
  List<Object?> get props => [];
}

// Tüm ödemeleri yükleme eventi
class LoadAllPayments extends PaymentEvent {}

// Üye ID'sine göre ödemeleri yükleme eventi
class LoadPaymentsByMemberId extends PaymentEvent {
  final String memberId;
  
  const LoadPaymentsByMemberId(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}

// Tarih aralığına göre ödemeleri yükleme eventi
class LoadPaymentsByDateRange extends PaymentEvent {
  final DateTime startDate;
  final DateTime endDate;
  
  const LoadPaymentsByDateRange({
    required this.startDate,
    required this.endDate,
  });
  
  @override
  List<Object> get props => [startDate, endDate];
}

// Yeni ödeme ekleme eventi
class AddNewPayment extends PaymentEvent {
  final Payment payment;
  
  const AddNewPayment(this.payment);
  
  @override
  List<Object> get props => [payment];
}

// Ödeme güncelleme eventi
class UpdatePayment extends PaymentEvent {
  final Payment payment;
  
  const UpdatePayment(this.payment);
  
  @override
  List<Object> get props => [payment];
}

// Ödeme silme eventi
class DeletePayment extends PaymentEvent {
  final String paymentId;
  final String? memberId;
  
  const DeletePayment(this.paymentId, {this.memberId});
  
  @override
  List<Object?> get props => [paymentId, memberId];
}

// Üyeliğin geçerli olup olmadığını kontrol etme eventi
class CheckMembershipValidity extends PaymentEvent {
  final String memberId;
  
  const CheckMembershipValidity(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}

// Üyeliğin kalan gün sayısını öğrenme eventi
class GetMembershipDaysLeft extends PaymentEvent {
  final String memberId;
  
  const GetMembershipDaysLeft(this.memberId);
  
  @override
  List<Object> get props => [memberId];
}
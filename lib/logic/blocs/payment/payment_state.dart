part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();
  
  @override
  List<Object?> get props => [];
}

// Başlangıç durumu
class PaymentInitial extends PaymentState {}

// Yükleniyor durumu
class PaymentLoading extends PaymentState {}

// Ödemeler yüklendi durumu
class PaymentsLoaded extends PaymentState {
  final List<Payment> payments;
  
  const PaymentsLoaded(this.payments);
  
  @override
  List<Object> get props => [payments];
}

// Tek ödeme yüklendi durumu
class PaymentLoaded extends PaymentState {
  final Payment payment;
  
  const PaymentLoaded(this.payment);
  
  @override
  List<Object> get props => [payment];
}

// Ödeme işlemi tamamlandı durumu
class PaymentOperationSuccess extends PaymentState {
  final String message;
  
  const PaymentOperationSuccess(this.message);
  
  @override
  List<Object> get props => [message];
}

// Üyelik geçerlilik durumu
class MembershipValidityChecked extends PaymentState {
  final bool isValid;
  
  const MembershipValidityChecked(this.isValid);
  
  @override
  List<Object> get props => [isValid];
}

// Üyelik kalan gün sayısı
class MembershipDaysLeftLoaded extends PaymentState {
  final int daysLeft;
  
  const MembershipDaysLeftLoaded(this.daysLeft);
  
  @override
  List<Object> get props => [daysLeft];
}

// Hata durumu
class PaymentError extends PaymentState {
  final String message;
  
  const PaymentError(this.message);
  
  @override
  List<Object> get props => [message];
}
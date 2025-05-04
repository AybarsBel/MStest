import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/payment.dart';
import '../../../data/repositories/payment_repository.dart';

// Events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class LoadAllPayments extends PaymentEvent {}

class LoadPaymentById extends PaymentEvent {
  final String paymentId;

  const LoadPaymentById(this.paymentId);

  @override
  List<Object> get props => [paymentId];
}

class LoadPaymentsByMember extends PaymentEvent {
  final String memberId;

  const LoadPaymentsByMember(this.memberId);

  @override
  List<Object> get props => [memberId];
}

class LoadPaymentsByDateRange extends PaymentEvent {
  final DateTime startDate;
  final DateTime endDate;

  const LoadPaymentsByDateRange(this.startDate, this.endDate);

  @override
  List<Object> get props => [startDate, endDate];
}

class LoadPaymentsByType extends PaymentEvent {
  final String type;

  const LoadPaymentsByType(this.type);

  @override
  List<Object> get props => [type];
}

class LoadPaymentsByStatus extends PaymentEvent {
  final String status;

  const LoadPaymentsByStatus(this.status);

  @override
  List<Object> get props => [status];
}

class AddPayment extends PaymentEvent {
  final Payment payment;

  const AddPayment(this.payment);

  @override
  List<Object> get props => [payment];
}

class UpdatePayment extends PaymentEvent {
  final Payment payment;

  const UpdatePayment(this.payment);

  @override
  List<Object> get props => [payment];
}

class DeletePayment extends PaymentEvent {
  final String paymentId;

  const DeletePayment(this.paymentId);

  @override
  List<Object> get props => [paymentId];
}

class LoadMonthlyIncomeReport extends PaymentEvent {
  final int year;

  const LoadMonthlyIncomeReport(this.year);

  @override
  List<Object> get props => [year];
}

// States
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentsLoaded extends PaymentState {
  final List<Payment> payments;
  final bool isFiltered;

  const PaymentsLoaded(this.payments, {this.isFiltered = false});

  @override
  List<Object> get props => [payments, isFiltered];
}

class PaymentLoaded extends PaymentState {
  final Payment payment;

  const PaymentLoaded(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);

  @override
  List<Object> get props => [message];
}

class PaymentAdded extends PaymentState {
  final Payment payment;

  const PaymentAdded(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentUpdated extends PaymentState {
  final Payment payment;

  const PaymentUpdated(this.payment);

  @override
  List<Object> get props => [payment];
}

class PaymentDeleted extends PaymentState {
  final String paymentId;

  const PaymentDeleted(this.paymentId);

  @override
  List<Object> get props => [paymentId];
}

class MonthlyIncomeReportLoaded extends PaymentState {
  final Map<String, double> monthlyIncomes;
  final int year;

  const MonthlyIncomeReportLoaded(this.monthlyIncomes, this.year);

  @override
  List<Object> get props => [monthlyIncomes, year];
}

// BLoC
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<LoadAllPayments>(_onLoadAllPayments);
    on<LoadPaymentById>(_onLoadPaymentById);
    on<LoadPaymentsByMember>(_onLoadPaymentsByMember);
    on<LoadPaymentsByDateRange>(_onLoadPaymentsByDateRange);
    on<LoadPaymentsByType>(_onLoadPaymentsByType);
    on<LoadPaymentsByStatus>(_onLoadPaymentsByStatus);
    on<AddPayment>(_onAddPayment);
    on<UpdatePayment>(_onUpdatePayment);
    on<DeletePayment>(_onDeletePayment);
    on<LoadMonthlyIncomeReport>(_onLoadMonthlyIncomeReport);
  }

  void _onLoadAllPayments(LoadAllPayments event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payments = await paymentRepository.getAllPayments();
      emit(PaymentsLoaded(payments));
    } catch (e) {
      emit(PaymentError('Ödemeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadPaymentById(LoadPaymentById event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payment = await paymentRepository.getPaymentById(event.paymentId);
      if (payment != null) {
        emit(PaymentLoaded(payment));
      } else {
        emit(const PaymentError('Ödeme bulunamadı.'));
      }
    } catch (e) {
      emit(PaymentError('Ödeme yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadPaymentsByMember(LoadPaymentsByMember event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payments = await paymentRepository.getPaymentsByMemberId(event.memberId);
      emit(PaymentsLoaded(payments, isFiltered: true));
    } catch (e) {
      emit(PaymentError('Üye ödemeleri yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadPaymentsByDateRange(LoadPaymentsByDateRange event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payments = await paymentRepository.getPaymentsByDateRange(
        event.startDate,
        event.endDate,
      );
      emit(PaymentsLoaded(payments, isFiltered: true));
    } catch (e) {
      emit(PaymentError('Tarih aralığındaki ödemeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadPaymentsByType(LoadPaymentsByType event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payments = await paymentRepository.getPaymentsByType(event.type);
      emit(PaymentsLoaded(payments, isFiltered: true));
    } catch (e) {
      emit(PaymentError('Ödeme tipine göre ödemeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onLoadPaymentsByStatus(LoadPaymentsByStatus event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final payments = await paymentRepository.getPaymentsByStatus(event.status);
      emit(PaymentsLoaded(payments, isFiltered: true));
    } catch (e) {
      emit(PaymentError('Ödeme durumuna göre ödemeler yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onAddPayment(AddPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final success = await paymentRepository.addPayment(event.payment);
      if (success) {
        emit(PaymentAdded(event.payment));
        // Listeyi yeniden yükle
        add(LoadAllPayments());
      } else {
        emit(const PaymentError('Ödeme eklenemedi.'));
      }
    } catch (e) {
      emit(PaymentError('Ödeme eklenirken bir hata oluştu: $e'));
    }
  }

  void _onUpdatePayment(UpdatePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final success = await paymentRepository.updatePayment(event.payment);
      if (success) {
        emit(PaymentUpdated(event.payment));
        // Listeyi yeniden yükle
        add(LoadAllPayments());
      } else {
        emit(const PaymentError('Ödeme güncellenemedi.'));
      }
    } catch (e) {
      emit(PaymentError('Ödeme güncellenirken bir hata oluştu: $e'));
    }
  }

  void _onDeletePayment(DeletePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final success = await paymentRepository.deletePayment(event.paymentId);
      if (success) {
        emit(PaymentDeleted(event.paymentId));
        // Listeyi yeniden yükle
        add(LoadAllPayments());
      } else {
        emit(const PaymentError('Ödeme silinemedi.'));
      }
    } catch (e) {
      emit(PaymentError('Ödeme silinirken bir hata oluştu: $e'));
    }
  }

  void _onLoadMonthlyIncomeReport(LoadMonthlyIncomeReport event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final report = await paymentRepository.getMonthlyIncomeReport(event.year);
      emit(MonthlyIncomeReportLoaded(report, event.year));
    } catch (e) {
      emit(PaymentError('Aylık gelir raporu yüklenirken bir hata oluştu: $e'));
    }
  }
}
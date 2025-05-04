import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../core/utils/file_util.dart';
import '../../../core/utils/date_util.dart';

// States
abstract class IncomeReportState extends Equatable {
  const IncomeReportState();
  
  @override
  List<Object?> get props => [];
}

class IncomeReportInitial extends IncomeReportState {}

class IncomeReportLoading extends IncomeReportState {}

class IncomeReportLoaded extends IncomeReportState {
  final Map<String, double> monthlyIncome;
  final double totalIncome;
  final double potentialIncome;
  final DateTime startDate;
  final DateTime endDate;

  const IncomeReportLoaded({
    required this.monthlyIncome,
    required this.totalIncome,
    required this.potentialIncome,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [monthlyIncome, totalIncome, potentialIncome, startDate, endDate];
}

class IncomeReportExported extends IncomeReportState {
  final String filePath;

  const IncomeReportExported(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class IncomeReportError extends IncomeReportState {
  final String message;

  const IncomeReportError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class IncomeReportCubit extends Cubit<IncomeReportState> {
  final PaymentRepository paymentRepository;
  final MemberRepository memberRepository;

  IncomeReportCubit({
    required this.paymentRepository,
    required this.memberRepository,
  }) : super(IncomeReportInitial());

  Future<void> loadIncomeReport({DateTime? startDate, DateTime? endDate}) async {
    emit(IncomeReportLoading());
    try {
      // Varsayılan olarak son 12 ay
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year - 1, now.month, 1);
      final end = endDate ?? DateTime(now.year, now.month, DateUtil.getLastDayOfMonth(now).day);
      
      final monthlyIncome = await paymentRepository.calculateMonthlyIncome(start, end);
      final totalIncome = await paymentRepository.calculateTotalIncome(start, end);
      final potentialIncome = await paymentRepository.calculatePotentialIncome(start, end);
      
      emit(IncomeReportLoaded(
        monthlyIncome: monthlyIncome,
        totalIncome: totalIncome,
        potentialIncome: potentialIncome,
        startDate: start,
        endDate: end,
      ));
    } catch (e) {
      emit(IncomeReportError('Gelir raporu yüklenirken hata oluştu: $e'));
    }
  }

  Future<void> exportIncomeReportAsPdf() async {
    if (state is IncomeReportLoaded) {
      final reportState = state as IncomeReportLoaded;
      
      try {
        final filePath = await FileUtil.saveIncomeReportAsPdf(
          reportState.monthlyIncome,
          reportState.totalIncome,
          reportState.potentialIncome,
          reportState.startDate,
          reportState.endDate,
        );
        
        if (filePath != null) {
          emit(IncomeReportExported(filePath));
        } else {
          emit(const IncomeReportError('Gelir raporu PDF olarak kaydedilemedi'));
        }
      } catch (e) {
        emit(IncomeReportError('Gelir raporu PDF olarak dışa aktarılırken hata oluştu: $e'));
      }
    } else {
      emit(const IncomeReportError('Dışa aktarmak için önce gelir raporu yüklenmelidir'));
    }
  }
}

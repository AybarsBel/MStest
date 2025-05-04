import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/member.dart';
import '../../../data/repositories/member_repository.dart';

// States
abstract class QrCodeState extends Equatable {
  const QrCodeState();

  @override
  List<Object> get props => [];
}

class QrCodeInitial extends QrCodeState {}

class QrCodeLoading extends QrCodeState {}

class QrCodeGenerated extends QrCodeState {
  final String memberId;
  final String memberName;
  final String qrData;

  const QrCodeGenerated({
    required this.memberId,
    required this.memberName,
    required this.qrData,
  });

  @override
  List<Object> get props => [memberId, memberName, qrData];
}

class QrCodeScanned extends QrCodeState {
  final String scannedData;
  final Member? member;

  const QrCodeScanned({
    required this.scannedData,
    this.member,
  });

  @override
  List<Object> get props => [scannedData, if (member != null) member!];
}

class QrCodeError extends QrCodeState {
  final String message;

  const QrCodeError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class QrCodeCubit extends Cubit<QrCodeState> {
  final MemberRepository memberRepository;

  QrCodeCubit({required this.memberRepository}) : super(QrCodeInitial());

  // QR kod oluştur
  Future<void> generateQrCode(String memberId) async {
    emit(QrCodeLoading());
    try {
      final member = await memberRepository.getMemberById(memberId);
      if (member == null) {
        emit(const QrCodeError('Üye bulunamadı'));
        return;
      }

      // QR kodu için veri oluştur (Örnek: memberId|currentTimestamp)
      final qrData = '$memberId|${DateTime.now().millisecondsSinceEpoch}';

      emit(QrCodeGenerated(
        memberId: memberId,
        memberName: member.fullName,
        qrData: qrData,
      ));
    } catch (e) {
      emit(QrCodeError('QR kod oluşturulurken bir hata oluştu: $e'));
    }
  }

  // QR kod tara ve üye bilgisini getir
  Future<void> scanQrCode(String scannedData) async {
    emit(QrCodeLoading());
    try {
      // Taranan veriyi işle
      final parts = scannedData.split('|');
      if (parts.isEmpty) {
        emit(const QrCodeError('Geçersiz QR kod formatı'));
        return;
      }

      final memberId = parts[0];
      final member = await memberRepository.getMemberById(memberId);

      if (member == null) {
        emit(QrCodeScanned(scannedData: scannedData));
      } else {
        emit(QrCodeScanned(scannedData: scannedData, member: member));
      }
    } catch (e) {
      emit(QrCodeError('QR kod taranırken bir hata oluştu: $e'));
    }
  }

  // Durumu sıfırla
  void resetState() {
    emit(QrCodeInitial());
  }
}
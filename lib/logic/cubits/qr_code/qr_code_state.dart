part of 'qr_code_cubit.dart';

abstract class QrCodeState extends Equatable {
  const QrCodeState();
  
  @override
  List<Object?> get props => [];
}

// Başlangıç durumu
class QrCodeInitial extends QrCodeState {}

// Yükleniyor durumu
class QrCodeLoading extends QrCodeState {}

// QR kodu oluşturuldu durumu
class QrCodeGenerated extends QrCodeState {
  final String memberId;
  final String qrData;
  final Member member;
  
  const QrCodeGenerated({
    required this.memberId,
    required this.qrData,
    required this.member,
  });
  
  @override
  List<Object> get props => [memberId, qrData, member];
}

// QR kodu dosyaya kaydedildi durumu
class QrCodeSaved extends QrCodeState {
  final String filePath;
  
  const QrCodeSaved({required this.filePath});
  
  @override
  List<Object> get props => [filePath];
}

// QR kodu tarandı ve üye bulundu durumu
class QrCodeScanned extends QrCodeState {
  final Member member;
  
  const QrCodeScanned({required this.member});
  
  @override
  List<Object> get props => [member];
}

// Hata durumu
class QrCodeError extends QrCodeState {
  final String message;
  
  const QrCodeError(this.message);
  
  @override
  List<Object> get props => [message];
}
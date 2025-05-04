import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/repositories/member_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/settings_repository.dart';

// States
abstract class BackupState extends Equatable {
  const BackupState();
  
  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {}

class BackupSuccess extends BackupState {
  final String filePath;
  final String message;

  const BackupSuccess({required this.filePath, required this.message});

  @override
  List<Object?> get props => [filePath, message];
}

class BackupError extends BackupState {
  final String message;

  const BackupError(this.message);

  @override
  List<Object?> get props => [message];
}

class RestoreSuccess extends BackupState {
  final String message;

  const RestoreSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RestoreError extends BackupState {
  final String message;

  const RestoreError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class BackupCubit extends Cubit<BackupState> {
  final MemberRepository memberRepository;
  final PaymentRepository paymentRepository;
  final SettingsRepository settingsRepository;

  BackupCubit({
    required this.memberRepository,
    required this.paymentRepository,
    required this.settingsRepository,
  }) : super(BackupInitial());

  Future<void> backupData() async {
    emit(BackupLoading());
    try {
      final filePath = await settingsRepository.backupData();
      
      if (filePath != null) {
        emit(BackupSuccess(
          filePath: filePath,
          message: 'Verileriniz başarıyla yedeklendi:\n$filePath',
        ));
      } else {
        emit(const BackupError('Yedekleme işlemi başarısız oldu'));
      }
    } catch (e) {
      emit(BackupError('Yedekleme işlemi sırasında hata oluştu: $e'));
    }
  }

  Future<void> restoreData() async {
    emit(BackupLoading());
    try {
      // Dosya seçiciyi aç
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.first.path;
        
        if (filePath != null) {
          final success = await settingsRepository.restoreData(filePath);
          
          if (success) {
            emit(const RestoreSuccess('Verileriniz başarıyla geri yüklendi'));
          } else {
            emit(const RestoreError('Geri yükleme işlemi başarısız oldu'));
          }
        } else {
          emit(const RestoreError('Dosya yolu bulunamadı'));
        }
      } else {
        emit(const RestoreError('Dosya seçilmedi'));
      }
    } catch (e) {
      emit(RestoreError('Geri yükleme işlemi sırasında hata oluştu: $e'));
    }
  }
}

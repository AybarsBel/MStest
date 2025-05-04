import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/settings_repository.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleDarkMode extends SettingsEvent {
  final bool darkMode;

  const ToggleDarkMode(this.darkMode);

  @override
  List<Object> get props => [darkMode];
}

class UpdateDefaultMembershipDuration extends SettingsEvent {
  final int days;

  const UpdateDefaultMembershipDuration(this.days);

  @override
  List<Object> get props => [days];
}

class UpdateDefaultPaymentType extends SettingsEvent {
  final String type;

  const UpdateDefaultPaymentType(this.type);

  @override
  List<Object> get props => [type];
}

class ToggleAutoBackup extends SettingsEvent {
  final bool autoBackup;

  const ToggleAutoBackup(this.autoBackup);

  @override
  List<Object> get props => [autoBackup];
}

class ToggleNotifications extends SettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

class UpdateRenewalReminderDays extends SettingsEvent {
  final int days;

  const UpdateRenewalReminderDays(this.days);

  @override
  List<Object> get props => [days];
}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final bool darkMode;
  final int defaultMembershipDuration;
  final String defaultPaymentType;
  final bool autoBackup;
  final bool notificationsEnabled;
  final int renewalReminderDays;
  final DateTime? lastBackupDate;

  const SettingsLoaded({
    required this.darkMode,
    required this.defaultMembershipDuration,
    required this.defaultPaymentType,
    required this.autoBackup,
    required this.notificationsEnabled,
    required this.renewalReminderDays,
    this.lastBackupDate,
  });

  @override
  List<Object> get props => [
        darkMode,
        defaultMembershipDuration,
        defaultPaymentType,
        autoBackup,
        notificationsEnabled,
        renewalReminderDays,
        if (lastBackupDate != null) lastBackupDate!,
      ];

  SettingsLoaded copyWith({
    bool? darkMode,
    int? defaultMembershipDuration,
    String? defaultPaymentType,
    bool? autoBackup,
    bool? notificationsEnabled,
    int? renewalReminderDays,
    DateTime? lastBackupDate,
  }) {
    return SettingsLoaded(
      darkMode: darkMode ?? this.darkMode,
      defaultMembershipDuration: defaultMembershipDuration ?? this.defaultMembershipDuration,
      defaultPaymentType: defaultPaymentType ?? this.defaultPaymentType,
      autoBackup: autoBackup ?? this.autoBackup,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      renewalReminderDays: renewalReminderDays ?? this.renewalReminderDays,
      lastBackupDate: lastBackupDate ?? this.lastBackupDate,
    );
  }
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc({required this.settingsRepository}) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<UpdateDefaultMembershipDuration>(_onUpdateDefaultMembershipDuration);
    on<UpdateDefaultPaymentType>(_onUpdateDefaultPaymentType);
    on<ToggleAutoBackup>(_onToggleAutoBackup);
    on<ToggleNotifications>(_onToggleNotifications);
    on<UpdateRenewalReminderDays>(_onUpdateRenewalReminderDays);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(SettingsLoading());
    try {
      final darkMode = await settingsRepository.getDarkMode();
      final defaultMembershipDuration = await settingsRepository.getDefaultMembershipDuration();
      final defaultPaymentType = await settingsRepository.getDefaultPaymentType();
      final autoBackup = await settingsRepository.getAutoBackup();
      final notificationsEnabled = await settingsRepository.getNotificationsEnabled();
      final renewalReminderDays = await settingsRepository.getRenewalReminderDays();
      final lastBackupDate = await settingsRepository.getLastBackupDate();

      emit(SettingsLoaded(
        darkMode: darkMode,
        defaultMembershipDuration: defaultMembershipDuration,
        defaultPaymentType: defaultPaymentType,
        autoBackup: autoBackup,
        notificationsEnabled: notificationsEnabled,
        renewalReminderDays: renewalReminderDays,
        lastBackupDate: lastBackupDate,
      ));
    } catch (e) {
      emit(SettingsError('Ayarlar yüklenirken bir hata oluştu: $e'));
    }
  }

  void _onToggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await settingsRepository.setDarkMode(event.darkMode);
        emit(currentState.copyWith(darkMode: event.darkMode));
      } catch (e) {
        emit(SettingsError('Tema ayarı değiştirilirken bir hata oluştu: $e'));
        emit(currentState); // Önceki duruma geri dön
      }
    }
  }

  void _onUpdateDefaultMembershipDuration(UpdateDefaultMembershipDuration event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await settingsRepository.setDefaultMembershipDuration(event.days);
        emit(currentState.copyWith(defaultMembershipDuration: event.days));
      } catch (e) {
        emit(SettingsError('Varsayılan üyelik süresi değiştirilirken bir hata oluştu: $e'));
        emit(currentState); // Önceki duruma geri dön
      }
    }
  }

  void _onUpdateDefaultPaymentType(UpdateDefaultPaymentType event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await settingsRepository.setDefaultPaymentType(event.type);
        emit(currentState.copyWith(defaultPaymentType: event.type));
      } catch (e) {
        emit(SettingsError('Varsayılan ödeme tipi değiştirilirken bir hata oluştu: $e'));
        emit(currentState); // Önceki duruma geri dön
      }
    }
  }

  void _onToggleAutoBackup(ToggleAutoBackup event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await settingsRepository.setAutoBackup(event.autoBackup);
        emit(currentState.copyWith(autoBackup: event.autoBackup));
      } catch (e) {
        emit(SettingsError('Otomatik yedekleme ayarı değiştirilirken bir hata oluştu: $e'));
        emit(currentState); // Önceki duruma geri dön
      }
    }
  }

  void _onToggleNotifications(ToggleNotifications event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await settingsRepository.setNotificationsEnabled(event.enabled);
        emit(currentState.copyWith(notificationsEnabled: event.enabled));
      } catch (e) {
        emit(SettingsError('Bildirim ayarı değiştirilirken bir hata oluştu: $e'));
        emit(currentState); // Önceki duruma geri dön
      }
    }
  }

  void _onUpdateRenewalReminderDays(UpdateRenewalReminderDays event, Emitter<SettingsState> emit) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      try {
        await settingsRepository.setRenewalReminderDays(event.days);
        emit(currentState.copyWith(renewalReminderDays: event.days));
      } catch (e) {
        emit(SettingsError('Yenileme hatırlatma süresi değiştirilirken bir hata oluştu: $e'));
        emit(currentState); // Önceki duruma geri dön
      }
    }
  }
}
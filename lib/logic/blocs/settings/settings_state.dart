part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object?> get props => [];
}

// Başlangıç durumu
class SettingsInitial extends SettingsState {}

// Yükleniyor durumu
class SettingsLoading extends SettingsState {}

// Ayarlar yüklendi durumu
class SettingsLoaded extends SettingsState {
  final Map<String, dynamic> allSettings;
  final String language;
  final bool darkMode;
  final bool notificationsEnabled;
  
  const SettingsLoaded({
    required this.allSettings,
    required this.language,
    required this.darkMode,
    required this.notificationsEnabled,
  });
  
  @override
  List<Object> get props => [allSettings, language, darkMode, notificationsEnabled];
}

// Ayar işlemi tamamlandı durumu
class SettingOperationSuccess extends SettingsState {
  final String message;
  
  const SettingOperationSuccess(this.message);
  
  @override
  List<Object> get props => [message];
}

// Hata durumu
class SettingsError extends SettingsState {
  final String message;
  
  const SettingsError(this.message);
  
  @override
  List<Object> get props => [message];
}
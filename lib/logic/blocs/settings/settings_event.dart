part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
  
  @override
  List<Object?> get props => [];
}

// Tüm ayarları yükleme eventi
class LoadSettings extends SettingsEvent {}

// Dil değiştirme eventi
class ChangeLanguage extends SettingsEvent {
  final String languageCode;
  
  const ChangeLanguage(this.languageCode);
  
  @override
  List<Object> get props => [languageCode];
}

// Karanlık mod değiştirme eventi
class ToggleDarkMode extends SettingsEvent {
  final bool enabled;
  
  const ToggleDarkMode(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

// Bildirim ayarlarını değiştirme eventi
class ToggleNotifications extends SettingsEvent {
  final bool enabled;
  
  const ToggleNotifications(this.enabled);
  
  @override
  List<Object> get props => [enabled];
}

// Genel ayar güncelleme eventi
class UpdateSetting extends SettingsEvent {
  final String key;
  final String value;
  
  const UpdateSetting({
    required this.key,
    required this.value,
  });
  
  @override
  List<Object> get props => [key, value];
}
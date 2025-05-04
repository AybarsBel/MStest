import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/text_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/settings_repository.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'presentation/router/app_router.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final SettingsRepository settingsRepository;
  
  const MyApp({
    Key? key,
    required this.sharedPreferences,
    required this.settingsRepository,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        bool darkMode = true; // Varsayılan olarak koyu tema
        
        if (state is SettingsLoaded) {
          darkMode = state.darkMode;
        }
        
        return MaterialApp(
          title: TextConstants.appTitle,
          theme: darkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: AppConstants.routeHome,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
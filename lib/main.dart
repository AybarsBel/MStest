import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/datasources/local/database_helper.dart';
import 'data/repositories/member_repository.dart';
import 'data/repositories/payment_repository.dart';
import 'data/repositories/settings_repository.dart';
import 'logic/blocs/member/member_bloc.dart';
import 'logic/blocs/payment/payment_bloc.dart';
import 'logic/blocs/settings/settings_bloc.dart';
import 'logic/cubits/qr_code/qr_code_cubit.dart';

void main() async {
  // Flutter widget bağlamasını başlat
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ekran yönünü dikey olarak sabitle
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Dependency Injection
  final databaseHelper = DatabaseHelper();
  final memberRepository = MemberRepository(databaseHelper);
  final paymentRepository = PaymentRepository(databaseHelper);
  final settingsRepository = SettingsRepository(databaseHelper);
  
  // Uygulama başlangıç ayarlarını yükle
  await settingsRepository.initSettings();
  
  // SharedPreferences örneğini başlat
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MemberBloc>(
          create: (context) => MemberBloc(memberRepository: memberRepository),
        ),
        BlocProvider<PaymentBloc>(
          create: (context) => PaymentBloc(paymentRepository: paymentRepository),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(settingsRepository: settingsRepository)
            ..add(LoadSettings()),
        ),
        BlocProvider<QrCodeCubit>(
          create: (context) => QrCodeCubit(memberRepository: memberRepository),
        ),
      ],
      child: MyApp(
        sharedPreferences: sharedPreferences,
        settingsRepository: settingsRepository,
      ),
    ),
  );
}
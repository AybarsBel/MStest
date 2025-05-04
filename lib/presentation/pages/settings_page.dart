import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../logic/blocs/settings/settings_bloc.dart';
import '../../logic/cubits/backup/backup_cubit.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  final _membershipFeeController = TextEditingController();
  
  bool _isLoading = false;
  bool _isBackingUp = false;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    // Ayarları yükle
    context.read<SettingsBloc>().add(LoadSettings());
  }

  @override
  void dispose() {
    _membershipFeeController.dispose();
    super.dispose();
  }

  void _updateMembershipFee() {
    if (_formKey.currentState?.validate() ?? false) {
      final fee = double.tryParse(_membershipFeeController.text);
      if (fee != null) {
        setState(() {
          _isLoading = true;
        });
        context.read<SettingsBloc>().add(UpdateMembershipFee(fee));
      }
    }
  }

  void _backupData() {
    setState(() {
      _isBackingUp = true;
    });
    context.read<BackupCubit>().backupData();
  }

  void _restoreData() {
    setState(() {
      _isRestoring = true;
    });
    context.read<BackupCubit>().restoreData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TextConstants.settings,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is SettingsLoaded) {
                setState(() {
                  _membershipFeeController.text = state.membershipFee.toString();
                  _isLoading = false;
                });
              } else if (state is SettingsError) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is SettingsUpdated) {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<BackupCubit, BackupState>(
            listener: (context, state) {
              if (state is BackupSuccess) {
                setState(() {
                  _isBackingUp = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is BackupError) {
                setState(() {
                  _isBackingUp = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is RestoreSuccess) {
                setState(() {
                  _isRestoring = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                // Ayarları yeniden yükle
                context.read<SettingsBloc>().add(LoadSettings());
              } else if (state is RestoreError) {
                setState(() {
                  _isRestoring = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ücret ayarları
              _buildSettingsSection(
                title: 'Ücret Ayarları',
                icon: Icons.attach_money,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        label: TextConstants.membershipFee,
                        controller: _membershipFeeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        prefixIcon: const Icon(
                          Icons.paid,
                          color: ColorConstants.primaryRed,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TextConstants.requiredField;
                          }
                          final fee = double.tryParse(value);
                          if (fee == null || fee <= 0) {
                            return 'Geçerli bir ücret giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Ücreti Güncelle',
                        icon: Icons.save,
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _updateMembershipFee,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Dil ayarları
              _buildSettingsSection(
                title: 'Dil Ayarları',
                icon: Icons.language,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorConstants.surfaceBlack,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        TextConstants.appLanguage,
                        style: TextStyle(
                          color: ColorConstants.textWhite,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstants.primaryRed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.check_circle,
                              color: ColorConstants.primaryRed,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              TextConstants.turkish,
                              style: TextStyle(
                                color: ColorConstants.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Yedekleme ve geri yükleme
              _buildSettingsSection(
                title: 'Yedekleme ve Geri Yükleme',
                icon: Icons.backup,
                child: Column(
                  children: [
                    CustomButton(
                      text: TextConstants.backup,
                      icon: Icons.backup,
                      isLoading: _isBackingUp,
                      onPressed: _isBackingUp ? null : _backupData,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: TextConstants.restore,
                      icon: Icons.restore,
                      type: ButtonType.outlined,
                      isLoading: _isRestoring,
                      onPressed: _isRestoring ? null : _restoreData,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Uygulama bilgileri
              _buildSettingsSection(
                title: 'Uygulama Bilgileri',
                icon: Icons.info,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorConstants.surfaceBlack,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      _InfoRow(label: 'Uygulama Adı', value: 'Ms Fitness'),
                      SizedBox(height: 8),
                      _InfoRow(label: 'Versiyon', value: '1.0.0'),
                      SizedBox(height: 8),
                      _InfoRow(
                        label: 'Geliştirici',
                        value: 'Ms Fitness',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: ColorConstants.primaryRed,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorConstants.textWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            color: ColorConstants.dividerColor,
            thickness: 1,
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ColorConstants.textGrey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: ColorConstants.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

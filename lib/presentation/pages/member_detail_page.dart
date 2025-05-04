import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../core/utils/date_util.dart';
import '../../data/models/member.dart';
import '../../data/models/payment.dart';
import '../../logic/blocs/member/member_bloc.dart';
import '../../logic/blocs/payment/payment_bloc.dart';
import '../../logic/blocs/settings/settings_bloc.dart';
import '../../logic/cubits/qr_code/qr_code_cubit.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/qr/qr_code_widget.dart';

class MemberDetailPage extends StatefulWidget {
  final String memberId;

  const MemberDetailPage({
    Key? key,
    required this.memberId,
  }) : super(key: key);

  @override
  State<MemberDetailPage> createState() => _MemberDetailPageState();
}

class _MemberDetailPageState extends State<MemberDetailPage> {
  Member? _member;
  Payment? _latestPayment;
  bool _isLoading = false;
  double _membershipFee = AppConstants.defaultMembershipFee;
  final GlobalKey _qrKey = GlobalKey();
  bool _showQrCode = false;

  @override
  void initState() {
    super.initState();
    _loadMemberData();
    _loadPaymentData();
    _loadSettings();
  }

  void _loadMemberData() {
    final memberBloc = context.read<MemberBloc>();
    memberBloc.add(LoadMembers());
    
    // MemberBloc üzerinden member'ı alabilmek için bir yardımcı fonksiyon
    // Gerçek uygulamada bloc üzerinden tek üye getirme fonksiyonu daha uygun olur
    Future.delayed(const Duration(milliseconds: 500), () async {
      final state = memberBloc.state;
      if (state is MembersLoaded) {
        final member = state.members.firstWhere(
          (m) => m.id == widget.memberId,
          orElse: () => Member(fullName: 'Üye Bulunamadı'),
        );
        
        setState(() {
          _member = member;
        });
      }
    });
  }

  void _loadPaymentData() {
    final paymentBloc = context.read<PaymentBloc>();
    paymentBloc.add(LoadLatestMemberPayment(widget.memberId));
  }

  void _loadSettings() {
    context.read<SettingsBloc>().add(LoadSettings());
  }

  void _generateQrCode() {
    if (_member != null) {
      context.read<QrCodeCubit>().generateQrCode(_member!.id);
      setState(() {
        _showQrCode = true;
      });
    }
  }

  void _exportQrAsPng() {
    if (_member != null) {
      context.read<QrCodeCubit>().exportQrAsPng(_qrKey, _member!.id);
    }
  }

  void _exportQrAsPdf() {
    if (_member != null) {
      context.read<QrCodeCubit>().exportQrAsPdf(_qrKey, _member!.id, _member!.fullName);
    }
  }

  void _makePayment() {
    if (_member != null) {
      setState(() {
        _isLoading = true;
      });

      // Yeni ödeme oluştur
      final newPayment = Payment(
        memberId: _member!.id,
        amount: _membershipFee,
        paymentDate: DateTime.now(),
      );

      // Üye durumunu güncelle
      final updatedMember = _member!.copyWith(status: AppConstants.statusActive);
      
      // Veritabanına kaydet
      context.read<MemberBloc>().add(UpdateMember(updatedMember));
      context.read<PaymentBloc>().add(AddPayment(newPayment));

      // Verileri yeniden yükle
      Future.delayed(const Duration(milliseconds: 500), () {
        _loadMemberData();
        _loadPaymentData();
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  void _showDeactivateConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Üye Pasif Yapılsın mı?'),
        content: const Text(
          'Bu üye pasif listeye taşınacak. Bu işlem geri alınabilir. Devam etmek istiyor musunuz?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deactivateMember();
            },
            child: const Text(
              'Pasif Yap',
              style: TextStyle(color: ColorConstants.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _deactivateMember() {
    if (_member != null) {
      setState(() {
        _isLoading = true;
      });

      context.read<MemberBloc>().add(DeactivateMember(_member!.id));

      // Üye listesine geri dön
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Üye Detayı',
        actions: [
          if (_member != null && _member!.isActive)
            IconButton(
              onPressed: _showDeactivateConfirmation,
              icon: const Icon(
                Icons.person_off,
                color: ColorConstants.primaryRed,
              ),
              tooltip: TextConstants.makeInactive,
            ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<PaymentBloc, PaymentState>(
            listener: (context, state) {
              if (state is LatestMemberPaymentLoaded) {
                setState(() {
                  _latestPayment = state.payment;
                });
              } else if (state is PaymentAdded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ödeme başarıyla kaydedildi')),
                );
                _loadPaymentData();
              }
            },
          ),
          BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              if (state is SettingsLoaded) {
                setState(() {
                  _membershipFee = state.membershipFee;
                });
              }
            },
          ),
          BlocListener<QrCodeCubit, QrCodeState>(
            listener: (context, state) {
              if (state is QrCodeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is QrCodeExported) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'QR kod ${state.format} olarak kaydedildi: ${state.filePath}',
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: _member == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showQrCode)
                      BlocBuilder<QrCodeCubit, QrCodeState>(
                        builder: (context, state) {
                          if (state is QrCodeGenerated) {
                            return Column(
                              children: [
                                QrCodeWidget(
                                  qrData: state.qrData,
                                  member: state.member,
                                  qrKey: _qrKey,
                                  onExportPng: _exportQrAsPng,
                                  onExportPdf: _exportQrAsPdf,
                                ),
                                const SizedBox(height: 24),
                                CustomButton(
                                  text: 'QR Kodu Kapat',
                                  icon: Icons.close,
                                  type: ButtonType.outlined,
                                  onPressed: () {
                                    setState(() {
                                      _showQrCode = false;
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),
                                const Divider(),
                                const SizedBox(height: 24),
                              ],
                            );
                          } else if (state is QrCodeLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    if (!_showQrCode) _buildMemberInfo(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMemberInfo() {
    if (_member == null) return const SizedBox();

    // Üyelik durumuna göre renk
    Color statusColor;
    switch (_member!.status) {
      case 'Aktif':
        statusColor = ColorConstants.statusActive;
        break;
      case 'Borçlu':
        statusColor = ColorConstants.statusOverdue;
        break;
      default:
        statusColor = ColorConstants.statusInactive;
    }

    // Kalan gün hesapla
    int remainingDays = 0;
    DateTime? expiryDate;
    bool isExpired = false;
    
    if (_latestPayment != null) {
      expiryDate = _latestPayment!.expiryDate;
      final now = DateTime.now();
      remainingDays = expiryDate.difference(now).inDays;
      isExpired = now.isAfter(expiryDate);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Üye bilgileri kartı
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Profil fotoğrafı
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: ColorConstants.primaryRed,
                    backgroundImage: _member!.profileImagePath != null && _member!.profileImagePath!.isNotEmpty
                        ? FileImage(File(_member!.profileImagePath!))
                        : null,
                    child: _member!.profileImagePath == null || _member!.profileImagePath!.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                // Üye adı
                Text(
                  _member!.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textWhite,
                  ),
                ),
                const SizedBox(height: 8),
                // Üyelik durumu
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _member!.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                // Üye detay bilgileri
                _buildInfoRow(
                  label: TextConstants.phoneNumber,
                  value: _member!.phoneNumber ?? '',
                  icon: Icons.phone,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  label: TextConstants.birthDate,
                  value: _member!.birthDate != null
                      ? DateFormat(AppConstants.dateFormat).format(_member!.birthDate!)
                      : '',
                  icon: Icons.cake,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  label: TextConstants.bloodType,
                  value: _member!.bloodType ?? '',
                  icon: Icons.bloodtype,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  label: TextConstants.registrationDate,
                  value: DateFormat(AppConstants.dateFormat).format(_member!.registrationDate),
                  icon: Icons.calendar_today,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Üyelik detayları
        if (_latestPayment != null)
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.card_membership, color: ColorConstants.primaryRed),
                      SizedBox(width: 8),
                      Text(
                        TextConstants.membershipInfo,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textWhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // Son ödeme bilgisi
                  _buildInfoRow(
                    label: 'Son Ödeme Tarihi',
                    value: DateFormat(AppConstants.dateFormat).format(_latestPayment!.paymentDate),
                    icon: Icons.payment,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    label: 'Bitiş Tarihi',
                    value: DateFormat(AppConstants.dateFormat).format(expiryDate!),
                    icon: Icons.event,
                  ),
                  const SizedBox(height: 12),
                  // Kalan gün bilgisi
                  _buildInfoRow(
                    label: TextConstants.daysLeft,
                    value: isExpired ? 'Süresi Doldu' : '$remainingDays gün',
                    icon: Icons.timer,
                    valueColor: isExpired
                        ? ColorConstants.statusOverdue
                        : remainingDays <= 7
                            ? ColorConstants.statusWarning
                            : ColorConstants.statusActive,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    label: 'Ödeme Tutarı',
                    value: '${_latestPayment!.amount.toStringAsFixed(2)} ${AppConstants.currency}',
                    icon: Icons.monetization_on,
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 32),
        // İşlem butonları
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: ColorConstants.primaryRed,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            color: ColorConstants.textGrey,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? ColorConstants.textWhite,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_member == null) return const SizedBox();

    // Ödeme ve QR kod butonları
    return Column(
      children: [
        if (_member!.status == AppConstants.statusOverdue)
          CustomButton(
            text: TextConstants.markAsPaid,
            icon: Icons.check_circle,
            isLoading: _isLoading,
            onPressed: _makePayment,
          ),
        const SizedBox(height: 16),
        CustomButton(
          text: TextConstants.generateQrCode,
          icon: Icons.qr_code,
          type: ButtonType.outlined,
          onPressed: _generateQrCode,
        ),
      ],
    );
  }
}

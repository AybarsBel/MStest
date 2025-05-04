import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../core/constants/app_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../core/utils/permission_util.dart';
import '../../data/models/member.dart';
import '../../data/models/payment.dart';
import '../../logic/blocs/member/member_bloc.dart';
import '../../logic/blocs/payment/payment_bloc.dart';
import '../../logic/blocs/settings/settings_bloc.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/custom_text_field.dart';
import 'package:intl/intl.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  
  String? _selectedBloodType;
  DateTime? _selectedBirthDate;
  File? _profileImage;
  bool _isLoading = false;
  double _membershipFee = AppConstants.defaultMembershipFee;

  @override
  void initState() {
    super.initState();
    // Üyelik ücretini yükle
    context.read<SettingsBloc>().add(LoadSettings());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: ColorConstants.primaryRed,
              onPrimary: Colors.white,
              surface: ColorConstants.surfaceBlack,
              onSurface: ColorConstants.textWhite,
            ),
            dialogBackgroundColor: ColorConstants.backgroundBlack,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
        _birthDateController.text = DateFormat(AppConstants.dateFormat).format(pickedDate);
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraPermission = await PermissionUtil.requestCameraPermission();
      if (!cameraPermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(TextConstants.cameraPermissionRequired)),
        );
        return;
      }
    } else {
      final storagePermission = await PermissionUtil.requestStoragePermission();
      if (!storagePermission) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(TextConstants.storagePermissionRequired)),
        );
        return;
      }
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 600,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Resim seçilirken hata oluştu: $e')),
      );
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fotoğraf Seç'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: ColorConstants.primaryRed,
                ),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: ColorConstants.primaryRed,
                ),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveMember() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Yeni üye oluştur
      final newMember = Member(
        fullName: _nameController.text.trim(),
        birthDate: _selectedBirthDate,
        phoneNumber: _phoneController.text.trim(),
        bloodType: _selectedBloodType,
        registrationDate: DateTime.now(),
        profileImagePath: _profileImage?.path,
        status: 'Aktif',
      );

      // Üye kaydet
      context.read<MemberBloc>().add(AddMember(newMember));

      // Üyelik ödemesi kaydet
      final newPayment = Payment(
        memberId: newMember.id,
        amount: _membershipFee,
        paymentDate: DateTime.now(),
      );

      context.read<PaymentBloc>().add(AddPayment(newPayment));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TextConstants.addMember,
      ),
      body: BlocListener<MemberBloc, MemberState>(
        listener: (context, state) {
          if (state is MemberError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is MemberActionSuccess) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pop(context);
          }
        },
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoaded) {
              setState(() {
                _membershipFee = state.membershipFee;
              });
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profil fotoğrafı
                  Center(
                    child: GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: ColorConstants.primaryRed,
                            backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                            child: _profileImage == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstants.primaryRed,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Üye bilgileri
                  CustomTextField(
                    label: TextConstants.fullName,
                    hint: 'Ad Soyad giriniz',
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return TextConstants.requiredField;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: TextConstants.birthDate,
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: () => _pickBirthDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: ColorConstants.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: TextConstants.phoneNumber,
                    hint: '05XX XXX XXXX',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != 11 || !value.startsWith('0')) {
                          return TextConstants.invalidPhoneNumber;
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        TextConstants.bloodType,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: ColorConstants.textWhite,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: ColorConstants.surfaceBlack,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            hint: const Text(
                              'Kan Grubu Seçiniz',
                              style: TextStyle(color: ColorConstants.textGrey),
                            ),
                            value: _selectedBloodType,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: ColorConstants.primaryRed,
                            ),
                            dropdownColor: ColorConstants.surfaceBlack,
                            items: AppConstants.bloodTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                    color: ColorConstants.textWhite,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedBloodType = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Ödeme bilgisi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorConstants.surfaceBlack,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorConstants.primaryRed.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Üyelik Bilgisi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textWhite,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Üyelik Ücreti:',
                              style: TextStyle(
                                color: ColorConstants.textWhite,
                              ),
                            ),
                            Text(
                              '${_membershipFee.toStringAsFixed(2)} ${AppConstants.currency}',
                              style: const TextStyle(
                                color: ColorConstants.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Üyelik Süresi:',
                              style: TextStyle(
                                color: ColorConstants.textWhite,
                              ),
                            ),
                            const Text(
                              '1 Ay',
                              style: TextStyle(
                                color: ColorConstants.primaryRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Kaydet butonu
                  CustomButton(
                    text: TextConstants.save,
                    icon: Icons.save,
                    isLoading: _isLoading,
                    onPressed: _isLoading ? null : _saveMember,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

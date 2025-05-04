import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/text_constants.dart';
import '../../logic/cubits/income_report/income_report_cubit.dart';
import '../widgets/common/custom_app_bar.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/report/income_chart_widget.dart';

class IncomeReportPage extends StatefulWidget {
  const IncomeReportPage({Key? key}) : super(key: key);

  @override
  State<IncomeReportPage> createState() => _IncomeReportPageState();
}

class _IncomeReportPageState extends State<IncomeReportPage> {
  DateTime _startDate = DateTime(DateTime.now().year - 1, DateTime.now().month, 1);
  DateTime _endDate = DateTime.now();
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _loadIncomeReport();
  }

  void _loadIncomeReport() {
    context.read<IncomeReportCubit>().loadIncomeReport(
          startDate: _startDate,
          endDate: _endDate,
        );
  }

  void _exportIncomeReport() {
    setState(() {
      _isExporting = true;
    });
    context.read<IncomeReportCubit>().exportIncomeReportAsPdf();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: _endDate,
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
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _loadIncomeReport();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
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
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _loadIncomeReport();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TextConstants.incomeReport,
      ),
      body: BlocConsumer<IncomeReportCubit, IncomeReportState>(
        listener: (context, state) {
          if (state is IncomeReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            setState(() {
              _isExporting = false;
            });
          } else if (state is IncomeReportExported) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Rapor kaydedildi: ${state.filePath}')),
            );
            setState(() {
              _isExporting = false;
            });
          }
        },
        builder: (context, state) {
          if (state is IncomeReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is IncomeReportLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateFilter(),
                  const SizedBox(height: 24),
                  IncomeChartWidget(
                    monthlyIncome: state.monthlyIncome,
                    totalIncome: state.totalIncome,
                    potentialIncome: state.potentialIncome,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: TextConstants.exportAsPdf,
                    icon: Icons.picture_as_pdf,
                    isLoading: _isExporting,
                    onPressed: _isExporting ? null : _exportIncomeReport,
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Gelir raporu yüklenirken bir hata oluştu.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstants.cardBlack,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            TextConstants.filterByDate,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorConstants.textWhite,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDateSelector(
                  label: TextConstants.startDate,
                  date: _startDate,
                  onTap: () => _selectStartDate(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDateSelector(
                  label: TextConstants.endDate,
                  date: _endDate,
                  onTap: () => _selectEndDate(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ColorConstants.textGrey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: ColorConstants.surfaceBlack,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: ColorConstants.dividerColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(AppConstants.dateFormat).format(date),
                  style: const TextStyle(
                    color: ColorConstants.textWhite,
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: ColorConstants.primaryRed,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

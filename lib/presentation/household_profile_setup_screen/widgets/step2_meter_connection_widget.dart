import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class Step2MeterConnectionWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onDataChanged;

  const Step2MeterConnectionWidget({
    super.key,
    required this.data,
    required this.onDataChanged,
  });

  @override
  State<Step2MeterConnectionWidget> createState() =>
      _Step2MeterConnectionWidgetState();
}

class _Step2MeterConnectionWidgetState
    extends State<Step2MeterConnectionWidget> {
  late TextEditingController _meterIdController;
  bool _isScanning = false;
  bool _isMeterConnected = false;
  bool _isLoading = false;
  String? _meterIdError;
  String _connectionStatus = '';
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    _meterIdController = TextEditingController(
      text: (widget.data['meterId'] as String?) ?? '',
    );
    _isMeterConnected = (widget.data['meterConnected'] as bool?) ?? false;
    if (_isMeterConnected) {
      _connectionStatus = 'Sayaç bağlandı: ${widget.data['meterId']}';
    }
  }

  @override
  void dispose() {
    _meterIdController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _startQRScan() async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'QR tarama web\'de desteklenmemektedir. Lütfen manuel giriş yapın.',
          ),
        ),
      );
      return;
    }
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kamera izni gereklidir.')),
        );
      }
      return;
    }
    setState(() {
      _isScanning = true;
      _scannerController = MobileScannerController();
    });
  }

  void _onQRDetected(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      final scannedId = barcode!.rawValue!;
      setState(() {
        _isScanning = false;
        _meterIdController.text = scannedId;
        _scannerController?.dispose();
        _scannerController = null;
      });
      _connectMeter(scannedId);
    }
  }

  Future<void> _connectMeter(String meterId) async {
    if (meterId.isEmpty) {
      setState(() => _meterIdError = 'Sayaç ID gereklidir');
      return;
    }
    setState(() {
      _isLoading = true;
      _meterIdError = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isMeterConnected = true;
        _connectionStatus = 'Sayaç başarıyla bağlandı: $meterId';
      });
      widget.onDataChanged({'meterId': meterId, 'meterConnected': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _isScanning ? _buildScannerView(theme) : _buildConnectionForm(theme);
  }

  Widget _buildScannerView(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isScanning = false;
                  _scannerController?.dispose();
                  _scannerController = null;
                });
              },
              child: CustomIconWidget(
                iconName: 'arrow_back',
                color: theme.colorScheme.primary,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'QR Kodu Tara',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.primary, width: 2),
          ),
          clipBehavior: Clip.hardEdge,
          child: MobileScanner(
            controller: _scannerController!,
            onDetect: _onQRDetected,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Sayacınızın üzerindeki QR kodu kamera çerçevesine hizalayın.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionForm(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sayaç Bağlantısı',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Luna Elektrik Sayacınızı QR kod ile veya manuel olarak bağlayın.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          // QR Scan Button
          GestureDetector(
            onTap: _startQRScan,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 3.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.15),
                    theme.colorScheme.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code_scanner',
                    color: theme.colorScheme.primary,
                    size: 48,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'QR Kod ile Tara',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Sayacınızdaki QR kodu okutun',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Text(
                  'veya',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Manuel Sayaç ID Girişi',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _meterIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Örn: LUN-2024-XXXXX',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'electric_meter',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    errorText: _meterIdError,
                  ),
                  onChanged: (val) {
                    setState(() => _meterIdError = null);
                    widget.onDataChanged({
                      'meterId': val,
                      'meterConnected': _isMeterConnected,
                    });
                  },
                ),
              ),
              SizedBox(width: 2.w),
              _isLoading
                  ? SizedBox(
                      width: 12.w,
                      height: 6.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () =>
                          _connectMeter(_meterIdController.text.trim()),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(12.w, 6.h),
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                      ),
                      child: Text('Bağla'),
                    ),
            ],
          ),
          if (_isMeterConnected) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: const Color(0xFF4CAF50),
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _connectionStatus,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'help_outline',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Sayaç ID\'nizi sayacınızın ön yüzündeki etikette bulabilirsiniz. Format: LUN-YYYY-XXXXX',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

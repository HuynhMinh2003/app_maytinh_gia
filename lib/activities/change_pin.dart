import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../l10n/app_localizations.dart';
import '../services/pin_service.dart';

class ChangePinScreen extends StatefulWidget {
  final bool openedFromCalculator;

  const ChangePinScreen({Key? key, this.openedFromCalculator = false}) : super(key: key);
  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> with WidgetsBindingObserver{
  final _oldPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  String _error = '';
  bool _isLoading = false;

  Future<void> _changePin() async {
    setState(() {
      _error = '';
      _isLoading = true;
    });

    String oldPin = _oldPinController.text.trim();
    String newPin = _newPinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();

    if (oldPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.fillAllFieldsError;
        _isLoading = false;
      });
      return;
    }

    if (newPin != confirmPin) {
      setState(() {
        _error = AppLocalizations.of(context)!.pinMismatchError;
        _isLoading = false;
      });
      return;
    }

    // Kiểm tra mã PIN cũ
    final isValidOld = await PinService.validatePin(oldPin);
    if (!isValidOld) {
      setState(() {
        _error = AppLocalizations.of(context)!.oldPinIncorrectError;
        _isLoading = false;
      });
      return;
    }

    // Lưu mã PIN mới
    final isSaved = await PinService.savePin(newPin);
    setState(() {
      _isLoading = false;
    });

    if (isSaved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.changePinSuccess),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
      _oldPinController.clear();
      _newPinController.clear();
      _confirmPinController.clear();
    } else {
      setState(() {
        _error = AppLocalizations.of(context)!.changePinFailed;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Thêm observer lifecycle
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      Navigator.of(context).popUntil((route) => route.settings.name == 'CalculatorScreen');
    }
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    WidgetsBinding.instance.removeObserver(this); // Hủy listener lifecycle
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFF022350),
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.changePinButton,
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF022350),
          iconTheme: const IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _buildPinField(
                  controller: _oldPinController,
                  label: AppLocalizations.of(context)!.oldPinLabel,
                  icon: Icons.lock),
              SizedBox(height: 16.h),
              _buildPinField(
                  controller: _newPinController,
                  label: AppLocalizations.of(context)!.newPinLabel,
                  icon: Icons.lock_outline),
              SizedBox(height: 16.h),
              _buildPinField(
                  controller: _confirmPinController,
                  label: AppLocalizations.of(context)!.confirmPinLabel,
                  icon: Icons.lock_outline),
              SizedBox(height: 40.h),
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(color: Colors.red)),
              SizedBox(height: 40.h),
              SizedBox(
                height: 50.h,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePin,
                  child: _isLoading
                      ? SizedBox(
                    height: 40.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text(
                    AppLocalizations.of(context)!.changePinTitle,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontFamily: "Oswald",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinField(
      {required TextEditingController controller,
        required String label,
        required IconData icon}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      keyboardType: TextInputType.number,
      obscureText: true,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'dart:convert';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';

class JoinGroupScreen extends ConsumerStatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  ConsumerState<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends ConsumerState<JoinGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = false;

  @override
  void dispose() {
    controller?.dispose();
    _codeController.dispose();
    super.dispose();
  }

  String? _validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Group code is required';
    }
    if (value.length != 8) {
      return 'Group code must be 8 characters';
    }
    return null;
  }

  Future<void> _joinGroup(String code) async {
    final groupState = ref.read(groupProvider);
    
    // Check if user already has a group
    if (groupState.groups.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only be a member of one group. Please leave your current group first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    final groupNotifier = ref.read(groupProvider.notifier);

    final success = await groupNotifier.joinGroup(code.toUpperCase());

    if (mounted) {
      if (success) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.soloDashboard,
          (route) => false,
        );
      } else {
        final groupState = ref.read(groupProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(groupState.errorMessage ?? 'Failed to join group'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (mounted && !isScanning) {
        isScanning = true;
        try {
          if (scanData.code != null) {
            try {
              final qrData = json.decode(scanData.code!);
              final groupCode = qrData['groupCode'] as String?;
              if (groupCode != null) {
                _codeController.text = groupCode;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR code scanned successfully'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invalid QR code'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } finally {
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              isScanning = false;
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupState = ref.watch(groupProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.join_group),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                size: 100,
                color: Colors.teal,
              ),
              const SizedBox(height: 32),
              Text(
                'Enter Group Code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Get the code from your group admin',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _codeController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 8,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 4,
                ),
                decoration: const InputDecoration(
                  labelText: 'Group Code',
                  hintText: 'ABC12345',
                ),
                validator: _validateCode,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      child: SizedBox(
                        width: 300,
                        height: 400,
                        child: QRView(
                          key: qrKey,
                          onQRViewCreated: _onQRViewCreated,
                          overlay: QrScannerOverlayShape(
                            borderColor: Colors.teal,
                            borderRadius: 10,
                            borderWidth: 10,
                            cutOutSize: 250,
                          ),
                        ),
                      ),
                    ),
                  ).then((_) {
                    controller?.pauseCamera();
                  });
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan QR Code'),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: groupState.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _joinGroup(_codeController.text);
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: groupState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            l10n.join_group,
                            style: const TextStyle(fontSize: 18),
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
}

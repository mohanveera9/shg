import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../services/storage_service.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _cameraEnabled = false;
  bool _storageEnabled = false;
  bool _researchConsent = false;
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions / అనుమతులు'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enable Permissions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'These permissions help improve your experience',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            SwitchListTile(
              title: const Text('Camera / కెమెరా'),
              subtitle: const Text('Take photos for receipts and products'),
              value: _cameraEnabled,
              onChanged: (value) {
                setState(() {
                  _cameraEnabled = value;
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Storage / నిల్వ'),
              subtitle: const Text('Save documents and export reports'),
              value: _storageEnabled,
              onChanged: (value) {
                setState(() {
                  _storageEnabled = value;
                });
              },
            ),
            const Divider(),
            CheckboxListTile(
              title: const Text('Data Sharing Consent'),
              subtitle: const Text('I agree to share data for research purposes'),
              value: _researchConsent,
              onChanged: (value) {
                setState(() {
                  _researchConsent = value ?? false;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _storage.saveOnboardingComplete();
                  if (mounted) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.phoneInput);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Continue / కొనసాగించు',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

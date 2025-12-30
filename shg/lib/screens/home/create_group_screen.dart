import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  final _blockController = TextEditingController();
  final _districtController = TextEditingController();
  final _memberCountController = TextEditingController();
  bool _researchConsent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _villageController.dispose();
    _blockController.dispose();
    _districtController.dispose();
    _memberCountController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
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

      final createdGroup = await groupNotifier.createGroup({
        'name': _nameController.text,
        'village': _villageController.text,
        'block': _blockController.text,
        'district': _districtController.text,
        'researchConsent': _researchConsent,
        'expectedMemberCount': _memberCountController.text.isNotEmpty 
            ? int.tryParse(_memberCountController.text) 
            : null,
      });

      if (mounted) {
        if (createdGroup != null) {
          Navigator.of(context).pushNamed(
            AppRoutes.groupCreated,
            arguments: createdGroup,
          );
        } else {
          final groupState = ref.read(groupProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(groupState.errorMessage ?? 'Failed to create group'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final groupState = ref.watch(groupProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.create_group),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Group Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '${l10n.group_name} *',
                  hintText: 'Enter group name',
                  prefixIcon: const Icon(Icons.group),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Group name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _villageController,
                decoration: InputDecoration(
                  labelText: l10n.village,
                  hintText: 'Enter village name',
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _blockController,
                decoration: InputDecoration(
                  labelText: l10n.block,
                  hintText: 'Enter block name',
                  prefixIcon: const Icon(Icons.map),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: l10n.district,
                  hintText: 'Enter district name',
                  prefixIcon: const Icon(Icons.place),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _memberCountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Expected Member Count',
                  hintText: 'Enter expected number of members (optional)',
                  prefixIcon: const Icon(Icons.people),
                  helperText: 'You can add members anytime after creating the group',
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final count = int.tryParse(value);
                    if (count == null || count < 1) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              CheckboxListTile(
                title: Text(l10n.consent),
                subtitle: const Text('I agree to share data for research purposes'),
                value: _researchConsent,
                onChanged: (value) {
                  setState(() {
                    _researchConsent = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: groupState.isLoading ? null : _createGroup,
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
                            l10n.create_group,
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

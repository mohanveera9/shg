import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/group_provider.dart';
import '../../config/routes.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  final _blockController = TextEditingController();
  final _districtController = TextEditingController();
  bool _researchConsent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _villageController.dispose();
    _blockController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _createGroup() async {
    if (_formKey.currentState!.validate()) {
      final groupProvider = Provider.of<GroupProvider>(context, listen: false);
      
      final success = await groupProvider.createGroup(
        name: _nameController.text,
        village: _villageController.text,
        block: _blockController.text,
        district: _districtController.text,
        researchConsent: _researchConsent,
      );
      
      if (mounted) {
        if (success) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(groupProvider.errorMessage ?? 'Failed to create group'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      body: Consumer<GroupProvider>(
        builder: (context, groupProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Group Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Group Name *',
                      hintText: 'Enter group name',
                      prefixIcon: Icon(Icons.group),
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
                    decoration: const InputDecoration(
                      labelText: 'Village',
                      hintText: 'Enter village name',
                      prefixIcon: Icon(Icons.location_city),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _blockController,
                    decoration: const InputDecoration(
                      labelText: 'Block',
                      hintText: 'Enter block name',
                      prefixIcon: Icon(Icons.map),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _districtController,
                    decoration: const InputDecoration(
                      labelText: 'District',
                      hintText: 'Enter district name',
                      prefixIcon: Icon(Icons.place),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CheckboxListTile(
                    title: const Text('Research Consent'),
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
                      onPressed: groupProvider.isLoading ? null : _createGroup,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: groupProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Create Group',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

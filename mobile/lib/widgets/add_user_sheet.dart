import 'package:dataqube/models/user_entity.dart';
import 'package:dataqube/providers/users_provider.dart';
import 'package:dataqube/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddUserSheet extends StatefulWidget {
  const AddUserSheet({super.key});

  @override
  State<AddUserSheet> createState() => AddUserSheetState();
}

class AddUserSheetState extends State<AddUserSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Add new user',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    AppValidators.minFourChars(value, fieldName: 'Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    AppValidators. minFourChars(value, fieldName: 'Username'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: AppValidators.email,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    AppValidators.minFourChars(value, fieldName: 'City'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState?.validate() ?? false;
                    if (!isValid) {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.onUserInteraction;
                      });
                      return;
                    }

                    final nextUser = UserEntity(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: _nameController.text.trim(),
                      username: _usernameController.text.trim(),
                      email: _emailController.text.trim(),
                      city: _cityController.text.trim(),
                      // Keep API-compatible fields even if not captured in this form.
                      phone: '',
                      website: '',
                      companyName: '',
                    );

                    context.read<UsersProvider>().addUser(nextUser);

                    if (!mounted) return;
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${nextUser.name} added to the list.'),
                      ),
                    );
                  },
                  child: const Text('Save user'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

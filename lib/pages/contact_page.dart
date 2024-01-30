import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trinity_wizards_test/utils/color.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key, this.contact});

  final Map<String, dynamic>? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late TextEditingController firstName, lastName, email, dob;

  DateTime selectedDate = DateTime.now();

  final jsonDateFormat = DateFormat('d/M/yyyy');
  final showDateFormat = DateFormat('dd MMM yyyy');

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstName = TextEditingController();
    lastName = TextEditingController();
    email = TextEditingController();
    dob = TextEditingController();

    if (widget.contact != null) {
      selectedDate = jsonDateFormat.parse(widget.contact!['dob']);
      firstName.text = widget.contact!['firstName'];
      lastName.text = widget.contact!['lastName'];
      email.text = widget.contact!['email'];
      dob.text = showDateFormat.format(selectedDate);
    }

    super.initState();
  }

  @override
  dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    dob.dispose();
    super.dispose();
  }

  saveData() {
    final isValidate = _formKey.currentState?.validate();

    if (isValidate == true) {
      final newData = {
        'id': widget.contact?['id'],
        'firstName': firstName.text,
        'lastName': lastName.text,
        'email': email.text,
        'dob': jsonDateFormat.format(selectedDate),
      };

      Navigator.of(context).pop(newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 2,
        leadingWidth: 72,
        leading: TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColor.primaryColor,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: saveData,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColor.primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// avatar
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: AppColor.primaryColor,
                    radius: 64,
                  ),
                ),
              ),

              /// main information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black38, width: 0.5),
                  ),
                ),
                child: const Text(
                  'Main Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              textField(
                controller: firstName,
                title: 'First Name',
                validator: (value) {
                  if (value == null || value == '') {
                    return 'First Name is required';
                  }

                  return null;
                },
              ),
              textField(
                controller: lastName,
                title: 'Last Name',
                validator: (value) {
                  if (value == null || value == '') {
                    return 'Last Name is required';
                  }

                  return null;
                },
              ),

              /// sub information
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  border: const Border(
                    bottom: BorderSide(color: Colors.black38, width: 0.5),
                  ),
                ),
                child: const Text(
                  'Sub Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              textField(controller: email, title: 'Email'),
              textField(
                controller: dob,
                title: 'DOB',
                showCalendarIcon: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// dynamix Textfield
  Widget textField({
    required TextEditingController controller,
    required String title,
    bool showCalendarIcon = false,
    FormFieldValidator? validator,
  }) =>
      Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: TextFormField(
                  controller: controller,
                  textInputAction: TextInputAction.next,
                  readOnly: title == 'DOB',
                  onTap: title != 'DOB' ? null : selectDate,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(8),
                    suffixIcon: showCalendarIcon
                        ? const Icon(
                            Icons.calendar_today_rounded,
                          )
                        : null,
                  ),
                  validator: validator,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          const Divider(
            indent: 16,
          ),
        ],
      );

  /// Select DOB
  void selectDate() {
    showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDate: selectedDate,
    ).then((value) {
      if (value != null) {
        selectedDate = value;

        dob.text = showDateFormat.format(selectedDate);

        setState(() {});
      }
    });
  }
}

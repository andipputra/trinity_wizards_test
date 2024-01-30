import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late TextEditingController firstName, lastName, email, dob;

  @override
  void initState() {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    firstName = TextEditingController(text: args['firstName']);
    lastName = TextEditingController(text: args['lastName']);
    email = TextEditingController(text: args['email']);
    dob = TextEditingController(text: args['dob']);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

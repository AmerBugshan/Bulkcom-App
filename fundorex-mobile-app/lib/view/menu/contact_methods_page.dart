import 'package:flutter/material.dart';

class ContactMethodsPage extends StatelessWidget {
  const ContactMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('طرق التواصل')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'يمكنك التواصل معنا عبر الطرق التالية:\n\n'
              '📧 البريد الإلكتروني: info@bulk.com.sa\n'
              '📞 الهاتف / واتساب: +966535243579\n\n'
              'نحن هنا لخدمتك في أي وقت!',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

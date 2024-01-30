import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trinity_wizards_test/pages/contact_page.dart';
import 'package:trinity_wizards_test/utils/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final listContact = <Map<String, dynamic>>[];

  bool isLoading = false;

  @override
  void initState() {
    getDataFromJson();
    super.initState();
  }

  getDataFromJson() async {
    setState(() {
      isLoading = true;
    });

    listContact.clear();

    final stringJson = await rootBundle.loadString('assets/data.json');

    final dataFromJson = await json.decode(stringJson) as List;

    for (var contact in dataFromJson) {
      listContact.add(contact);
    }

    setState(() {
      isLoading = false;
    });

    log('data json', error: listContact.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 2,
        title: const Text('Contacts'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              color: AppColor.primaryColor,
            ),
            iconSize: 24,
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: AppColor.primaryColor,
          ),
          iconSize: 24,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                getDataFromJson();
                return;
              },
              child: GridView.builder(
                  itemCount: listContact.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (context, index) {
                    final dataContact = listContact[index];

                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) => ContactPage(
                              contact: dataContact,
                            ),
                          ),
                        )
                            .then((value) {
                          if (value != null && value is Map<String, dynamic>) {
                            listContact[index] = value;

                            setState(() {});
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor: AppColor.primaryColor,
                              radius: 24,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              '${dataContact["firstName"]} ${dataContact["lastName"]}',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}

import 'dart:convert';

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

  final showedListContact = <Map<String, dynamic>>[];

  bool isLoading = false, isSearch = false;

  late TextEditingController searchController;

  @override
  void initState() {
    searchController = TextEditingController();
    getDataFromJson();
    super.initState();

    searchController.addListener(() {
      showedListContact.clear();

      List<Map<String, dynamic>> sortedList = [];

      if (searchController.text.isEmpty) {
        sortedList = listContact;
      } else {
        sortedList = listContact
            .where((element) =>
                element['firstName']
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                element['lastName']
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
            .toList();
      }

      showedListContact.addAll(sortedList);

      setState(() {});
    });
  }

  @override
  dispose() {
    super.dispose();

    searchController.dispose();
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

    showedListContact.addAll(listContact);

    setState(() {
      isLoading = false;
    });
  }

  goToContactPage(int? index) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ContactPage(
          contact: index != null ? showedListContact[index] : null,
        ),
      ),
    )
        .then((value) {
      if (value != null && value is Map<String, dynamic>) {
        if (value['id'] != null) {
          final contactIndex =
              listContact.indexWhere((element) => element['id'] == value['id']);

          listContact[contactIndex] = value;
        } else {
          listContact.add(value);
        }

        setState(() {});
      }
    });
  }

  Widget searchAppBar() => TextFormField(
        controller: searchController,
        decoration: const InputDecoration(
          hintText: 'Search Contact',
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 2,
        title: isSearch ? searchAppBar() : const Text('Contacts'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              goToContactPage(null);
            },
            icon: const Icon(
              Icons.add,
              color: AppColor.primaryColor,
            ),
            iconSize: 24,
          ),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              isSearch = !isSearch;
            });
          },
          icon: Icon(
            isSearch ? Icons.arrow_back : Icons.search,
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
                  itemCount: showedListContact.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                  ),
                  padding: const EdgeInsets.all(24),
                  itemBuilder: (context, index) {
                    final dataContact = showedListContact[index];

                    return InkWell(
                      onTap: () {
                        goToContactPage(index);
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

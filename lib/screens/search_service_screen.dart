import 'package:citizen/constants/constancts.dart';
import 'package:citizen/providers/services_provider.dart';
import 'package:citizen/screens/service_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/service_model.dart';
import '../themes.dart';

class SearchSearchScreen extends StatefulWidget {
  const SearchSearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchSearchScreen> createState() => _SearchSearchScreenState();
}

class _SearchSearchScreenState extends State<SearchSearchScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: TextField(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search here...',
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          style: const TextStyle(color: Colors.grey, fontSize: 16),
          onChanged: (String? val) {
            setState(() {
              searchText = val!;
            });
          },
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.iconLightGrey,
            )),
      ),
      body: Consumer<ServicesProvider>(
        builder: (context, provider, child) {
          return provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.mainColor,
                  ),
                )
              : ListView.builder(
                  itemCount: provider.services.length,
                  itemBuilder: (context, index) {
                    if (searchText.isEmpty) {
                      return textWidget(provider.services[index]);
                    } else if (provider.services[index].name!.toLowerCase() .contains(
                        searchText.toLowerCase())) {
                      return textWidget(provider.services[index]);
                    } else {
                      return const SizedBox();
                    }
                  });
        },
      ),
    );
  }

  Widget textWidget(ServiceModel service) {
    return InkWell(
      onTap: () {
        nextScreen(context, ServiceScreen(id: service.id!));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
        child: Text(
          service.name!,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

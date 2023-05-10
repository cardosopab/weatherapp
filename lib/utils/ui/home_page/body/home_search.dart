import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../services/geocoding_list.dart';

class HomeSearchBar extends StatefulHookConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends ConsumerState<HomeSearchBar> {
  @override
  Widget build(BuildContext context) {
    final addressController = useTextEditingController();
    final geocodingList = ref.watch(geoCodingProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
          suffixIcon: Visibility(
            visible: addressController.text.isNotEmpty || geocodingList.isNotEmpty,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.clear),
              onPressed: () {
                addressController.clear();
                ref.read(geoCodingProvider.notifier).deleteList();
              },
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          hintText: 'Search by city.',
          filled: true,
          fillColor: Colors.transparent,
        ),
        controller: addressController,
        onSubmitted: (value) async {
          if (value.isNotEmpty) {
            await ref.watch(geoCodingProvider.notifier).fetchGeocode(value);
            addressController.clear();
          }
        },
        onChanged: (value) {
          setState(() {});
          // if (_debounce?.isActive ?? false) _debounce!.cancel();
          // _debounce = Timer(const Duration(milliseconds: 1000), () {
          //   if (value.isNotEmpty) {
          //   } else {
          //     clear();
          //   }
          // });
        },
      ),
    );
  }
}

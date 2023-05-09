import 'package:flutter/material.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:weatherapp/utils/ui/home_page/home_geocoding_list.dart';

import 'home_footer.dart';
import 'home_location_list.dart';
import 'home_search.dart';
import 'home_title.dart';

class HomeBody extends HookConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const HomeTitle(),
          const HomeSearchBar(),
          const HomeGeocodingList(),
          const HomeLocationList(),
          const HomeFooter(),
        ],
      ),
    );
  }
}

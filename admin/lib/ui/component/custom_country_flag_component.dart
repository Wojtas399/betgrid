import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';

import '../extensions/build_context_extensions.dart';

class CustomCountryFlag extends StatelessWidget {
  final String countryAlpha2Code;

  const CustomCountryFlag({super.key, required this.countryAlpha2Code});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: context.colorScheme.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CountryFlag.fromCountryCode(countryAlpha2Code),
      ),
    );
  }
}

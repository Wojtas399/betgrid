import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RaceBetScreen extends StatelessWidget {
  final String? grandPrixId;

  const RaceBetScreen({
    super.key,
    @PathParam('grandPrixId') this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wyścig'),
      ),
    );
  }
}

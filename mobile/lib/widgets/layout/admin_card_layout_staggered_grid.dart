import 'package:banboostore/pages/admin/edit_banboo_page.dart';
import 'package:banboostore/widgets/card/banboo_admin_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../model/banboo.dart';

class AdminCardLayoutStaggeredGrid extends StatelessWidget {
  const AdminCardLayoutStaggeredGrid({super.key, required this.crossAxisCount, required this.banboos, required this.onBanbooUpdated, required this.onBanbooDeleted});

  final int crossAxisCount;
  final List<Banboo> banboos;
  final VoidCallback onBanbooUpdated;
  final VoidCallback onBanbooDeleted;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: banboos.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditBanbooPage(banboo: banboos[index], onBanbooUpdated: onBanbooUpdated),
            ),
          );
          if (result == true) {

          }},
        child: Hero(
          tag: 'banboo-${banboos[index].banbooId}',
          child: BanbooAdminCard(
            banboo: banboos[index],
            context: context,
            onBanbooDeleted: onBanbooDeleted,
          ),
        ),
      ),
    );
  }
}


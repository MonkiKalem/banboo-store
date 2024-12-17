import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../model/banboo.dart';
import '../../pages/dialog/banboo_detail_dialog.dart';
import '../card/banboo_card.dart';

class ItemCardLayoutStaggeredGrid extends StatelessWidget {
  const ItemCardLayoutStaggeredGrid({super.key, required this.crossAxisCount, required this.banboos});

  final int crossAxisCount;
  final List<Banboo> banboos;

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
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => BanbooDetailDialog(banboo: banboos[index]),
            );
          },
          child: Hero(
            tag: 'banboo-${banboos[index].banbooId}',
            child: BanbooCard( banboo: banboos[index],
            ),
          ),
        ),
    );
  }
}

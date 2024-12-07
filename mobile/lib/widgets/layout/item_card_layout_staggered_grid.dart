import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../model/banboo.dart';
import '../../pages/banboo_detail_popup.dart';
import '../../widgets/banboo_card.dart';

class ItemCardLayoutStaggeredGrid extends StatelessWidget {
  const ItemCardLayoutStaggeredGrid({super.key, required this.crossAxisCount, required this.banboos});

  final int crossAxisCount;
  final List<Banboo> banboos;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      itemCount: banboos.length,  // Jumlah item yang akan ditampilkan
      itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => BanbooDetailDialog(banboo: banboos[index]),
            );
          },
          child: Hero(
            tag: 'banboo-${banboos[index].banbooId}',
            child: BanbooCard(
              banbooId: banboos[index].banbooId,
              name: banboos[index].name,
              price: banboos[index].price,
              description: banboos[index].description,
              elementId: banboos[index].elementId,
              level: banboos[index].level,
              imageUrl: banboos[index].imageUrl,
            ),
          ),
        ),
    );
  }
}

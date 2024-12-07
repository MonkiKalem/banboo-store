import 'package:banboostore/model/banboo.dart';
import 'package:banboostore/widgets/banboo_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../../pages/banboo_detail_page.dart';
import '../../pages/banboo_detail_popup.dart';

class ItemCardLayoutGrid extends StatelessWidget {
  const ItemCardLayoutGrid({
    Key? key,
    required this.crossAxisCount,
    required this.banboos,
  })
  // we only plan to use this with 1 or 2 columns
  : assert(crossAxisCount == 1 || crossAxisCount == 2),
        // assume we pass an list of 4 items for simplicity

        super(key: key);
  final int crossAxisCount;
  final List<Banboo> banboos;

  @override
  Widget build(BuildContext context) {
    return LayoutGrid(
      // set some flexible track sizes based on the crossAxisCount
      columnSizes: crossAxisCount == 2 ? [1.fr, 1.fr] : [1.fr],
      // set all the row sizes to auto (self-sizing height)
      rowSizes: crossAxisCount == 2
          ? const [auto, auto]
          : const [auto, auto, auto, auto],
      rowGap: 2, // equivalent to mainAxisSpacing
      columnGap: 2, // equivalent to crossAxisSpacing
      // note: there's no childAspectRatio
      children: [
        // render all the cards with *automatic child placement*
        for (var i = 0; i < banboos.length; i++)
          LayoutId(
            id: i,
            child: GestureDetector(
              onTap: () {
                // Arahkan ke halaman detail dengan Hero
                showDialog(
                  context: context,
                  builder: (context) => BanbooDetailDialog(banboo: banboos[i]),
                );
              },
              child: Hero(
                tag: 'banboo-${banboos[i].banbooId}',
                child: BanbooCard(
                  banbooId: banboos[i].banbooId,
                  name: banboos[i].name,
                  price: banboos[i].price,
                  description: banboos[i].description,
                  elementId: banboos[i].elementId,
                  level: banboos[i].level,
                  imageUrl: banboos[i].imageUrl,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

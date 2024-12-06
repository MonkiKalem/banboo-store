import 'package:banboostore/constants.dart';
import 'package:banboostore/widgets/banboo_card.dart';
import 'package:banboostore/widgets/item_card_layout_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import '../model/banboo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// https://fastcdn.hoyoverse.com/content-v2/nap/114225/608830bc6382b73079821aed7b19fda8_8240430244310614598.jpg

class _HomePageState extends State<HomePage> {
  final List<String> imgList = [
    'https://fastcdn.hoyoverse.com/content-v2/nap/114225/d9664f1281ca4dc8d057cbafb4df7ca9_754884677841569119.jpg',
    'https://fastcdn.hoyoverse.com/content-v2/nap/114225/4ed7c3aa0b3cfb401bbcf5668451d38d_8346342171453271705.jpg',
    'https://fastcdn.hoyoverse.com/content-v2/nap/114225/517ed14b0416a53dd26bf616cd405bcc_6750749868894820993.jpg',
    'https://fastcdn.hoyoverse.com/content-v2/nap/114225/608830bc6382b73079821aed7b19fda8_8240430244310614598.jpg',
    'https://fastcdn.hoyoverse.com/content-v2/nap/114225/f500f9d765b46ade79f922b67edc8d94_615087537866440042.jpg',
  ];

  List<Banboo> banbooList = [
    Banboo(
      banbooId: "001",
      imageUrl: "https://rerollcdn.com/ZZZ/Bangboo/1/amillion.png",
      name: "Amillion",
      level: "2",
      description: "ehehehehe",
      elementId: "pyro",
      price: 14500,
    ),
    Banboo(
      banbooId: '002',
      name: 'Butler',
      price: 15000,
      description: 'Another Banboo dollawdaawdawaw',
      elementId: 'Dark',
      level: '4',
      imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/butler.png',
    ),
    Banboo(
      banbooId: '003',
      name: 'Sharkboo',
      price: 150.0,
      description: 'Another Banboo doll',
      elementId: 'B002',
      level: '6',
      imageUrl: 'https://rerollcdn.com/ZZZ/Bangboo/1/sharkboo.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundGreyColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 300.0,

                collapsedHeight: 70,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => {},
                ),
                actions: const [
                  Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: FaIcon(FontAwesomeIcons.cartShopping),
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    title: const Text("Banboo Store",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold
                        )),
                    background: Image.network(
                      "https://fastcdn.hoyoverse.com/content-v2/nap/102370/39e68a14404891ba2e8f27c57e95ad46_4516017444439496819.png",
                      fit: BoxFit.cover,
                    )),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: AppColors.primaryColor,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: false,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.9,
                    ),
                    items: imgList.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: item,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text("Banboo List",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ItemCardLayoutGrid(crossAxisCount: 2, banboos: banbooList),
                ),

              ],
            ),
          ),
        ));
  }
}

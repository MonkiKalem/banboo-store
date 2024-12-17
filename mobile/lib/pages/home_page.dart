import 'package:banboostore/utils/constants.dart';
import 'package:banboostore/widgets/layout/carousel.dart';
import 'package:banboostore/widgets/layout/item_card_layout_staggered_grid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../model/banboo.dart';
import '../services/banboo_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Banboo> banbooList = [];
  List<Banboo> filteredList = [];

  bool _isLoading = true;
  bool _isSearch = false;
  String _errorMessage = '';

  String searchQuery = '';
  String tempQuery ="";

  @override
  void initState() {
    super.initState();
    _fetchBanboos();
  }

  Future<void> _fetchBanboos() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final fetchedBanboos = await BanbooApiService.getAllBanboos(context);

      setState(() {
        banbooList = fetchedBanboos;
        filteredList = fetchedBanboos;
        _isLoading = false;
      });
    } catch (e) {
        _errorMessage = 'Failed to load Banboos: ${e.toString()}';
        _isLoading = false;
    }
  }

  void _filterBanboos(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = banbooList;
        _isSearch = false;
      });
    } else {
      setState(() {
        tempQuery = query;
        _isSearch = true;
        filteredList = banbooList
            .where((banboo) =>
            banboo.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreyColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 220.0,
                collapsedHeight: 70,
                floating: false,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.backgroundDarkColor,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: const Text("Banboo Store",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold)),
                  background: Stack(children: [
                    SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://upload-os-bbs.hoyolab.com/upload/2023/11/15/369285726/fe6f361715d2e479c9333aa4eb56debd_5228699759752292298.jpg?x-oss-process=image%2Fresize%2Cs_1000%2Fauto-orient%2C0%2Finterlace%2C1%2Fformat%2Cwebp%2Fquality%2Cq_70",
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ]),
                )),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(
                child: Container(

                  padding: const EdgeInsets.symmetric( horizontal: 16,vertical: 8.0),
                  child: TextField(
                    onChanged: _filterBanboos,
                    decoration: InputDecoration(
                      hintText: 'Search Banboo...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      focusColor: AppColors.secondaryColor,
                      fillColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!_isSearch) ... [
                          // Carousel images
                          Stack(children: [
                            Container(
                              height: 220,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.backgroundColor,
                                    AppColors.backgroundGreyColor,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: const Carousel())
                          ]),
                        ],
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(_isSearch ? "Search Results"  : "Our Banboo Products",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ItemCardLayoutStaggeredGrid(
                              crossAxisCount: 2, banboos: filteredList
                          ),
                        ),
                        Container(
                          height: 64,
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          child: Text(filteredList.isEmpty ? "$tempQuery Not Found" : "Banboo Store"),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
@override
  void dispose() {
    super.dispose();
  }

}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

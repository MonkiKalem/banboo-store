import 'package:banboostore/model/banboo.dart';
import 'package:banboostore/pages/admin/edit_banboo_page.dart';
import 'package:banboostore/utils/constants.dart';
import 'package:banboostore/widgets/background.dart';
import 'package:banboostore/widgets/layout/admin_card_layout_staggered_grid.dart';
import 'package:flutter/material.dart';

import '../services/banboo_api_service.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  late Future<List<Banboo>> banboosFuture;

  List<Banboo> allBanboos = [];
  List<Banboo> filteredBanboos = [];

  final BanbooApiService banbooApiService = BanbooApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    refreshBanboos();
  }

  void refreshBanboos() {
    setState(() {
      banboosFuture = BanbooApiService.getAllBanboos(context).then((banboos) {
        setState(() {
          allBanboos = banboos;
          filteredBanboos = banboos;
        });
        return banboos;
      });
    });
  }

  void _filterBanboos(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredBanboos = allBanboos;
      } else {
        filteredBanboos = allBanboos
            .where((banboo) =>
            banboo.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGreyColor,
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 75,
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundDarkColor,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: refreshBanboos,
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 72, right: 25),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog(
              context: context,
              builder: (context) => EditBanbooPage(onBanbooUpdated: refreshBanboos,),
            );
            if (result == true) {
              refreshBanboos();
            }
          },
          backgroundColor: AppColors.secondaryColor,
          child: const Icon(Icons.add),
        ),
      ),
      body: FutureBuilder<List<Banboo>>(
        future: banboosFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                const Background(
                  imageUrl:
                  "https://fastcdn.hoyoverse.com/content-v2/nap/102026/37198ce9c5ee13abb2c49f1bd1c3ca97_7846165079824928446.png",
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.8),
                ),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No Bamboo Products Found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final result = await showDialog(
                        context: context,
                        builder: (context) => EditBanbooPage(onBanbooUpdated: refreshBanboos,),
                      );
                      if (result == true) {
                        refreshBanboos();
                      }
                    },
                    icon: const Icon(
                      Icons.add,
                      color: AppColors.backgroundCardColor,
                    ),
                    label: const Text('Add New Bamboo'),
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              const Background(
                imageUrl:
                "https://fastcdn.hoyoverse.com/content-v2/nap/102026/37198ce9c5ee13abb2c49f1bd1c3ca97_7846165079824928446.png",
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(0.8),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Search TextField
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: _filterBanboos,
                        decoration: InputDecoration(
                          hintText: 'Search Banboo...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      child: const Text(
                        'You can Add, Update, or Delete Banboo',
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 76),
                      child: AdminCardLayoutStaggeredGrid(
                        crossAxisCount: 2,
                        banboos: filteredBanboos, // Use filteredBanboos here
                        onBanbooUpdated: refreshBanboos,
                        onBanbooDeleted: refreshBanboos,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
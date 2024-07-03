import 'package:admin/config.dart';
import 'package:flutter/material.dart';
import 'package:admin/Model/category_model.dart';
import 'package:admin/Model/food_model.dart';
import 'package:admin/Screen/home/widget/food_cart.dart';
import 'package:admin/Service/category_service.dart';
import 'package:admin/Service/food_service.dart';
import 'package:admin/Screen/Cart/cart_icon.dart';
import 'package:admin/color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Category>> fetchedCategories;
  late Future<List<FoodModel>> fetchedFoods;
  String selectedCategoryId = 'semua';
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    fetchedCategories = _fetchCategories();
    fetchedFoods = _fetchFoods(selectedCategoryId);
  }

  Future<List<Category>> _fetchCategories() async {
    List<Category> apiCategories = await CategoryService().getCategories();

    Category semuaCategory =
        Category(id: 'semua', nama: 'Semua', gambar: 'uploads/fire.jpg');
    return [semuaCategory, ...apiCategories];
  }

  Future<List<FoodModel>> _fetchFoods(String categoryId) async {
    if (categoryId == 'semua' || categoryId.isEmpty) {
      return await FoodService().getFoods();
    } else {
      return await FoodService().getByCategory(categoryId);
    }
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      fetchedFoods = _fetchFoods(selectedCategoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 130,
              color: primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(),
                        flex: 1,
                      ),
                      Expanded(
                        child: Text(
                          'Halo Admin!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18),
                        ),
                        flex: 3,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CartIconWithBadge()],
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Silahkan Pilih Menu',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kategori',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      FutureBuilder(
                        future: fetchedCategories,
                        builder:
                            (context, AsyncSnapshot<List<Category>> snapshot) {
                          if (snapshot.hasData) {
                            categories = snapshot.data!;
                            return SizedBox(
                                height: 40,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: categories.map((category) {
                                    return GestureDetector(
                                      onTap: () {
                                        _onCategorySelected(category.id);
                                      },
                                      child: Container(
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: 12, vertical: 8),
                                        padding: EdgeInsets.only(right: 12),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: (selectedCategoryId ==
                                                  category.id)
                                              ? Color.fromARGB(
                                                      255, 242, 128, 40)
                                                  .withOpacity(0.5)
                                              : const Color.fromARGB(
                                                  255, 219, 219, 219),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          boxShadow: [
                                            BoxShadow(
                                              color: selectedCategoryId ==
                                                      category.id
                                                  ? Color.fromARGB(
                                                          255, 242, 128, 40)
                                                      .withOpacity(0.5)
                                                  : Color.fromARGB(0, 0, 0, 0),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: Offset(
                                                0,
                                                3,
                                              ), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Color.fromARGB(
                                                  255, 207, 207, 207),
                                              backgroundImage: NetworkImage(
                                                  '${Config.baseUrl}/${category.gambar}'),
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              category.nama,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ));
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      FutureBuilder(
                        future: fetchedFoods,
                        builder: ((context, snapshot) {
                          if (snapshot.hasData) {
                            final foods = snapshot.data!;
                            return GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                childAspectRatio:
                                    0.60, // Default aspect ratio (width:height = 1:1)
                              ),
                              itemCount: foods.length,
                              itemBuilder: (context, index) {
                                final item = foods[index];
                                return FoodCard(
                                  id: item.id,
                                  gambar: item.gambar,
                                  nama: item.nama,
                                  harga: item.harga.toString(),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

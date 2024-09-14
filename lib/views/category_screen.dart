import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Models/category_dart_model.dart';
import 'package:news_app/repository/view_model/news_view_model.dart';
import 'package:news_app/views/home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  final format = DateFormat('MMM dd, yyyy');
  String categoryName = 'General';

  List<String> categoriesList = [
    'General',
    'Entertainment',
    'Health',
    'Sports',
    'Business',
    'Technology'
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
            child: Container(
              margin: EdgeInsets.only(right: 370),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      categoryName = categoriesList[index];
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: categoryName == categoriesList[index]
                                ? Colors.blue
                                : Colors.green,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Center(
                              child: Text(
                            categoriesList[index].toString(),
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder<CategoryDartModel>(
              future: newsViewModel.fetchCategoryNewsApi(categoryName),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'An error occurred: ${snapshot.error}',
                      style:
                          GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Text(
                      'No data available',
                      style: GoogleFonts.poppins(
                          fontSize: 16, color: Colors.black54),
                    ),
                  );
                } else {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime datetime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot
                                        .data!.articles![index].urlToImage
                                        .toString(),
                                    fit: BoxFit.cover,
                                    height: height * .18,
                                    width: width * .3,
                                    placeholder: (context, url) => Container(
                                      child: const Center(
                                        child: SpinKitCircle(
                                          color: Colors.blue,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(
                                        snapshot.data!.articles![index].title
                                            .toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data!.articles![index]
                                                .source!.name
                                                .toString(),
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            format.format(datetime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

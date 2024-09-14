import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/Models/category_dart_model.dart';
import 'package:news_app/Models/news_channelHeadlines.dart';
import 'package:news_app/repository/view_model/news_view_model.dart';
import 'package:intl/intl.dart';
import 'package:news_app/views/category_screen.dart';
import 'package:news_app/views/news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcnews, aljazeera, arynews, independent }

String currentSource = 'bbc-news'; // Default source is 'bbc-news'

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsviewmodel = NewsViewModel();
  FilterList? selectedMenu;
  final format = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CategoriesScreen()));
          },
          icon: Image.asset(
            'images/category_icon.png',
            height: 30,
            width: 30,
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        actions: [
          PopupMenuButton<FilterList>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (FilterList item) {
                setState(() {
                  selectedMenu = item;
                  if (item == FilterList.bbcnews) {
                    currentSource = 'bbc-news';
                  }
                  if (item == FilterList.arynews) {
                    currentSource = 'ary-news';
                  }
                  if (item == FilterList.aljazeera) {
                    currentSource = 'al-jazeera-english';
                  }

                  // Add more conditions if necessary
                });
              },
              initialValue: selectedMenu,
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<FilterList>>[
                    const PopupMenuItem<FilterList>(
                        value: FilterList.bbcnews, child: Text('BBC-News')),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.arynews, child: Text('Ary-News')),
                    const PopupMenuItem<FilterList>(
                        value: FilterList.aljazeera,
                        child: Text('Aljazeera-News')),
                    // Add more sources if necessary
                  ]),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .5,
            width: width,
            child: FutureBuilder<newsChannelHeadlinesmodel>(
              future: newsviewmodel.fetchNewChannelHeadlinesApi(
                  currentSource), // Passing the current source here
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitCircle(
                      color: Colors.blue,
                      size: 50,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load data'));
                } else if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.articles != null) {
                  if (snapshot.data!.articles!.isEmpty) {
                    return Center(child: Text('No articles found'));
                  }
                  return SizedBox(
                    height: height * 0.6,
                    width: width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime datetime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                        newsImage: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        newsTitle: snapshot.data!.articles![index].title
                                            .toString(),
                                        newsDate: snapshot
                                            .data!.articles![index].publishedAt
                                            .toString(),
                                        author: snapshot.data!.articles![index].author
                                            .toString(),
                                        description: snapshot
                                            .data!.articles![index].description
                                            .toString(),
                                        content: snapshot
                                            .data!.articles![index].content
                                            .toString(),
                                        source: snapshot.data!.articles![index].source!.name.toString())));
                          },
                          child: SizedBox(
                            child: Container(
                              width: width * 0.9,
                              padding: EdgeInsets.symmetric(
                                horizontal: height * .02,
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: height * 0.6,
                                      width: width * .9,
                                      placeholder: (context, url) => spinkit2,
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        alignment: Alignment.bottomCenter,
                                        height: height * .22,
                                        width: width * 0.8,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4),
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Spacer(),
                                            Container(
                                              width: width * .7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Text(
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      format.format(datetime),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Center(child: Text('No data available'));
                }
              },
            ),
          ),
          FutureBuilder<CategoryDartModel>(
            future: newsviewmodel.fetchCategoryNewsApi(
                'General'), // Passing the current source here
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 50,
                  ),
                );
              } else {
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(), // Disable scrolling
                  itemCount: snapshot.data!.articles!.length,
                  itemBuilder: (context, index) {
                    DateTime datetime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString());
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
                                placeholder: (context, url) => const Center(
                                  child: SpinKitCircle(
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.articles![index].title
                                        .toString(),
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          snapshot.data!.articles![index]
                                              .source!.name
                                              .toString(),
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        format.format(datetime),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

const spinkit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);

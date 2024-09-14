import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/views/home_screen.dart';

class NewsDetailScreen extends StatefulWidget {
  String newsImage, newsTitle, newsDate, author, description, content, source;
  NewsDetailScreen({
    super.key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.author,
    required this.description,
    required this.content,
    required this.source,
  });

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
      ),
      body: Stack(
        children: [
          Container(
            child: Container(
              height: height * .45,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: widget.newsImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: height * .6,
            margin: EdgeInsets.only(top: height * .4),
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.white,
            ),
            child: ListView(
              children: [
                Text(
                  widget.newsTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      widget.source,
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * .03,
                ),
                Text(
                  widget.description,
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.w300),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

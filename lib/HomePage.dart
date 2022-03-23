import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quotesapp/constant.dart';
import 'package:quotesapp/quotes.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? imageList;
  int? imageNumber = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImageFromUnsplash();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: imageList != null
          ? Stack(
              children: [
                AnimatedSwitcher(
                  duration: Duration(seconds: 1),
                  child: BlurHash(
                    key: ValueKey(imageList![imageNumber!]['blur_hash']),
                    hash: imageList![imageNumber!]['blur_hash'],
                    duration: Duration(milliseconds: 800),
                    image: imageList![imageNumber!]['urls']['regular'],
                    curve: Curves.easeInOut,
                    imageFit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: width,
                  height: height,
                  color: Colors.black12,
                ),
                Container(
                  width: width,
                  height: height,
                  child: SafeArea(
                    child: CarouselSlider.builder(
                      itemCount: quotesList.length,
                      itemBuilder: (context, index1, index2) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                quotesList[index1][kQuote],
                                style: kQuoteTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              '- ${quotesList[index1][kAuthor]} -',
                              style: kAuthorTextStyle,
                              textAlign: TextAlign.center,
                            )
                          ],
                        );
                      },
                      options: CarouselOptions(
                          scrollDirection: Axis.vertical,
                          pageSnapping: true,
                          initialPage: 0,
                          enlargeCenterPage: true,
                          onPageChanged: (index, value) {
                            HapticFeedback.lightImpact();
                            if (index > 29) {
                              imageNumber = index - 29;
                              print(index);
                            } else if (index < 1) {
                              imageNumber = index + 29;
                              print(index);
                            } else
                              imageNumber = index;
                              print(index);
                            setState(() {});
                          }),
                    ),
                  ),
                )
              ],
            )
          : Container(
              width: width,
              height: height,
              color: Colors.black.withOpacity(0.6),
              child: Container(
                width: 100,
                height: 100,
                child: SpinKitFadingCircle(color: Colors.white),
              ),
            ),
    );
  }

  void getImageFromUnsplash() async {
    var url =
        'https://api.unsplash.com/search/photos?per_page=30&query=motivation&order_by=relevant&client_id=${accessKey}';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    print(response.statusCode);
    var unsplashData = json.decode(response.body);
    imageList = unsplashData['results'];
    setState(() {});
    print(unsplashData);
  }
}

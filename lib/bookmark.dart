
import 'package:flutter/material.dart';
import 'package:newsapp/providerhelper.dart';
import 'package:provider/provider.dart';


class BookMark extends StatelessWidget {
  const BookMark({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProviderHelper>(context);
    final bookmarkedArticles = bookmarkProvider.bookmarkedArticles;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 122, 65, 255),
        title: Text(
          'Bookmarks',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 30,
          ),
        ),
      ),
      body: bookmarkedArticles.isEmpty
          ? Center(
              child: Text(
                'No bookmarks Available',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: bookmarkedArticles.length,
              itemBuilder: (context, index) {
                final article = bookmarkedArticles[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article['urlToImage'] != null)
                          Image.network(article['urlToImage']),
                        SizedBox(height: 10),
                        Text(
                          article['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(article['description'].toString(),style: TextStyle(fontSize: 13),),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                            
                              width: 250,
                              
                              child: Text(
                                article['author'].toString(),
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.bookmark_remove, color: Colors.black,size: 30,),
                              onPressed: () {
                                bookmarkProvider.removeBookmark(article);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
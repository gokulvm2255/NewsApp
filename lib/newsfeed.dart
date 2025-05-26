import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:newsapp/loginpage.dart';
import 'package:newsapp/providerhelper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key,});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  List<Map<String, dynamic>> _article = [];
  bool _isLoading = false;

  

  


   String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('d MMMM y').format(date);
    } catch (e) {
      return dateString;
    }
  }
  

   @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await fetchData();
  }
  
  
  
  

  @override
  Widget build(BuildContext context) {
    final bookmarkProvider = Provider.of<BookmarkProviderHelper>(context);
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 122, 65, 255),
        
        title: Text('Global News',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 30),),
        actions:[ OutlinedButton(style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white)), onPressed: (){
          Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );

        } , child: Icon(Icons.logout,color: Colors.white,)),]
        ),
      body: RefreshIndicator(
        onRefresh: () async{
          await fetchData();
        },
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _article.isEmpty
                ? const Center(child: Text('No Data Available'))
                : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _article.length,
                    itemBuilder: (BuildContext context, int index) {
                      final artic = _article[index];
                      final isBookMarked = bookmarkProvider.isBookmarked(artic);
                      return InkWell(
                        onTap: (){
                          if (artic['url'] != null) {
          _launchURL(artic['url']);
        }
                          
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10.0),
                          child: Container(
                            
                             width: MediaQuery.of(context).size.width,
                            
                            
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 10),
                                  child: Row(
                                    
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    
                                    children: [
                                      Column(
                                        
                                        
                                        
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          
                                          Container(
                                            height: 130,
                                            width: 150,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                                            
                                            
                                            child: Image.network(artic['urlToImage'],fit: BoxFit.cover,),
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            width: 150,
                                            child: Text(
                                              style: TextStyle(color: Colors.red,fontWeight: FontWeight.w400,fontSize: 12),
                                              artic['description'].toString(),
                                            
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          
                                        ],
                                      ),
                                      SizedBox(width: 10,),
                                      
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    
                                    
                                   Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                      
                                          Row(
                                            children: [
                                              Container(
                                                width: 153,
                                               
                                                
                                                child: Text(
                                                  style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                                                  artic['author'].toString(),
                                                
                                                ),
                                              ),
                                              Container(
                                                width: 20,
                                                child: IconButton( onPressed: (){
                                                  if(isBookMarked){
                                                    bookmarkProvider.removeBookmark(artic);
                                                  }
                                                  else{
                                                    bookmarkProvider.addBookmark(artic);
                                                  }
                                                             
                                                             
                                                }, icon: Icon(
                                                  isBookMarked ? 
                                                  
                                                  Icons.bookmark: Icons.bookmark_border,size: 30,color: Colors.amber,)),
                                              ),
                                            ],
                                          ),
                                                           
                                       Container(
                                        padding: EdgeInsets.only(right: 10,),
                                        width: 190,
                                        
                                        child:Text(artic['title'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                        
                                       ),
                                       SizedBox(height: 8,),
                                       Container(
                                        
                                        padding: EdgeInsets.only(right: 7),
                                       margin: EdgeInsets.only(left: 50),
                                        
                                        height: 20,
                                        width: 150,
                                        
                                        child: Text(
                                         formatDate(artic['publishedAt']).toString(),style: TextStyle(color:Colors.brown ),),
                                       ),
                                       SizedBox(height: 10,),
                                       
                                     ],
                                   )
                                   
                                  ],
                                  
                                  
                                  
                                ),
                                      
                                    ],
                                  ),
                                ),
                                
                                
                              ],
                              
                            ),
                            
                          )
                        ),
                      );
                    },
                  ),
      ),
      
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://saurav.tech/NewsAPI/everything/cnn.json'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> articles = jsonData['articles'];
        setState(() {
          _article = articles.cast<Map<String, dynamic>>();
          _isLoading = false;
        });
      } else {
        setState(() {
          _article = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _article = [];
        _isLoading = false;
      });
      print('Error fetching data: $e');
    };
    
  }

Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }


  
}
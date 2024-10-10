import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'history_page.dart';

class HomePage extends StatefulWidget {
  final String? initialQuery;

  const HomePage({super.key, this.initialQuery});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> imageUrls = [];
  String query = "nature";
  int page = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialQuery != null) {
      query = widget.initialQuery!;
      _searchController.text = query;
    }

    fetchImages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
        loadMoreImages();
      }
    });
  }


  Future<void> fetchImages() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://api.unsplash.com/search/photos?page=$page&query=$query&client_id=sN2NB17s6FSYSweFq7sjxp-UNpPYE0rSYdMtk7RJnfo'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<String> newImages = (data['results'] as List)
            .map((image) => image['urls']['regular'] as String)
            .toList();

        setState(() {
          imageUrls.addAll(newImages);
          isLoading = false;
          page++;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching images: $e');
      }
      throw Exception('Failed to load images: $e');
    }
  }


  void loadMoreImages() {
    if (!isLoading) {
      fetchImages();
    }
  }


  void handleSearch(String newQuery) {
    setState(() {
      query = newQuery;
      imageUrls.clear();
      page = 1;
    });
    fetchImages();
    saveSearchHistory(newQuery);
  }


  Future<void> saveSearchHistory(String searchQuery) async {
    final databaseRef = FirebaseDatabase.instance.ref().child('search_history');

    try {
      String newId = databaseRef.push().key!;
      await databaseRef.child(newId).set({
        'query': searchQuery,
        'timestamp': ServerValue.timestamp,
      });
      if (kDebugMode) {
        print('Search query saved to Realtime Database');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving search query: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.purple,
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0,bottom: 20,left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Unsplash Search',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w700,fontSize: 27),textAlign: TextAlign.center,),
              InkWell(
                  onTap: () async {
                     final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryPage()),
                    );

                    if (result != null && result is String) {
                      handleSearch(result);
                    }
                  },
                  child: const Icon(Icons.history,color: Colors.white70,size: 27,weight: 200,fill: 0.9,)
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search images...',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    handleSearch(_searchController.text);
                  },
                ),
              ),
              onSubmitted: handleSearch,
            ),
          ),

          // Image grid
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(imageUrls[index], fit: BoxFit.cover);
              },
            ),
          ),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

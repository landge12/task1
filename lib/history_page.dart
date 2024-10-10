import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> searchHistory = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSearchHistory();
  }

  Future<void> loadSearchHistory() async {
    final databaseRef = FirebaseDatabase.instance.ref().child('search_history');
    try {
      final dataSnapshot = await databaseRef.orderByChild('timestamp').limitToLast(10).get();
      final Map<dynamic, dynamic> searchHistoryMap = dataSnapshot.value as Map<dynamic, dynamic>;

      List<String> history = [];
      if (searchHistoryMap != null) {
        searchHistoryMap.forEach((key, value) {
          history.add(value['query']);
        });
      }

      setState(() {
        searchHistory = history;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading search history: $e');
      }
    }
  }

  void handleSearch(String query) {
    Navigator.pop(context, query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back,color: Colors.white,size: 27,),
        toolbarHeight: 80,
        backgroundColor: Colors.purple,
        title: const Text('Search History',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w700,fontSize: 27),textAlign: TextAlign.center,),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search history...',
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
          Expanded(
            child: ListView.builder(
              itemCount: searchHistory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchHistory[index].toString()),
                  onTap: () {
                    handleSearch(searchHistory[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

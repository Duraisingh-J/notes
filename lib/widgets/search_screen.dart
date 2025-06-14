import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  @override
  Widget build(context){
    
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 100),
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.search),
                  TextField(
                    
                    decoration: InputDecoration(hintText: 'Type here'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

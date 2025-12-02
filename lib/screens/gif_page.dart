import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GiphyPicker {
  static Future<String?> show(BuildContext context, String apiKey) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => GiphySearchSheet(apiKey: apiKey),
    );
  }
}

class GiphySearchSheet extends StatefulWidget {
  final String apiKey;

  const GiphySearchSheet({super.key, required this.apiKey});

  @override
  State<GiphySearchSheet> createState() => _GiphySearchSheetState();
}

class _GiphySearchSheetState extends State<GiphySearchSheet> {
  List gifs = [];
  bool loading = false;

  Future<void> searchGifs(String query) async {
    setState(() => loading = true);

    final url = Uri.parse(
        "https://api.giphy.com/v1/gifs/search?api_key=${widget.apiKey}&q=$query&limit=30");

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    setState(() {
      gifs = data["data"];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // Show trending GIFs initially, you can check various API parameters on website https://developers.giphy.com/explorer/
    searchGifs("trending");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 50, 15, 15),
        child: Column(
          children: [
            // 🔎 Search Bar
            TextField(
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                if (value.isNotEmpty) searchGifs(value);
              },
              decoration: InputDecoration(
                hintText: "Search GIFs",
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🖼 GIF Grid
            Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: gifs.length,
                      itemBuilder: (context, index) {
                        final gifUrl =
                            gifs[index]["images"]["downsized"]["url"];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, gifUrl); // return GIF URL
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              gifUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? _expandedCategory;
  int? _selectedSubcategory;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> posts = [];
  bool isLoading = true;
  String baseUrl = 'https://webpristine.com/nssf';

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    final url =
        Uri.parse('https://webpristine.com/nssf/wp-json/wp/v2/categories');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> allCategories = json.decode(response.body);

        // Filter out "Uncategorized" category
        List<Map<String, dynamic>> filteredCategories = allCategories
            .where((category) => category['name'].toLowerCase() != 'uncategorized')
            .map((category) => {
                  "id": category['id'],
                  "title": category['name'],
                  "subcategories": [],
                  "expanded": false, // Track expansion state
                })
            .toList();

        setState(() {
          categories = filteredCategories;
          isLoading = false;
        });

        // Fetch subcategories
        for (var category in categories) {
          fetchSubcategories(category['id']);
        }
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      log('Error fetching categories: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch subcategories
  Future<void> fetchSubcategories(int categoryId) async {
    final url = Uri.parse(
        'https://webpristine.com/nssf/wp-json/wp/v2/categories?parent=$categoryId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> subcategories = json.decode(response.body);

        setState(() {
          for (var category in categories) {
            if (category['id'] == categoryId) {
              category['subcategories'] = subcategories
                  .map((sub) => {
                        "id": sub['id'],
                        "title": sub['name'],
                      })
                  .toList();
              break;
            }
          }
        });
      }
    } catch (e) {
      log('Error fetching subcategories: $e');
    }
  }

  // Fetch posts for subcategory
  Future<void> fetchPosts(int subcategoryId) async {
    final url = Uri.parse(
        'https://webpristine.com/nssf/wp-json/wp/v2/posts?categories=$subcategoryId&_embed');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> fetchedPosts = json.decode(response.body);

        setState(() {
          _selectedSubcategory = subcategoryId;
          posts = fetchedPosts.cast<Map<String, dynamic>>(); // Ensure correct type
        });

        // Log each post's title
        for (var post in posts) {
          log("Post Title: ${post['title']['rendered']}");
          
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      log('Error fetching posts: $e');
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'water':
        return Icons.water;
      case 'waste':
        return Icons.delete;
      case 'transport':
        return Icons.directions_car;
      case 'energy':
        return Icons.lightbulb;
      case 'eating habits':
        return Icons.fastfood;
      case 'daily life':
        return Icons.access_alarm;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    "Categories & Posts",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Categories List
                ...categories.map((category) {
                  return Column(
                    children: [
                      // Category Item
                      ListTile(
                        leading: Icon(
                          _getCategoryIcon(category['title']),
                          color: category["expanded"] ? Colors.blue : Colors.grey,
                        ),
                        title: Text(
                          category['title'],
                          style: TextStyle(
                            fontWeight:
                                category["expanded"] ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        trailing: Icon(
                          category["expanded"] ? Icons.expand_less : Icons.expand_more,
                        ),
                        onTap: () {
                          setState(() {
                            category["expanded"] = !category["expanded"];
                          });
                        },
                      ),

                      // Subcategories List
                      if (category["expanded"])
                        ...category['subcategories'].map((subcategory) {
                          return Padding(
                            padding: EdgeInsets.only(left: 32),
                            child: ListTile(
                              title: Text(subcategory['title']),
                              trailing: _selectedSubcategory == subcategory['id']
                                  ? Icon(Icons.expand_less)
                                  : Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                if (_selectedSubcategory == subcategory['id']) {
                                  setState(() {
                                    _selectedSubcategory = null;
                                    posts = [];
                                  });
                                } else {
                                  fetchPosts(subcategory['id']);
                                }
                              },
                            ),
                          );
                        }).toList(),

                      // Show Posts If Subcategory is Selected
                      if (_selectedSubcategory != null &&
                          category['subcategories']
                              .any((sub) => sub['id'] == _selectedSubcategory))
                        Padding(
                          padding: EdgeInsets.only(left: 48),
                          child: Column(
                            children: posts.isNotEmpty
                                ? posts.map((post) {
                                    return ListTile(
                                      title: Text(post['title']['rendered']),
                                    );
                                  }).toList()
                                : [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        "No posts available",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    )
                                  ],
                          ),
                        ),
                    ],
                  );
                }).toList(),

                Divider(),

                // Footer
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "The European Commission support for the production of this publication does not constitute an endorsement of the contents...",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
    );
  }
}

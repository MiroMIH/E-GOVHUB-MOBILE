import 'package:flutter/material.dart';
import '../api_service.dart';
import 'profile_screen.dart';
import 'publication_detail_screen.dart';
import '../appGlobals.dart'; // Import AppGlobals

class Publication {
  final String id;
  final String type;
  final String title;
  final String content;
  final String domain;
  final List<String> photos;
  final List<String> videos;
  final DateTime startDate;
  final DateTime? endDate;
  final bool allowAnonymousParticipation;
  final List<String> participationOptions;
  final Map<String, dynamic> participationResults;
  final String createdBy;
  final String wilaya;
  final String commune;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Comment> comments;

  Publication({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.domain,
    required this.photos,
    required this.videos,
    required this.startDate,
    required this.endDate,
    required this.allowAnonymousParticipation,
    required this.participationOptions,
    required this.participationResults,
    required this.createdBy,
    required this.wilaya,
    required this.commune,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
  });
}

class Comment {
  final String id;
  final String content;
  final String createdBy;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });
}

class PublicationScreen extends StatefulWidget {
  @override
  _PublicationScreenState createState() => _PublicationScreenState();
}

class _PublicationScreenState extends State<PublicationScreen> {
  final ApiService _apiService = ApiService();
  late List<Publication> publications = [];

  @override
  void initState() {
    super.initState();
    _fetchPublications();
  }

  Future<void> _fetchPublications() async {
    try {
      final List<Map<String, dynamic>> jsonData =
          await _apiService.fetchAllPublications();
      String? userCommune = AppGlobals().commun;
      setState(() {
        publications = jsonData
            .map((item) => _mapPublication(item))
            .where((publication) => publication.commune == userCommune)
            .toList();
      });
    } catch (error) {
      print('Error fetching publications: $error');
    }
  }

  Publication _mapPublication(Map<String, dynamic> json) {
    // Mapping logic here
    return Publication(
      id: json['_id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      domain: json['domain'] ?? '',
      photos: (json['photos'] as List<dynamic>)
          .map((photo) => _concatenateBaseUrl(photo.toString()))
          .toList(),
      videos: (json['videos'] as List<dynamic>)
          .map((video) => video.toString())
          .toList(),
      startDate: DateTime.parse(json['startDate'] ?? ''),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      allowAnonymousParticipation: json['allowAnonymousParticipation'] ?? false,
      participationOptions: (json['participationOptions'] as List<dynamic>)
          .map((option) => option.toString())
          .toList(),
      participationResults:
          Map<String, dynamic>.from(json['participationResults'] ?? {}),
      createdBy: json['createdBy'] ?? '',
      wilaya: json['wilaya'] ?? '',
      commune: json['commune'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => _mapComment(comment))
          .toList(),
    );
  }

  Comment _mapComment(Map<String, dynamic> json) {
    // Mapping logic here
    return Comment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
    );
  }

  String _concatenateBaseUrl(String relativePath) {
    const String baseUrl = 'https://locally-ready-bass.ngrok-free.app';
    return '$baseUrl/$relativePath';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Publications',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF072923),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white), // Profile icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: publications.isNotEmpty
          ? ListView.builder(
              itemCount: publications.length,
              itemBuilder: (context, index) {
                final publication = publications[index];
                // Inside the ListView.builder's itemBuilder

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PublicationDetailScreen(
                              publication: publication)),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.black, width: 0.5),
                        bottom: BorderSide(color: Colors.black, width: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          publication.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            if (publication.startDate != null)
                              Chip(
                                label: Text(
                                  '${_formatDate(publication.startDate)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.blue.withOpacity(0.5),
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 6),
                              ),
                            SizedBox(width: 8),
                            if (publication.endDate != null)
                              Chip(
                                label: Text(
                                  '${_formatDate(publication.endDate!)}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                backgroundColor: Colors.green.withOpacity(0.5),
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 6),
                              ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (publication.photos.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(publication.photos.first),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                        Text(
                          publication.content.length > 100
                              ? '${publication.content.substring(0, 100)}...'
                              : publication.content,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

import 'dart:convert';
import '../api_service.dart';
import 'package:flutter/material.dart';
import 'publication_screen.dart';
import 'package:provider/provider.dart';
import '../user_provider.dart'; // Import the UserProvider class
import '../appGlobals.dart';

class PublicationDetailScreen extends StatefulWidget {
  final Publication publication;

  PublicationDetailScreen({required this.publication});

  @override
  _PublicationDetailScreenState createState() =>
      _PublicationDetailScreenState();
}

class _PublicationDetailScreenState extends State<PublicationDetailScreen> {
  late List<bool> selectedOptions;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('Publication ID: ${widget.publication.id}');

    // Initialize selectedOptions list with false values for each option
    selectedOptions = List<bool>.filled(
        widget.publication.participationOptions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publication Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                widget.publication.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                '${widget.publication.content}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // Start Date
            if (widget.publication.startDate != null)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Chip(
                  label: Text(
                    '${_formatDate(widget.publication.startDate!)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.5),
                  labelPadding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            // End Date
            if (widget.publication.endDate != null)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Chip(
                  label: Text(
                    '${_formatDate(widget.publication.endDate!)}',
                    style: TextStyle(fontSize: 16),
                  ),
                  backgroundColor: Colors.green.withOpacity(0.5),
                  labelPadding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            // Photos
            if (widget.publication.photos.isNotEmpty)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1), // Light border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.publication.photos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Image.network(
                              widget.publication.photos[index],
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            // Participation Options
            if (widget.publication.participationOptions.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ), // Light border
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Participation Options',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                            widget.publication.participationOptions.length,
                            (index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 10),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selectedOptions[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOptions[index] = value!;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  widget
                                      .publication.participationOptions[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: selectedOptions[index]
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            // Write Comment
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write Your Comment:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to submit the comment
                      String? userId = AppGlobals().userId;
                      print('CURRENT USER ID -----------: $userId');
                      String commentContent = commentController.text;
                      List<String> votedOptions = [];
                      for (int i = 0; i < selectedOptions.length; i++) {
                        if (selectedOptions[i]) {
                          votedOptions
                              .add(widget.publication.participationOptions[i]);
                        }
                      }

                      // Extract comments with their content, createdBy, and createdAt
                      List<Map<String, dynamic>> comments =
                          widget.publication.comments
                              .map((comment) => {
                                    'content': comment.content,
                                    'createdBy': comment.createdBy,
                                    'createdAt':
                                        comment.createdAt.toIso8601String(),
                                  })
                              .toList();

                      // Create JSON data with the comment, voted options, and comments
                      Map<String, dynamic> jsonData = {
                        'publicationId': widget.publication.id,
                        'comment': {
                          'content': commentContent,
                          'createdBy':
                              userId, // Replace CURRENT_USER_ID with the actual user ID
                          'createdAt': DateTime.now().toIso8601String(),
                        },
                        'votedOptions': votedOptions,
                      };

                      // Print the publication ID and JSON data
                      print('Publication ID: ${widget.publication.id}');
                      print('Submitted JSON Data: $jsonData');

                      // Call the updatePublication method
                      ApiService()
                          .updatePublication(widget.publication.id, jsonData);

                      // Clear the text field after submitting
                      commentController.clear();

                      // Reset selected options
                      setState(() {
                        selectedOptions = List<bool>.filled(
                            widget.publication.participationOptions.length,
                            false);
                      });
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),

            // Participation Results
            if (widget.publication.participationResults.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1,
                    ), // Light border
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Participation Results',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget
                            .publication.participationResults.entries
                            .map((entry) {
                          return Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  '${entry.key}: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(entry.value.toString()),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

            // Location (Wilaya and Commune)
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 20, color: Colors.black), // Location icon
                  Text(
                    '${widget.publication.wilaya}, ${widget.publication.commune}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            // Created At

            // Comments
            if (widget.publication.comments.isNotEmpty)
              Container(
                margin: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1), // Light border
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Comments',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.publication.comments.map((comment) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.content,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'By: ${comment.createdBy}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              Text(
                                'At: ${_formatDate(comment.createdAt)}',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}

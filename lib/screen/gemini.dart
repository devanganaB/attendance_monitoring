import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.title});

  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //defien the userss
  ChatUser myself = ChatUser(id: '1', firstName: 'Deva');
  ChatUser gemini = ChatUser(id: '2', firstName: 'Gemini');

  List<ChatMessage> messages = <ChatMessage>[]; //holds message
  List<ChatUser> _typing = <ChatUser>[]; //to define gimini is typing

  final myurl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDoBATkik_9_C4_vGExwQvSJ0lZlEA-AhA';
  final myurl2 =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=AIzaSyDoBATkik_9_C4_vGExwQvSJ0lZlEA-AhA';

  final header = {'Content-Type': 'application/json'};

  getdata(ChatMessage m) async {
    _typing.add(gemini);
    messages.insert(0, m);
    setState(() {});

    // var query = {
    //   "contents": [
    //     {
    //       "parts": [
    //         {"text": m.text}
    //       ]
    //     }
    //   ]
    // };
//waiting for message to be received from server
    // await Future.delayed(Duration(seconds: 2));
    try {
      var query;

      if (m.medias != null && m.medias!.isNotEmpty) {
        // Handle media message (image, video, file)
        var mediaType = m.medias![0].type.toString().split('.')[1];
        var base64Image = await _convertIntoBase64(m.medias![0].url);
        query = {
          "contents": [
            {
              "parts": [
                {"text": "describe this image"},
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image,
                  }
                },
              ]
            }
          ]
        };
      } else {
        // Handle text message
        query = {
          "contents": [
            {
              "parts": [
                {"text": m.text}
              ]
            }
          ]
        };
      }

      final response = await http
          .post(
            Uri.parse(myurl),
            headers: header,
            body: jsonEncode(query),
          )
          .timeout(Duration(seconds: 30)); // Set a timeout of 10 seconds

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        print(result['candidates'][0]['content']['parts'][0]['text']);
        // From Gemini response
        ChatMessage data = ChatMessage(
          text: result['candidates'][0]['content']['parts'][0]['text'],
          user: gemini,
          createdAt: DateTime.now(),
        );

        // Received data appended to the message list
        messages.insert(0, data);
        setState(() {});
      } else {
        print("ERROR IS: ${response.body}");
        // Show a dialog with an error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content:
                  Text('Error occurred while fetching data. ${response.body}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("ERROR BLOCK $e");
      // Show a dialog with a timeout error message
      String errorMessage = 'An unexpected error occurred.';
      if (e is TimeoutException) {
        errorMessage = 'The request timed out. Please try again.';
      } else if (e is SocketException) {
        errorMessage =
            'Unable to establish a connection. Check your internet connection.';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Timeout'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    _typing.remove(gemini);
  }

  Future<String> _convertIntoBase64(String imagePath) async {
    File imageFile = File(imagePath);
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    var mediaType = MediaType.image; // Default to image

    if (result != null) {
      try {
        var query;

        // Handle media message (image)
        var base64Image = await _convertIntoBase64(result.path);
        query = {
          "contents": [
            {
              "parts": [
                {"text": "describe this image"},
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image,
                  }
                },
              ]
            }
          ]
        };

        final response = await http
            .post(
              Uri.parse(myurl2),
              headers: header,
              body: jsonEncode(query),
            )
            .timeout(Duration(seconds: 30)); // Set a timeout of 30 seconds

        if (response.statusCode == 200) {
          var result = jsonDecode(response.body);
          print(result['candidates'][0]['content']['parts'][0]['text']);
          // From Gemini response
          ChatMessage data = ChatMessage(
            text: result['candidates'][0]['content']['parts'][0]['text'],
            user: gemini,
            createdAt: DateTime.now(),
          );

          // Received data appended to the message list
          messages.insert(0, data);
          setState(() {});
        } else {
          print("ERROR IS: ${response.body}");
          // Show a dialog with an error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(
                    'Error occurred while fetching data. ${response.body}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print("ERROR BLOCK $e");
        // Show a dialog with a timeout error message
        String errorMessage = 'An unexpected error occurred.';
        if (e is TimeoutException) {
          errorMessage = 'The request timed out. Please try again.';
        } else if (e is SocketException) {
          errorMessage =
              'Unable to establish a connection. Check your internet connection.';
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Timeout'),
              content: Text(errorMessage),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );

  //   var mediaType = MediaType.image; // Default to image

  //   if (result != null) {
  //     try {
  //       final request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse(myurl2),
  //       );

  //       // Add the image file to the request
  //       request.files
  //           .add(await http.MultipartFile.fromPath('picture', result.path));

  //       // Send the request
  //       final response = await request.send();

  //       if (response.statusCode == 200) {
  //         var responseBody = await response.stream.bytesToString();
  //         var result = jsonDecode(responseBody);

  //         // From Gemini response
  //         ChatMessage data = ChatMessage(
  //           text: result['candidates'][0]['content']['parts'][0]['text'],
  //           user: gemini,
  //           createdAt: DateTime.now(),
  //         );

  //         // Received data appended to the message list
  //         messages.insert(0, data);
  //         setState(() {});
  //       } else {
  //         print("ERROR IS:  ${response.statusCode} - ${response.reasonPhrase}");
  //         // Handle error response
  //       }
  //     } catch (e) {
  //       print("ERROR BLOCK $e");
  //       // Handle exceptions
  //     }
  //   }
  // }

  // void _handleImageSelection() async {
  //   final result = await ImagePicker().pickImage(
  //     imageQuality: 70,
  //     maxWidth: 1440,
  //     source: ImageSource.gallery,
  //   );

  //   var mediaType = MediaType.image; // Default to image

  //   if (result != null) {
  //     final media = ChatMedia(
  //       url: result.path, // Use the path as the URL for local images
  //       fileName: result.name,
  //       type: mediaType,
  //       isUploading: false,
  //       uploadedDate: DateTime.now(),
  //     );
  //     print("result url is: ${result.path}");

  //     final message = ChatMessage(
  //       text: mediaType.toString(),
  //       user: myself,
  //       createdAt: DateTime.now(),
  //       medias: [media],
  //     );

  //     print("message is: ${message.medias}");
  //     getdata(message);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: Icon(
                Icons.camera_alt_outlined,
              ),
              onPressed: () {
                _handleImageSelection();
                print("the add button tapped");
              },
            ),
          ),
        ],
      ),
      body: DashChat(
        currentUser: myself,
        typingUsers: _typing,
        onSend: (ChatMessage m) {
          getdata(m);
        },
        messages: messages, //stores  all messages passed
        inputOptions: InputOptions(
            alwaysShowSend: true,
            cursorStyle: CursorStyle(color: Colors.black)),
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.grey,
          avatarBuilder: yourAvatarBuilder,
        ),
      ),
    );
  }

  Widget yourAvatarBuilder(
      ChatUser user, Function? onAvatarTap, Function? onAvatarLongPress) {
    return Center(
        child: Image.asset('assets/images/gemini.jpg', height: 40, width: 40));
  }
}

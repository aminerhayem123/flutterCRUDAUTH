import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_signin/style/app_style.dart';
import 'package:flutter/material.dart';

class NoteEditor extends StatefulWidget {
  const NoteEditor({Key? key}) : super(key: key);

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  int colorid = Random().nextInt(AppStyle.cardColor.length);
  final TextEditingController _titleController = TextEditingController();
  String date = DateTime.now().toString();
  final TextEditingController _mainController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardColor[colorid],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColor[colorid],
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "ADD NEW NOTE",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'NoteTitle',
              ),
              style: AppStyle.mainTitle,
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              date,
              style: AppStyle.datetitle,
            ),
            const SizedBox(
              height: 28.0,
            ),
            TextField(
              controller: _mainController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Content',
              ),
              style: AppStyle.mainContent,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () {
          FirebaseFirestore.instance.collection("Notes").add({
            "note_title": _titleController.text,
            "creation_date": date,
            "note_content": _mainController.text,
            "color_id": colorid
          });
          Future<Null> Notes = FirebaseFirestore.instance
              .collection("Notes")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              print(result.data());
            });
            Navigator.pop(context);
          }).catchError(
                  // ignore: avoid_print, invalid_return_type_for_catch_error
                  (error) => print("Failed to add new Note due to $error"));
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

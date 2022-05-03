import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_signin/style/app_style.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoteReader extends StatefulWidget {
  NoteReader(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;
  @override
  State<NoteReader> createState() => _NoteReaderState();
}

class _NoteReaderState extends State<NoteReader> {
  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardColor[colorId],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColor[colorId],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.doc["note_title"], style: AppStyle.mainTitle),
            const SizedBox(
              height: 4.0,
            ),
            Text(widget.doc["creation_date"], style: AppStyle.datetitle),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              widget.doc["note_content"],
              style: AppStyle.mainContent,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async {
// Delete will delete the document
          Future<Null> Notes = FirebaseFirestore.instance
              .collection("Notes")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) {
              if (result.data()["note_title"] == widget.doc["note_title"]) {
                FirebaseFirestore.instance
                    .collection("Notes")
                    .doc(result.id)
                    .delete();
                Navigator.pop(context);
              }
            });
          });
        },
        child: const Icon(Icons.delete),
      ),
    );
  }
}

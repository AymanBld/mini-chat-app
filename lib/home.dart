// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    TextEditingController messagText = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(backgroundColor: Colors.black),
      drawer: DrawerTab(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('messages')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Welcom in Chat Tawat'),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Erore${snapshot.error}'),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      bool isme = auth.currentUser!.email ==
                          snapshot.data!.docs[index].data()['sender'];

                      String get(String key, bool istext) {
                        RegExp replacc = istext ? RegExp('') : RegExp(r'@.*');

                        if (snapshot.data!.docs[index].data()[key] == null) {
                          return '';
                        } else {
                          return snapshot.data!.docs[index]
                              .data()[key]
                              .replaceAll(replacc, '');
                        }
                      }

                      return InkWell(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              // title: Text('Email not verified'),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FilledButton(
                                    child: Row(
                                      children: [
                                        Text('Delete'),
                                        Icon(Icons.delete)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FirebaseFirestore.instance
                                          .collection('messages')
                                          .doc(snapshot.data!.docs[index].id)
                                          .delete();
                                    },
                                  ),
                                  FilledButton(
                                    child: Row(
                                      children: [
                                        Text('Edit'),
                                        Icon(Icons.edit)
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            TextEditingController textEdit =
                                                TextEditingController();
                                            textEdit.text = get('text', true);
                                            return AlertDialog(
                                              title: Text('edit message'),
                                              actions: [
                                                TextField(
                                                  controller: textEdit,
                                                ),
                                                FilledButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    FirebaseFirestore.instance
                                                        .collection('messages')
                                                        .doc(snapshot.data!
                                                            .docs[index].id)
                                                        .update({
                                                      'text': textEdit.text
                                                    });
                                                  },
                                                  child: Text('Edit'),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: isme
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              get('sender', false),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: isme
                                    ? Colors.orange[900]
                                    : Colors.blue[900],
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                  topRight: Radius.circular(isme ? 10 : 30),
                                  topLeft: Radius.circular(isme ? 30 : 10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Text(
                                  get('text', true),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 5)
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messagText,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (messagText.text != '') {
                        store.collection('messages').add(
                          {
                            'sender': auth.currentUser!.email,
                            'text': messagText.text,
                            'time': DateTime.now()
                          },
                        );
                      }
                      messagText.clear();
                    },
                    child: Text('send'),
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

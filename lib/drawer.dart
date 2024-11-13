import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class DrawerTab extends StatefulWidget {
  const DrawerTab({super.key});

  @override
  State<DrawerTab> createState() => _DrawerTabState();
}

class _DrawerTabState extends State<DrawerTab> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black87,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('profiles')
                  .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Erore${snapshot.error}'),
                  );
                }

                QueryDocumentSnapshot theProfile = snapshot.data!.docs[0];
                TextEditingController username = TextEditingController(
                  text: theProfile['username'],
                );
                TextEditingController phone = TextEditingController(
                  text: theProfile['phone'],
                );

                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(theProfile['photo']),
                        ),
                        Positioned(
                          bottom: -13,
                          left: -13,
                          child: IconButton(
                            onPressed: () async {
                              final ImagePicker piker = ImagePicker();
                              XFile? imagePiked = await piker.pickImage(source: ImageSource.camera);
                              File? file = File(imagePiked!.path);
                              String name = '${snapshot.data!.docs[0].id}.jpg';

                              final reference = FirebaseStorage.instance.ref();
                              final image = reference.child(name);
                              await image.putFile(file);

                              String url = await image.getDownloadURL();
                              await FirebaseFirestore.instance
                                  .collection('profiles')
                                  .doc(theProfile.id)
                                  .update({'photo': url});
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    InfoText(
                        tec: username,
                        theprofile: theProfile,
                        field: 'username',
                        icon: Icons.person_2_outlined),
                    InfoText(tec: phone, theprofile: theProfile, field: 'phone', icon: Icons.phone),
                  ],
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('log out!'),
              onTap: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InfoText extends StatefulWidget {
  final TextEditingController tec;
  final QueryDocumentSnapshot theprofile;
  final String field;
  final IconData icon;

  const InfoText({
    super.key,
    required this.tec,
    required this.theprofile,
    required this.field,
    required this.icon,
  });

  @override
  State<InfoText> createState() => _InfoTextState();
}

class _InfoTextState extends State<InfoText> {
  bool inEdit = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: !inEdit,
      controller: widget.tec,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(widget.icon),
        suffixIcon: IconButton(
          onPressed: () async {
            if (inEdit) {
              await FirebaseFirestore.instance
                  .collection('profiles')
                  .doc(widget.theprofile.id)
                  .update({widget.field: widget.tec.text});
            }
            setState(() {
              inEdit = !inEdit;
            });
          },
          icon: Icon(inEdit ? Icons.check : Icons.edit),
        ),
      ),
    );
  }
}

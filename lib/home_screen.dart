import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'crear_album.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Bandas de Rock'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CrearAlbum(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('albums').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty ?? true) {
            return Center(child: Text('No albums found'));
          }

          final albums = snapshot.data!.docs;

          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              final data = album.data() as Map<String, dynamic>;
              final votes = data['votes'] as int;

              return ListTile(
                title: Text(data['name_album']),
                subtitle: Text('Band: ${data['name_band']}\nYear: ${data['year']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$votes'),
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('albums').doc(album.id).update({
                          'votes': votes + 1,
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'crear_album.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bandas de Rock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CrearAlbum(),
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
            return const Center(child: CircularProgressIndicator());
          }

          final albums = snapshot.data!.docs;

          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              final data = album.data() as Map<String, dynamic>;
              final votes = data['votos'] as int;

              return ListTile(
                title: Text(data['nombre_album']),
                subtitle: Text('Banda: ${data['nombre_banda']}\nAnio: ${data['anio']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('$votes'),
                    IconButton(
                      icon: const Icon(Icons.thumb_up),
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('albums').doc(album.id).update({
                          'votos': votes + 1,
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
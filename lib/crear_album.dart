// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrearAlbum extends StatefulWidget {
  const CrearAlbum({super.key});

  @override
  _CrearAlbumState createState() => _CrearAlbumState();
}

class _CrearAlbumState extends State<CrearAlbum> {
  final _nombreController = TextEditingController();
  final _bandaController = TextEditingController();
  final _anioController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addAlbum() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('albums').add({
        'nombre_album': _nombreController.text,
        'nombre_banda': _bandaController.text,
        'anio_lanzamiento': int.parse(_anioController.text),
        'votos': 0,
      });
    //  Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Album')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration:const InputDecoration(labelText: 'Nombre del album'),
              
              ),
              TextFormField(
                controller: _bandaController,
                decoration:const InputDecoration(labelText: 'Nombre de la banda'),
                
              ),
              TextFormField(
                controller: _anioController,
                decoration: const InputDecoration(labelText: 'Año de lanzamiento'),
                
              ),
             const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addAlbum,
                child: const Text('Agregar album'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

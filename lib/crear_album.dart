import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrearAlbum extends StatefulWidget {
  @override
  _CrearAlbumState createState() => _CrearAlbumState();
}

class _CrearAlbumState extends State<CrearAlbum> {
  final _nameController = TextEditingController();
  final _bandController = TextEditingController();
  final _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _addAlbum() async {
    if (_formKey.currentState?.validate() ?? false) {
      await FirebaseFirestore.instance.collection('albums').add({
        'nombre_album': _nameController.text,
        'nombre_banda': _bandController.text,
        'anio_lanzamiento': int.parse(_yearController.text),
        'votos': 0,
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crear Album')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Album Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nombre de Album';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bandController,
                decoration: InputDecoration(labelText: 'Nombre de banda'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ingrese un nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(labelText: 'Año de lanzamiento'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'ingrese anio';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addAlbum,
                child: Text('Agregar album'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

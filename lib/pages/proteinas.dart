import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:food/models/proteina.dart';

class ProteinaPage extends StatefulWidget {
  @override
  _ProteinaPageState createState() => _ProteinaPageState();
}

class _ProteinaPageState extends State<ProteinaPage> {
  DatabaseReference _proteinasRef;
  StreamSubscription<Event> _messagesSubscription;
  bool _anchorToBottom = false;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase();

    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _proteinasRef = database.reference().child('proteinas');
  }

  @override
  void dispose() {
    super.dispose();
    _messagesSubscription.cancel();
  }

  Future<void> _addProteina(String nombre, String descripcion) async {
    Proteina proteina = new Proteina('pro', nombre, descripcion);
    _proteinasRef.push().set(proteina.tojson());
  }

  Future<void> _updateProteina(
      String index, String nombre, String descripcion) async {
    Proteina proteina = new Proteina('pro', nombre, descripcion);
    _proteinasRef.child(index).set(proteina.tojson());
  }

  _displayDialogForm({bool update: false, String index: ''}) async {
    String _titulo = 'Modificar Proteina';
    if (!update) {
      _textFieldController.clear();
      _textDescriptionController.clear();
      _titulo = 'Agregar Proteina';
    }

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(_titulo),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _textFieldController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(hintText: "Ingrese el nombre"),
                  ),
                  TextField(
                    maxLines: 2,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    controller: _textDescriptionController,
                    decoration:
                        InputDecoration(hintText: "Ingrese descripción"),
                  )
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Guardar'),
                  onPressed: () {
                    if (_textFieldController.text.length > 0) {
                      if (!update) {
                        _addProteina(_textFieldController.text.toString(),
                            _textDescriptionController.text.toString());
                      } else {
                        _updateProteina(
                            index,
                            _textFieldController.text.toString(),
                            _textDescriptionController.text.toString());
                      }
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ]);
        });
  }

  _ondeleteProteina(String index, String nombre, {bool confirm = false}) {
    print('index: ' + index.toString());

    if (confirm) {
      _proteinasRef.child(index).remove().then((_) {
        print("Delete $index successful");
      });
    } else {
      _showDialogConfirm(index, nombre);
    }
  }

  _onUpdateProteina(String index, String nombre, String descripcion) {
    print('index: ' + index.toString());
    setState(() {
      _textFieldController.text = nombre;
      _textDescriptionController.text = descripcion;
    });
    _displayDialogForm(update: true, index: index);
  }

  _showDialogConfirm(String index, String nombre) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Desea eliminar ${nombre} ? '),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SI'),
                onPressed: () {
                  _ondeleteProteina(index, nombre, confirm: true);
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proteinas'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              key: ValueKey<bool>(_anchorToBottom),
              query: _proteinasRef,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return SizeTransition(
                    sizeFactor: animation,
                    child: Card(
                      child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child:
                                Text("${snapshot.value['nombre'].toString()}"),
                          ),
                          subtitle: Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                                "${snapshot.value['descripcion'].toString()}"),
                          ),
                          contentPadding: EdgeInsets.all(2.0),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  _onUpdateProteina(
                                      snapshot.key.toString(),
                                      snapshot.value['nombre'],
                                      snapshot.value['descripcion']);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.brown,
                                  size: 20.0,
                                ),
                                onPressed: () {
                                  _ondeleteProteina(
                                      snapshot.key, snapshot.value['nombre']);
                                },
                              ),
                            ],
                          )),
                    ));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayDialogForm,
        backgroundColor: Colors.green,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

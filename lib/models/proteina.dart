import 'package:firebase_database/firebase_database.dart';

class Proteina {
  String key;
  String nombre;
  String descripcion;

  Proteina(this.key, this.nombre, this.descripcion);

  Proteina.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        nombre = snapshot.value['nombre'],
        descripcion = snapshot.value['descripcion'];

  tojson() {
    return {"nombre": nombre, "descripcion": descripcion};
  }
}

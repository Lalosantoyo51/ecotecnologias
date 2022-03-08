class ProviderImpresora {
  String _nombre;
  int _Nantena;
  String _direccion;
  String _coment;
  String _folio;

  int _phone;

  set nombre(String value) {
    _nombre = value;
  }

  set Nantena(int value) {
    print('se inserta Nantena $value');
    _Nantena = value;
  }

  set direccion(String value) {
    _direccion = value;
  }

  set coment(String value) {
    _coment = value;
  }

  set folio(String value) {
    _folio = value;
  }

  set phone(int value) {
    _phone = value;
  }

  int get Nantena => _Nantena;

  String get direccion => _direccion;

  String get coment => _coment;

  String get folio => _folio;
  String get nombre => _nombre;

  int get phone => _phone;
}

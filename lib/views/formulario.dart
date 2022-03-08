import 'package:flutter/material.dart';
import 'package:impresora/clases/class_impresora.dart';
import 'package:impresora/widgets/text_field_widget.dart';
import 'package:provider/provider.dart';

class FormularioView extends StatelessWidget {
  FormularioView({Key key}) : super(key: key);
  TextEditingController nombre = TextEditingController();
  TextEditingController Nantena = TextEditingController();
  TextEditingController comentario = TextEditingController();
  TextEditingController folio = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ProviderImpresora impresora = ProviderImpresora();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    void validateAndSave() {
      final FormState form = _formKey.currentState;
      if (form.validate()) {
        print('Form is valid');
        impresora.Nantena = int.parse(Nantena.text);
        impresora.nombre = nombre.text;
        impresora.coment = comentario.text;
        impresora.folio = folio.text;
        Navigator.of(context).pushNamed('impresora', arguments: {'impresora': impresora});
      } else {
        print('Form is invalid');
      }
    }
    return Container(
      width: width,
      height: height,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Inicio'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFieldWidget(
                  controller: folio,
                  text: 'Folio',
                  isRequerided: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  controller: nombre,
                  text: 'Nombre',
                  isRequerided: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  controller: Nantena,
                  text: 'Numero de antena',
                  isNumeric: true,
                  isRequerided: true,
                ),
                const SizedBox(
                  height: 20,
                ),

                TextFieldWidget(controller: comentario, text: 'Comentario',isRequerided: true,),
                const SizedBox(
                  height: 20,
                ),

                TextButton(
                    onPressed: () {
                      validateAndSave();

                    },
                    child: Text('Imprimir'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

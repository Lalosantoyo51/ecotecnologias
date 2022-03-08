import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  String text;
  TextEditingController controller;
  bool isNumeric = false;
  bool isRequerided = false;
  TextFieldWidget({Key key, this.text,this.controller,this.isNumeric,this.isRequerided}) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        keyboardType: widget.isNumeric == true ?  TextInputType.number :  TextInputType.name,
        validator: (value) {
         if(widget.isRequerided == true){
           return value.isEmpty ? '*El campo ${widget.text} es requerido' : null;
         }else{
           return null;
         }
        },
        decoration:  InputDecoration(
            labelText: widget.text,
            labelStyle: const TextStyle(color: Colors.black),
            border: const OutlineInputBorder(
              borderRadius:  BorderRadius.all(
                 Radius.circular(15.0),
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius:  BorderRadius.all(
                 Radius.circular(15.0),
              ),
              borderSide:  BorderSide(color: Colors.black, width: 1),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius:  BorderRadius.all(
                 Radius.circular(15.0),
              ),
              borderSide:  BorderSide(color: Colors.black, width: 1),
            ),
            filled: true,
            hintStyle:  TextStyle(color: Colors.grey[800]),
            hintText: widget.text,
            fillColor: Colors.white70)
    );
  }
}

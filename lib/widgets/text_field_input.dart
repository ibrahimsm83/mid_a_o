import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextFieldInput extends StatefulWidget {
  const TextFieldInput({
    Key? key,
    required this.hintText,
    required this.inputType,
    required this.inputAction,
    required this.focusNode,
    required this.formFieldSubmitted,
    required this.validator,
    required this.onChanged,
    this.prefixPath,
    this.inputFormatters,
    this.isPassword = false,
    this.hintStyle,
    this.textStyle,
    this.initialValue,
    this.readOnly,
    this.textEditingController,
  }) : super(key: key);

  final String hintText;
  final String? initialValue;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final FocusNode focusNode;
  final Function(String) formFieldSubmitted, onChanged;
  final String? Function(String?) validator;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? hintStyle, textStyle;
  final TextEditingController? textEditingController;
  final bool? readOnly;
  final String? prefixPath;

  @override
  _TextFieldInputState createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  bool visible = true;

  Widget _showInput() {
    return TextFormField(
      controller: widget.textEditingController,
      //initialValue: widget.initialValue ?? '',
      textInputAction: widget.inputAction,

      keyboardType: widget.inputType,
      readOnly: widget.readOnly ?? false,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.formFieldSubmitted,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword ? visible : false,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyText2,
      onChanged: widget.onChanged,
      inputFormatters: widget.inputFormatters ?? [],
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        errorMaxLines: 3,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        prefixIcon: widget.prefixPath != null
            ? ImageIcon(
                AssetImage(widget.prefixPath ?? ''),
                color: Theme.of(context).primaryColor,
              )
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: visible
                    ? Icon(
                        FontAwesomeIcons.eye,
                        color: Theme.of(context).primaryColor,
                        size: 14,
                      )
                    : Icon(
                        FontAwesomeIcons.eyeSlash,
                        color: Theme.of(context).primaryColor,
                        size: 14,
                      ),
                onPressed: () {
                  setState(() {
                    visible = !visible;
                  });
                },
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(Radius.circular(28.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(28.0),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(28.0),
          ),
        ),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.grey,
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        elevation: 8.0,
        shadowColor: Colors.grey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(28.0),
        color: Colors.transparent,
        child: _showInput());

    // Container(
  }
}

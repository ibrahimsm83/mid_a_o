import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mao/utils/image_utility.dart';
import 'package:mao/widgets/add_photos.dart';
import 'package:mao/widgets/review_photo.dart';


class FormBuilderImagePicker extends StatefulWidget {
  final List<FormFieldValidator> validators;
  final InputDecoration decoration;
final ValueChanged<List<dynamic>?> onChanged;
final BuildContext context;

  
  final bool inDialog; 


  const FormBuilderImagePicker({
    Key? key,
    this.validators = const [],
    this.inDialog = false,
    required this.onChanged,
    required this.context,

    this.decoration = const InputDecoration(),
  }) : super(key: key);

  @override
  _FormBuilderImagePickerState createState() => _FormBuilderImagePickerState();
}

class _FormBuilderImagePickerState extends State<FormBuilderImagePicker> {
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  final ImagePickerUtility _imagePickerUtility = ImagePickerUtility();

  Future<File?> addPhoto() async {
    if(widget.inDialog){
      return _imagePickerUtility.pickImageWithGallery();
    }else{
    return _imagePickerUtility.pickImageWithReturn(context);

    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List>(
      initialValue: [],

      validator: (val) {
        for (int i = 0; i < widget.validators.length; i++) {
          if (widget.validators[i](val) != null) {
            return widget.validators[i](val);
          }
        }
        return null;
      },
    
      onSaved: (val) {},
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            enabled: true,
            errorText: field.errorText,
            border: InputBorder.none,
            // ignore: deprecated_member_use_from_same_package
          ),
          child: Container(
            padding: EdgeInsets.only(top: 10,),
          
            child: Wrap(
                spacing: 10,
                runSpacing: 10,
                
                children: field.value!.map<Widget>((item) {
                  return ReviewPhotos(
                    photo: item,
                    onTap: () {
                      final _value = field.value;
                      if (_value != null) {
                        field.didChange([..._value]..remove(item));
                      }
                    },
                    realOnly: false,
                  );
                }).toList()
                  ..add(AddPhotos(onPressed: () {
                    addPhoto().then((value) {
                      if (value != null) {
                        setState(() {
                          field.value!.add(value);

                        });
                        widget.onChanged(field.value);
                      }
                    });
                  }))),
          ),
        );
      
      },
    );
  }
}

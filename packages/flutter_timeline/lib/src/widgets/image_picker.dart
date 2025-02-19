import "dart:typed_data";

import "package:dotted_border/dotted_border.dart";
import "package:flutter/material.dart";
import "package:flutter_image_picker/flutter_image_picker.dart";

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({required this.onImageChanged, super.key});

  final Function(Uint8List?) onImageChanged;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? image;
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GestureDetector(
            onTap: () async {
              image = await pickImage(context);
              widget.onImageChanged(image);
              setState(() {});
            },
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: const [6, 6],
              color: Colors.grey,
              strokeWidth: 3,
              child: image == null
                  ? const SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Icon(Icons.image, size: 64),
                    )
                  : Image.memory(image!),
            ),
          ),
          if (image != null) ...[
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  widget.onImageChanged(null);
                  setState(() {
                    image = null;
                  });
                },
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      );
}

Future<Uint8List?> pickImage(BuildContext context) async {
  var theme = Theme.of(context);
  var result = await showModalBottomSheet<Uint8List?>(
    context: context,
    builder: (context) => Container(
      padding: const EdgeInsets.all(20),
      color: theme.colorScheme.surface,
      child: ImagePicker(
        config: const ImagePickerConfig(),
        theme: ImagePickerTheme(
          titleStyle: theme.textTheme.titleMedium,
          iconSize: 40,
          selectImageText: "UPLOAD FILE",
          makePhotoText: "TAKE PICTURE",
          selectImageIcon: const Icon(
            size: 40,
            Icons.insert_drive_file,
          ),
          closeButtonBuilder: (onTap) => TextButton(
            onPressed: () {
              onTap();
            },
            child: Text(
              "Cancel",
              style: theme.textTheme.bodyMedium!.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ),
    ),
  );
  return result;
}

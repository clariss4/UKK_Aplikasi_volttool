// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:file_picker/file_picker.dart';

// class FilePickerHelper {
//   static Future<File?> pickImage() async {
//     // MOBILE
//     if (Platform.isAndroid || Platform.isIOS) {
//       final picker = ImagePicker();
//       final XFile? image =
//           await picker.pickImage(source: ImageSource.gallery);
//       if (image == null) return null;
//       return File(image.path);
//     }

//     // DESKTOP
//     if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.image,
//       );
//       if (result == null || result.files.single.path == null) return null;
//       return File(result.files.single.path!);
//     }

//     return null;
//   }
// }

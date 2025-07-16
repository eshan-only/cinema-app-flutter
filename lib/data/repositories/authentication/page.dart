// import 'package:cinema_app/data/repositories/authentication/upload_area.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';

// class Home_Page extends StatefulWidget {
//   const Home_Page({super.key});

//   @override
//   State<Home_Page> createState() => _HomePageState();
// }

// class _HomePageState extends State<Home_Page> {
//   FilePickerResult? _filePickerResult;

//   void _openFilePicker() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       allowMultiple: false,
//       allowedExtensions: ["jpg", "jpeg", "png", "mp4"],
//       type: FileType.custom,
//     );
//     setState(() {
//       _filePickerResult = result;
//     });

//     if (_filePickerResult != null) {
//       // Pass the file picker result to the UploadArea screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => UploadArea(), // Navigate to UploadArea
//           settings: RouteSettings(arguments: _filePickerResult), // Pass the argument
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("You"),
//       ),
//       body: Center(
//         child: Text(
//           _filePickerResult != null
//               ? "File Selected: ${_filePickerResult!.files.single.name}"
//               : "No file selected",
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _openFilePicker,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

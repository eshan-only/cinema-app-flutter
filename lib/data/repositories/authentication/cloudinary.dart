import 'dart:convert'; // For jsonDecode
import 'dart:typed_data'; // For Uint8List
import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img; // Image package

Future<String?> uploadToCloudinary(FilePickerResult? filePickerResult) async {
  // Check if user selected a file
  if (filePickerResult == null || filePickerResult.files.isEmpty) {
    print("No file selected.");
    return null;
  }

  // Get the file bytes (only works on web or memory access)
  Uint8List? fileBytes = filePickerResult.files.single.bytes;
  if (fileBytes == null) {
    print("Error: Could not read file bytes.");
    return null;
  }

  // Get the file name
  String fileName = filePickerResult.files.single.name;

  // Get your Cloudinary cloud name from environment
  String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  if (cloudName.isEmpty) {
    print("Cloudinary cloud name not found in .env");
    return null;
  }

  // Decode the image from bytes
  img.Image? image = img.decodeImage(fileBytes);
  if (image == null) {
    print("Error: The selected file is not a valid image.");
    return null;
  }

  // Resize and compress the image
  img.Image resized = img.copyResize(image, width: 800); // You can adjust width
  Uint8List compressedBytes = Uint8List.fromList(
    img.encodeJpg(resized, quality: 85),
  );

  // Prepare multipart request for Cloudinary upload
  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
  var request = http.MultipartRequest("POST", uri);

  // Add file to request
  var multipartFile = http.MultipartFile.fromBytes(
    'file',
    compressedBytes,
    filename: fileName,
  );

  request.files.add(multipartFile);
  request.fields['upload_preset'] = "preset-for-movies"; // Set this in Cloudinary
  request.fields['resource_type'] = "image"; // or "raw" if you're uploading non-images

  // Send the request
  var response = await request.send();
  var responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    print("Upload Successful");

    var data = jsonDecode(responseBody);
    String? secureUrl = data['secure_url'];

    if (secureUrl != null) {
      return secureUrl;
    } else {
      print("Error: 'secure_url' missing in response.");
      return null;
    }
  } else {
    print("Upload failed with status code: ${response.statusCode}");
    print("Response: $responseBody");
    return null;
  }
}

import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class MediaRepo {
  final cloudinary = Cloudinary.signedConfig(
    apiKey: '434129764312563'.trim(),
    apiSecret: 'KFz61j8yUVUQWBBPQPTpeHN3wps'.trim(),
    cloudName: 'daz1v8qel'.trim().toLowerCase(),
  );

  Future<String?> uploadImage(XFile file) async {
    try {
      print('Attempting upload to Cloudinary...');
      print('File: ${file.path}');
      
      final bytes = await file.readAsBytes();
      print('File Bytes: ${bytes.length}');

      final response = await cloudinary.upload(
        file: file.path, 
        fileBytes: bytes,
        resourceType: CloudinaryResourceType.image,
        folder: 'safe_go_uploads', 
        fileName: 'img_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (response.isSuccessful) {
        print('Upload Success: ${response.secureUrl}');
        return response.secureUrl;
      } else {
        print('Cloudinary Error: ${response.error}');
        return null;
      }
    } on DioException catch (e) {
      print('DioError: ${e.response?.statusCode} - ${e.response?.data}');
      return null;
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }
}
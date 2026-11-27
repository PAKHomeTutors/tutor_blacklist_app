import 'dart:io';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as p;

class R2Service {
  // ---------------------------------------------------------------------------
  // 🔐 CREDENTIALS - Replace these placeholders with your Cloudflare R2 values
  // ---------------------------------------------------------------------------
  // Find these in Cloudflare Dashboard > R2 > Manage R2 API Tokens
  static const String _endpoint = 'YOUR_ACCOUNT_ID.r2.cloudflarestorage.com';
  static const String _accessKey = 'YOUR_R2_ACCESS_KEY_ID';
  static const String _secretKey = 'YOUR_R2_SECRET_ACCESS_KEY';
  static const String _bucketName = 'YOUR_BUCKET_NAME';

  // Public URL prefix (if you have a custom domain or R2.dev subdomain enabled)
  // Example: 'https://pub-xxxxx.r2.dev' or 'https://files.yourdomain.com'
  static const String _publicBaseUrl = 'https://YOUR_PUBLIC_R2_DOMAIN';

  late final Minio _minio;

  R2Service() {
    _minio = Minio(
      endPoint: _endpoint,
      accessKey: _accessKey,
      secretKey: _secretKey,
      region: 'auto',       // Required for Cloudflare R2
      useSSL: true,         // R2 requires HTTPS
    );
  }

  /// Uploads a file to R2 and returns the public URL.
  /// [file] - The local file to upload.
  /// [fileName] - Desired path/key inside the bucket (e.g., 'documents/cnic_123.jpg').
  Future<String> uploadFile(File file, String fileName) async {
    try {
      // Ensure bucket exists (optional, but safe for first run)
      final bucketExists = await _minio.bucketExists(_bucketName);
      if (!bucketExists) {
        await _minio.makeBucket(_bucketName);
      }

      // Determine content type based on extension
      final ext = p.extension(file.path).toLowerCase();
      final contentType = _getContentType(ext);

      // Upload the file
      await _minio.fPutObject(
        _bucketName,
        fileName,
        file.path,
        contentType: contentType,
      );

      // Return the public URL
      // Note: If your bucket is private, you'll need to generate presigned URLs instead.
      final publicUrl = '$_publicBaseUrl/$fileName';
      return publicUrl;
    } catch (e) {
      throw Exception('R2 Upload failed: $e');
    }
  }

  /// Generates a presigned URL for private bucket access (valid for 1 hour).
  /// Use this if you don't have a public R2 domain configured.
  Future<String> getPresignedUrl(String fileName) async {
    try {
      return await _minio.presignedGetObject(
        _bucketName,
        fileName,
        expires: 3600, // 1 hour
      );
    } catch (e) {
      throw Exception('Failed to generate presigned URL: $e');
    }
  }

  String _getContentType(String extension) {
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
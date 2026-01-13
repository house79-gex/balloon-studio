import 'package:balloon_design_studio/src/features/quotes/domain/quote_model.dart';

/// PDF export type
enum PdfExportType {
  simplified,     // Free tier: basic PDF
  professional,   // Pro tier: advanced PDF with branding
}

/// PDF export service interface
abstract class PdfExportService {
  /// Export quote to PDF
  Future<List<int>> exportQuote({
    required Quote quote,
    required PdfExportType type,
  });
  
  /// Export BOM to PDF
  Future<List<int>> exportBom({
    required int projectId,
    required PdfExportType type,
  });
  
  /// Export project design to PDF
  Future<List<int>> exportDesign({
    required int projectId,
    required PdfExportType type,
    bool includeSpecs = false,
  });
}

/// Image export service interface (Pro only)
abstract class ImageExportService {
  /// Export project design as image
  Future<List<int>> exportDesignImage({
    required int projectId,
    required ImageFormat format,
    int? width,
    int? height,
  });
}

enum ImageFormat {
  png,
  jpeg,
}

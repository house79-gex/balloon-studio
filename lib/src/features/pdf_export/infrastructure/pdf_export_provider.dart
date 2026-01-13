import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:balloon_design_studio/src/features/pdf_export/domain/export_service.dart';
import 'package:balloon_design_studio/src/features/pdf_export/infrastructure/pdf_export_service_impl.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_provider.dart';

/// Provider for PDF export service
final pdfExportServiceProvider = Provider<PdfExportService>((ref) {
  final entitlements = ref.watch(entitlementsProvider);
  return PdfExportServiceImpl(entitlements);
});

/// Provider for image export service (Pro feature)
final imageExportServiceProvider = Provider<ImageExportService>((ref) {
  return ImageExportServiceImpl();
});

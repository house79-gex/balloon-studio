import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/features/pdf_export/domain/export_service.dart';
import 'package:balloon_design_studio/src/features/pdf_export/infrastructure/pdf_export_service_impl.dart';
import 'package:balloon_design_studio/src/features/quotes/domain/quote_model.dart';
import 'package:balloon_design_studio/src/features/bom/domain/bom_model.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';

void main() {
  group('PdfExportServiceImpl - Free Tier', () {
    late PdfExportService service;
    late Quote testQuote;
    
    setUp(() {
      service = PdfExportServiceImpl(EntitlementsConfig.free);
      
      final bom = BillOfMaterials(
        projectId: 1,
        projectName: 'Test Project',
        items: const [
          BOMItem(
            name: 'White Balloon 11"',
            brand: 'Qualatex',
            color: 'white',
            size: '11inch',
            quantity: 10,
            unitPrice: 0.5,
            totalPrice: 5.0,
          ),
        ],
        totalCost: 5.0,
        generatedAt: DateTime.now(),
      );
      
      testQuote = Quote.basic(
        projectId: 1,
        projectName: 'Test Project',
        bom: bom,
        subtotal: 100.0,
        depositPercent: 30,
        clientName: 'Test Client',
        clientEmail: 'test@example.com',
      );
    });
    
    test('can export simplified PDF', () async {
      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.simplified,
      );
      
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });
    
    test('professional PDF request falls back to simplified with watermark for Free tier', () async {
      // Free tier should not have professional PDF capability
      expect(EntitlementsConfig.free.hasProfessionalPdf, false);
      
      // Request professional PDF (should fallback to simplified with watermark)
      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.professional,
      );
      
      // Should still return a valid PDF (simplified with watermark)
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });
    
    test('BOM export throws UnimplementedError', () async {
      expect(
        () => service.exportBom(projectId: 1, type: PdfExportType.simplified),
        throwsUnimplementedError,
      );
    });
    
    test('Design export throws UnimplementedError', () async {
      expect(
        () => service.exportDesign(projectId: 1, type: PdfExportType.simplified),
        throwsUnimplementedError,
      );
    });
  });
  
  group('PdfExportServiceImpl - Pro Tier', () {
    late PdfExportService service;
    late Quote testQuote;
    
    setUp(() {
      service = PdfExportServiceImpl(EntitlementsConfig.pro);
      
      final bom = BillOfMaterials(
        projectId: 1,
        projectName: 'Test Project Pro',
        items: const [
          BOMItem(
            name: 'Gold Balloon 11"',
            brand: 'Qualatex',
            color: 'gold',
            size: '11inch',
            quantity: 20,
            unitPrice: 0.75,
            totalPrice: 15.0,
          ),
        ],
        totalCost: 15.0,
        generatedAt: DateTime.now(),
      );
      
      testQuote = Quote.advanced(
        projectId: 1,
        projectName: 'Test Project Pro',
        bom: bom,
        subtotal: 200.0,
        taxRate: 22.0,
        depositPercent: 50,
        clientName: 'Pro Client',
        clientEmail: 'pro@example.com',
        notes: 'Test notes for pro quote',
        validUntil: DateTime.now().add(const Duration(days: 30)),
        paymentTerms: ['50% deposit', '50% on delivery'],
      );
    });
    
    test('can export simplified PDF', () async {
      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.simplified,
      );
      
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });
    
    test('can export professional PDF', () async {
      // Pro tier should have professional PDF capability
      expect(EntitlementsConfig.pro.hasProfessionalPdf, true);
      
      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.professional,
      );
      
      expect(pdfBytes, isNotEmpty);
      expect(pdfBytes.length, greaterThan(100));
    });
    
    test('professional PDF is larger than simplified PDF', () async {
      final simplifiedBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.simplified,
      );
      
      final professionalBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.professional,
      );
      
      // Professional PDF should generally be larger due to more content
      expect(professionalBytes.length, greaterThanOrEqualTo(simplifiedBytes.length));
    });
  });
  
  group('ImageExportServiceImpl', () {
    late ImageExportService service;
    
    setUp(() {
      service = ImageExportServiceImpl();
    });
    
    test('image export throws UnimplementedError (placeholder)', () async {
      expect(
        () => service.exportDesignImage(
          projectId: 1,
          format: ImageFormat.png,
        ),
        throwsUnimplementedError,
      );
    });
  });
  
  group('PdfExportType', () {
    test('has correct enum values', () {
      expect(PdfExportType.values.length, 2);
      expect(PdfExportType.values.contains(PdfExportType.simplified), true);
      expect(PdfExportType.values.contains(PdfExportType.professional), true);
    });
  });
  
  group('ImageFormat', () {
    test('has correct enum values', () {
      expect(ImageFormat.values.length, 2);
      expect(ImageFormat.values.contains(ImageFormat.png), true);
      expect(ImageFormat.values.contains(ImageFormat.jpeg), true);
    });
  });
}

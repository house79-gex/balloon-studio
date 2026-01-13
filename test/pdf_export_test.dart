import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_design_studio/src/features/pdf_export/domain/export_service.dart';
import 'package:balloon_design_studio/src/features/pdf_export/domain/pdf_export_service_impl.dart';
import 'package:balloon_design_studio/src/features/quotes/domain/quote_model.dart';
import 'package:balloon_design_studio/src/features/bom/domain/bom_model.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';

void main() {
  group('PdfExportServiceImpl', () {
    late BillOfMaterials testBom;
    late Quote testQuote;

    setUp(() {
      testBom = BillOfMaterials(
        projectId: 1,
        projectName: 'Test Project',
        items: const [
          BOMItem(
            name: 'Balloon 11"',
            brand: 'Qualatex',
            color: 'Red',
            size: '11 inch',
            quantity: 50,
            unitPrice: 0.50,
            totalPrice: 25.00,
          ),
          BOMItem(
            name: 'Balloon Weight',
            quantity: 2,
            unitPrice: 5.00,
            totalPrice: 10.00,
          ),
        ],
        totalCost: 35.00,
        generatedAt: DateTime.now(),
      );

      testQuote = Quote.basic(
        projectId: 1,
        projectName: 'Test Project',
        bom: testBom,
        subtotal: 35.00,
        depositPercent: 50,
        clientName: 'Test Client',
        clientEmail: 'client@test.com',
      );
    });

    test('Free tier can export simplified PDF', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.free);

      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.simplified,
      );

      expect(pdfBytes, isNotEmpty);
    });

    test('Free tier cannot export professional PDF', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.free);

      expect(
        () => service.exportQuote(
          quote: testQuote,
          type: PdfExportType.professional,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Pro tier can export simplified PDF', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.pro);

      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.simplified,
      );

      expect(pdfBytes, isNotEmpty);
    });

    test('Pro tier can export professional PDF', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.pro);

      final pdfBytes = await service.exportQuote(
        quote: testQuote,
        type: PdfExportType.professional,
      );

      expect(pdfBytes, isNotEmpty);
    });

    test('Free tier cannot export professional BOM', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.free);

      expect(
        () => service.exportBom(
          projectId: 1,
          type: PdfExportType.professional,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Pro tier can export professional BOM', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.pro);

      final pdfBytes = await service.exportBom(
        projectId: 1,
        type: PdfExportType.professional,
      );

      expect(pdfBytes, isNotEmpty);
    });

    test('Free tier cannot export professional design', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.free);

      expect(
        () => service.exportDesign(
          projectId: 1,
          type: PdfExportType.professional,
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('Pro tier can export professional design', () async {
      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.pro);

      final pdfBytes = await service.exportDesign(
        projectId: 1,
        type: PdfExportType.professional,
      );

      expect(pdfBytes, isNotEmpty);
    });

    test('Advanced quote with tax can be exported', () async {
      final advancedQuote = Quote.advanced(
        projectId: 1,
        projectName: 'Advanced Project',
        bom: testBom,
        subtotal: 100.00,
        taxRate: 22.0,
        depositPercent: 30,
        clientName: 'Pro Client',
        notes: 'Test notes',
        validUntil: DateTime.now().add(const Duration(days: 30)),
      );

      final service = PdfExportServiceImpl(entitlements: EntitlementsConfig.pro);

      final pdfBytes = await service.exportQuote(
        quote: advancedQuote,
        type: PdfExportType.professional,
      );

      expect(pdfBytes, isNotEmpty);
    });
  });
}

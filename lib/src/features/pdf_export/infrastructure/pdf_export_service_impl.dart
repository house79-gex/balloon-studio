import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:balloon_design_studio/src/features/pdf_export/domain/export_service.dart';
import 'package:balloon_design_studio/src/features/quotes/domain/quote_model.dart';
import 'package:balloon_design_studio/src/features/bom/domain/bom_model.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';
import 'package:intl/intl.dart';

/// PDF export service implementation
class PdfExportServiceImpl implements PdfExportService {
  final EntitlementsConfig _entitlements;
  
  // Watermark text for free tier accessing professional export
  static const String _freeWatermarkText = 'Versione gratuita';
  
  PdfExportServiceImpl(this._entitlements);
  
  @override
  Future<List<int>> exportQuote({
    required Quote quote,
    required PdfExportType type,
  }) async {
    // Check if user has permission for this export type
    if (type == PdfExportType.professional && !_entitlements.hasProfessionalPdf) {
      // If Free tier tries to access professional, fall back to simplified with watermark
      return _generateSimplifiedQuotePdf(quote, applyWatermark: true);
    }
    
    if (type == PdfExportType.professional) {
      return _generateProfessionalQuotePdf(quote);
    } else {
      return _generateSimplifiedQuotePdf(quote, applyWatermark: false);
    }
  }
  
  @override
  Future<List<int>> exportBom({
    required int projectId,
    required PdfExportType type,
  }) async {
    // Placeholder implementation - would load BOM from database
    throw UnimplementedError('BOM export not yet implemented');
  }
  
  @override
  Future<List<int>> exportDesign({
    required int projectId,
    required PdfExportType type,
    bool includeSpecs = false,
  }) async {
    // Placeholder implementation - would render project design
    throw UnimplementedError('Design export not yet implemented');
  }
  
  /// Generate professional PDF with full layout
  Future<List<int>> _generateProfessionalQuotePdf(Quote quote) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildProfessionalHeader(quote, dateFormat),
              pw.SizedBox(height: 20),
              
              // Client Information
              _buildClientInfoSection(quote),
              pw.SizedBox(height: 20),
              
              // BOM Section
              pw.Text(
                'Distinta Base / Bill of Materials',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildBomTable(quote.bom),
              pw.SizedBox(height: 20),
              
              // Preventivo/Quote Section
              pw.Text(
                'Preventivo / Quote',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              _buildQuoteSummary(quote),
              
              // Additional notes for advanced quotes
              if (quote.type == QuoteType.advanced && quote.notes != null) ...[
                pw.SizedBox(height: 20),
                pw.Text(
                  'Note',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(quote.notes!),
              ],
              
              // Payment terms for advanced quotes
              if (quote.type == QuoteType.advanced && quote.paymentTerms != null) ...[
                pw.SizedBox(height: 15),
                pw.Text(
                  'Termini di Pagamento',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 5),
                ...quote.paymentTerms!.map((term) => pw.Text('• $term')),
              ],
              
              // Valid until date
              if (quote.validUntil != null) ...[
                pw.SizedBox(height: 15),
                pw.Text(
                  'Validità: fino al ${dateFormat.format(quote.validUntil!)}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ],
          );
        },
      ),
    );
    
    return pdf.save();
  }
  
  /// Generate simplified PDF with concise layout
  Future<List<int>> _generateSimplifiedQuotePdf(
    Quote quote, {
    required bool applyWatermark,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // Main content
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Simple header
                  pw.Text(
                    'Preventivo - ${quote.projectName}',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  
                  // Date and client
                  pw.Text('Data: ${dateFormat.format(quote.createdAt)}'),
                  if (quote.clientName != null)
                    pw.Text('Cliente: ${quote.clientName}'),
                  pw.SizedBox(height: 20),
                  
                  // Minimal BOM
                  pw.Text(
                    'Materiali',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  _buildSimplifiedBomTable(quote.bom),
                  pw.SizedBox(height: 20),
                  
                  // Summary
                  _buildSimplifiedSummary(quote),
                  
                  // Notes if present
                  if (quote.notes != null) ...[
                    pw.SizedBox(height: 15),
                    pw.Text('Note: ${quote.notes}'),
                  ],
                ],
              ),
              
              // Watermark if Free tier accessed this
              if (applyWatermark)
                pw.Positioned(
                  top: 300,
                  left: 100,
                  child: pw.Transform.rotate(
                    angle: -0.5,
                    child: pw.Opacity(
                      opacity: 0.2,
                      child: pw.Text(
                        _freeWatermarkText,
                        style: pw.TextStyle(
                          fontSize: 80,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
    
    return pdf.save();
  }
  
  /// Build professional header with project info
  pw.Widget _buildProfessionalHeader(Quote quote, DateFormat dateFormat) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'PREVENTIVO / QUOTE',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Progetto: ${quote.projectName}',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text('Data: ${dateFormat.format(quote.createdAt)}'),
          pw.Text('ID Progetto: ${quote.projectId}'),
        ],
      ),
    );
  }
  
  /// Build client information section
  pw.Widget _buildClientInfoSection(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Informazioni Cliente',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 5),
          if (quote.clientName != null)
            pw.Text('Nome: ${quote.clientName}')
          else
            pw.Text('Nome: [Da specificare]'),
          if (quote.clientEmail != null)
            pw.Text('Email: ${quote.clientEmail}')
          else
            pw.Text('Email: [Da specificare]'),
        ],
      ),
    );
  }
  
  /// Build BOM table for professional layout
  pw.Widget _buildBomTable(BillOfMaterials bom) {
    return pw.Table.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.grey),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 10,
      ),
      cellStyle: const pw.TextStyle(fontSize: 9),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: ['Articolo', 'Marca', 'Colore', 'Taglia', 'Qtà', 'Prezzo/U', 'Totale'],
      data: bom.items.map((item) {
        return [
          item.name,
          item.brand ?? '-',
          item.color ?? '-',
          item.size ?? '-',
          item.quantity.toString(),
          '€${item.unitPrice.toStringAsFixed(2)}',
          '€${item.totalPrice.toStringAsFixed(2)}',
        ];
      }).toList(),
    );
  }
  
  /// Build simplified BOM table
  pw.Widget _buildSimplifiedBomTable(BillOfMaterials bom) {
    return pw.Table.fromTextArray(
      border: pw.TableBorder.all(color: PdfColors.grey),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      headers: ['Articolo', 'Qtà', 'Totale'],
      data: bom.items.map((item) {
        return [
          item.name,
          item.quantity.toString(),
          '€${item.totalPrice.toStringAsFixed(2)}',
        ];
      }).toList(),
    );
  }
  
  /// Build quote summary section
  pw.Widget _buildQuoteSummary(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Subtotale', quote.subtotal),
          if (quote.taxRate > 0) ...[
            _buildSummaryRow('IVA (${quote.taxRate.toStringAsFixed(0)}%)', quote.taxAmount),
            pw.Divider(),
            _buildSummaryRow('Totale', quote.total, isBold: true),
          ] else
            _buildSummaryRow('Totale', quote.subtotal, isBold: true),
          if (quote.depositAmount != null) ...[
            pw.SizedBox(height: 10),
            _buildSummaryRow('Acconto', quote.depositAmount!),
            _buildSummaryRow('Saldo', quote.balanceAmount!),
          ],
        ],
      ),
    );
  }
  
  /// Build simplified summary
  pw.Widget _buildSimplifiedSummary(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Totale', quote.total, isBold: true),
          if (quote.depositAmount != null) ...[
            pw.SizedBox(height: 5),
            _buildSummaryRow('Acconto', quote.depositAmount!),
            _buildSummaryRow('Saldo', quote.balanceAmount!),
          ],
        ],
      ),
    );
  }
  
  /// Build a summary row
  pw.Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          '€${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// Image export service implementation (placeholder)
class ImageExportServiceImpl implements ImageExportService {
  @override
  Future<List<int>> exportDesignImage({
    required int projectId,
    required ImageFormat format,
    int? width,
    int? height,
  }) async {
    // Placeholder implementation for image export (Pro feature)
    // In production, this would render the design to an image
    throw UnimplementedError('Image export feature coming soon');
  }
}

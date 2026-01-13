import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:balloon_design_studio/src/features/quotes/domain/quote_model.dart';
import 'package:balloon_design_studio/src/features/pdf_export/domain/export_service.dart';
import 'package:balloon_design_studio/src/core/entitlements/entitlements_config.dart';

/// Implementation of PDF export service
class PdfExportServiceImpl implements PdfExportService {
  final EntitlementsConfig entitlements;

  PdfExportServiceImpl({required this.entitlements});

  /// Check if export type is allowed for current tier
  bool _isExportAllowed(PdfExportType type) {
    switch (type) {
      case PdfExportType.simplified:
        return entitlements.hasSimplifiedPdf;
      case PdfExportType.professional:
        return entitlements.hasProfessionalPdf;
    }
  }

  /// Should add watermark (Free tier accessing content)
  bool _shouldWatermark() {
    return entitlements.tier == EntitlementTier.free;
  }

  @override
  Future<List<int>> exportQuote({
    required Quote quote,
    required PdfExportType type,
  }) async {
    // Check if export type is allowed
    if (!_isExportAllowed(type)) {
      throw Exception(
          'Export type ${type.name} not available in ${entitlements.tier.name} tier');
    }

    final pdf = pw.Document();

    if (type == PdfExportType.professional) {
      await _addProfessionalQuotePage(pdf, quote);
    } else {
      await _addSimplifiedQuotePage(pdf, quote);
    }

    return pdf.save();
  }

  @override
  Future<List<int>> exportBom({
    required int projectId,
    required PdfExportType type,
  }) async {
    // Check if export type is allowed
    if (!_isExportAllowed(type)) {
      throw Exception(
          'Export type ${type.name} not available in ${entitlements.tier.name} tier');
    }

    final pdf = pw.Document();

    // Placeholder implementation - would fetch actual BOM data
    if (type == PdfExportType.professional) {
      pdf.addPage(_buildProfessionalBomPage(projectId));
    } else {
      pdf.addPage(_buildSimplifiedBomPage(projectId));
    }

    return pdf.save();
  }

  @override
  Future<List<int>> exportDesign({
    required int projectId,
    required PdfExportType type,
    bool includeSpecs = false,
  }) async {
    // Check if export type is allowed
    if (!_isExportAllowed(type)) {
      throw Exception(
          'Export type ${type.name} not available in ${entitlements.tier.name} tier');
    }

    final pdf = pw.Document();

    // Placeholder implementation - would render actual design
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Text(
            'Design Export - Implementation Placeholder',
            style: pw.TextStyle(fontSize: 24),
          ),
        ),
      ),
    );

    return pdf.save();
  }

  /// Add professional quote page
  Future<void> _addProfessionalQuotePage(pw.Document pdf, Quote quote) async {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          // Header
          _buildProfessionalHeader(quote),
          pw.SizedBox(height: 20),

          // Client Information
          _buildClientInfo(quote),
          pw.SizedBox(height: 20),

          // Project Information
          _buildProjectInfo(quote),
          pw.SizedBox(height: 20),

          // BOM Section
          pw.Text(
            'Distinta Materiali / Bill of Materials',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildBomTable(quote, professional: true),
          pw.SizedBox(height: 20),

          // Preventivo Section
          pw.Text(
            'Preventivo / Quote',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildQuoteSummary(quote, professional: true),

          // Watermark if Free tier
          if (_shouldWatermark()) ...[
            pw.SizedBox(height: 20),
            _buildWatermark(),
          ],

          // Footer
          pw.SizedBox(height: 20),
          _buildFooter(),
        ],
      ),
    );
  }

  /// Add simplified quote page
  Future<void> _addSimplifiedQuotePage(pw.Document pdf, Quote quote) async {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Simple header
            pw.Text(
              'Preventivo Semplificato',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),

            // Project summary
            _buildSimplifiedSummary(quote),
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
            _buildBomTable(quote, professional: false),
            pw.SizedBox(height: 20),

            // Total
            _buildQuoteSummary(quote, professional: false),

            // Watermark if Free tier
            if (_shouldWatermark()) ...[
              pw.SizedBox(height: 20),
              _buildWatermark(),
            ],
          ],
        ),
      ),
    );
  }

  /// Build professional header
  pw.Widget _buildProfessionalHeader(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Balloon Design Studio',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue800,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Professional Balloon Art Design',
            style: const pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey700,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Data: ${DateFormat('dd/MM/yyyy').format(quote.createdAt)}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// Build client information
  pw.Widget _buildClientInfo(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Informazioni Cliente',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Nome: ${quote.clientName ?? 'Cliente'}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          if (quote.clientEmail != null)
            pw.Text(
              'Email: ${quote.clientEmail}',
              style: const pw.TextStyle(fontSize: 10),
            ),
        ],
      ),
    );
  }

  /// Build project information
  pw.Widget _buildProjectInfo(Quote quote) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Progetto: ${quote.projectName}',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          if (quote.notes != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              'Note: ${quote.notes}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
          if (quote.validUntil != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              'Valido fino a: ${DateFormat('dd/MM/yyyy').format(quote.validUntil!)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ],
      ),
    );
  }

  /// Build simplified summary
  pw.Widget _buildSimplifiedSummary(Quote quote) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Progetto: ${quote.projectName}',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 4),
        pw.Text('Data: ${DateFormat('dd/MM/yyyy').format(quote.createdAt)}',
            style: const pw.TextStyle(fontSize: 10)),
        if (quote.clientName != null) ...[
          pw.SizedBox(height: 4),
          pw.Text('Cliente: ${quote.clientName}',
              style: const pw.TextStyle(fontSize: 10)),
        ],
        if (quote.notes != null) ...[
          pw.SizedBox(height: 4),
          pw.Text('Note: ${quote.notes}',
              style: const pw.TextStyle(fontSize: 10)),
        ],
      ],
    );
  }

  /// Build BOM table
  pw.Widget _buildBomTable(Quote quote, {required bool professional}) {
    final currencyFormat = NumberFormat.currency(symbol: '€', decimalDigits: 2);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: professional
          ? {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(1.5),
            }
          : {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1.5),
            },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: professional
              ? [
                  _buildTableCell('Descrizione', bold: true),
                  _buildTableCell('Brand', bold: true),
                  _buildTableCell('Qtà', bold: true),
                  _buildTableCell('Prezzo Unit.', bold: true),
                  _buildTableCell('Totale', bold: true),
                ]
              : [
                  _buildTableCell('Descrizione', bold: true),
                  _buildTableCell('Qtà', bold: true),
                  _buildTableCell('Totale', bold: true),
                ],
        ),
        // Items
        ...quote.bom.items.map((item) {
          final itemDesc = professional
              ? '${item.name}${item.color != null ? ' - ${item.color}' : ''}${item.size != null ? ' (${item.size})' : ''}'
              : item.name;

          return pw.TableRow(
            children: professional
                ? [
                    _buildTableCell(itemDesc),
                    _buildTableCell(item.brand ?? '-'),
                    _buildTableCell('${item.quantity}'),
                    _buildTableCell(currencyFormat.format(item.unitPrice)),
                    _buildTableCell(currencyFormat.format(item.totalPrice)),
                  ]
                : [
                    _buildTableCell(itemDesc),
                    _buildTableCell('${item.quantity}'),
                    _buildTableCell(currencyFormat.format(item.totalPrice)),
                  ],
          );
        }).toList(),
      ],
    );
  }

  /// Build quote summary
  pw.Widget _buildQuoteSummary(Quote quote, {required bool professional}) {
    final currencyFormat = NumberFormat.currency(symbol: '€', decimalDigits: 2);

    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          _buildSummaryRow('Subtotale:', currencyFormat.format(quote.subtotal)),
          if (professional && quote.taxRate > 0) ...[
            pw.SizedBox(height: 4),
            _buildSummaryRow('IVA (${quote.taxRate.toStringAsFixed(0)}%):',
                currencyFormat.format(quote.taxAmount)),
          ],
          pw.SizedBox(height: 4),
          pw.Divider(),
          pw.SizedBox(height: 4),
          _buildSummaryRow(
            'Totale:',
            currencyFormat.format(quote.total),
            bold: true,
          ),
          if (quote.depositAmount != null) ...[
            pw.SizedBox(height: 8),
            _buildSummaryRow(
              'Acconto:',
              currencyFormat.format(quote.depositAmount),
            ),
            pw.SizedBox(height: 4),
            _buildSummaryRow(
              'Saldo:',
              currencyFormat.format(quote.balanceAmount),
            ),
          ],
        ],
      ),
    );
  }

  /// Build summary row
  pw.Widget _buildSummaryRow(String label, String value, {bool bold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  /// Build table cell
  pw.Widget _buildTableCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  /// Build watermark
  pw.Widget _buildWatermark() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.red300, width: 2),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        color: PdfColors.red50,
      ),
      child: pw.Center(
        child: pw.Text(
          'Versione gratuita',
          style: pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.red700,
          ),
        ),
      ),
    );
  }

  /// Build footer
  pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Center(
        child: pw.Text(
          'Generato con Balloon Design Studio',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey600,
          ),
        ),
      ),
    );
  }

  /// Build professional BOM page
  pw.Page _buildProfessionalBomPage(int projectId) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Distinta Materiali',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Progetto ID: $projectId',
              style: const pw.TextStyle(fontSize: 12)),
          pw.SizedBox(height: 20),
          pw.Text('Professional BOM - Implementation Placeholder'),
          if (_shouldWatermark()) ...[
            pw.SizedBox(height: 20),
            _buildWatermark(),
          ],
        ],
      ),
    );
  }

  /// Build simplified BOM page
  pw.Page _buildSimplifiedBomPage(int projectId) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Distinta Materiali',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Progetto ID: $projectId'),
          pw.SizedBox(height: 20),
          pw.Text('Simplified BOM - Implementation Placeholder'),
          if (_shouldWatermark()) ...[
            pw.SizedBox(height: 20),
            _buildWatermark(),
          ],
        ],
      ),
    );
  }
}

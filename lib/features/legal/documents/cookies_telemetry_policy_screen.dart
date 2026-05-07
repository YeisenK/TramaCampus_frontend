import 'package:flutter/material.dart';
import '../legal_documents_data.dart';
import '../widgets/legal_document_layout.dart';

class CookiesTelemetryPolicyScreen extends StatelessWidget {
  const CookiesTelemetryPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LegalDocumentLayout(document: kCookiesPolicy);
  }
}

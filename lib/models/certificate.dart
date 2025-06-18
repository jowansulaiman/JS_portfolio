import 'package:flutter/material.dart';

enum CertificateCategory { berufserfahrung, ausbildung, weiterbildung }

class Certificate {
  final String title, year, url;
  final IconData icon;
  final CertificateCategory category;
  const Certificate(this.title, this.year, this.icon, this.url, this.category);
}
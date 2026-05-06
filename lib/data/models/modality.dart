import 'modality_bucket.dart';
export 'modality_bucket.dart' show ModalityType, ModalityBucket;

// Back-compat shim: old code uses Modality.all / Modality.estudio etc.
// ModalityBucket is the authoritative class; this just re-exposes statics.
class Modality {
  Modality._();
  static const all = ModalityBucket.all;
  static const estudio = ModalityBucket.estudio;
  static const amistad = ModalityBucket.amistad;
  static const personal = ModalityBucket.personal;
}

part of database_service;

abstract class _FieldNameForImage {
  static String lastModified = 'last_modified';
}

class ImageData extends DatabaseDocument {
  Uint8List _data;
  Timestamp _lastModified;

  ImageData._create({required DocumentReference<Map<String, dynamic>> imageRef})
      : _data = _DefaultFieldValue.emptyUint8List,
        _lastModified = Timestamp.now(),
        super._create(ref: imageRef);

  ImageData._fromDatabase(
      {required DocumentSnapshot<Map<String, dynamic>> imageSnap,
      required Uint8List storageData})
      : _data = Uint8List.fromList(storageData.toList()),
        _lastModified = Timestamp.now(),
        super._fromDatabase(snap: imageSnap);

  Map<String, dynamic> _toDatabase() {
    return {
      _FieldNameForImage.lastModified: _lastModified,
    };
  }

  ImageData._fromCache(ImageData image)
      : _data = image.data,
        _lastModified = image._lastModified,
        super._create(ref: image._ref);

  ImageData toCache() {
    ImageData imageCopy = ImageData._create(imageRef: _ref);
    // ignore: unnecessary_this
    imageCopy.data = this.data;
    // ignore: unnecessary_this
    imageCopy.lastModified = this.lastModified;
    return imageCopy;
  }

  Uint8List get data => Uint8List.fromList(_data.toList());
  set data(Uint8List data) => _data = Uint8List.fromList(data.toList());
  Timestamp get lastModified => Timestamp.fromMicrosecondsSinceEpoch(
      _lastModified.microsecondsSinceEpoch);
  set lastModified(Timestamp time) => _lastModified =
      Timestamp.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);
}

/// Autocomplete results item returned from Google will be deserialized
/// into this model.
class AutoCompleteItem {
  String id;

  String text;

  int offset;
  int length;

  @override
  String toString() {
    return 'AutoCompleteItem{id: $id, text: $text, offset: $offset, length: $length}';
  }
}
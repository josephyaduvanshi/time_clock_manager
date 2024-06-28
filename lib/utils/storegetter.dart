extension StoreGetter on String {
  bool get isGreenway => this.toLowerCase() == "greenway";
  bool get isWeston => this.toLowerCase() == "weston";
}

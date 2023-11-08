/// Used to compare the tag type in label definitions
enum TagTypeEnum {
  markdown("Markdown"),
  markdownPriceAtLEast1000("MarkdownPriceAtLeast1000"),
  priceAdjust("PriceAdjust"),
  priceAdjustPriceAtLeast1000("PriceAdjustPriceAtLeast1000"),
  shoes("Shoes"),
  sticker("Sticker"),
  hangTag("HangTag"),
  transfers("Transfers"),
  smallSign("SmallSign"),
  largeSignHorizontal("LargeSignHorizontal"),
  recall("Recall"),
  markdownToZero("MarkdownToZero"),
  stickerPriceAtLeast1000("StickerPriceAtLeast1000"),
  largeSignVertical("LargeSignVertical"),
  hangTagPriceAtLeast1000("HangTagPriceAtLeast1000"),
  shoesPriceAtLeast1000("ShoesPriceAtLeast1000"),




  blank("Blank");

  final String rawValue;
  const TagTypeEnum(this.rawValue);
}

extension GetName on String {
  TagTypeEnum get getTagTypeEnumFromString {
    return switch (this) {
      "Markdown" => TagTypeEnum.markdown,
      "MarkdownPriceAtLeast1000" => TagTypeEnum.markdownPriceAtLEast1000,
      "PriceAdjust" => TagTypeEnum.priceAdjust,
      "PriceAdjustPriceAtLeast1000" => TagTypeEnum.priceAdjustPriceAtLeast1000,
      "Shoes" => TagTypeEnum.shoes,
      "Sticker" => TagTypeEnum.sticker,
      "HangTag" => TagTypeEnum.hangTag,
      "Transfers" => TagTypeEnum.transfers,
      "SmallSign" => TagTypeEnum.smallSign,
      "LargeSignHorizontal" => TagTypeEnum.largeSignHorizontal,
      "Recall" => TagTypeEnum.recall,
      "MarkdownToZero" => TagTypeEnum.markdownToZero,
      "StickerPriceAtLeast1000" => TagTypeEnum.stickerPriceAtLeast1000,
      "LargeSignVertical" => TagTypeEnum.largeSignVertical,
      "Blank" => TagTypeEnum.blank,
      _ => TagTypeEnum.blank
    };
  }
}

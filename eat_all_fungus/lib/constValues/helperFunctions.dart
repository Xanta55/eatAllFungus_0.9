int countAmountOfItems(List<String> input, String toCount) {
  return input.isNotEmpty
      ? input.where((element) => element == toCount).length
      : 0;
}

String reverseStringUsingSplit(String input) {
  var chars = input.split('');
  return chars.reversed.join();
}
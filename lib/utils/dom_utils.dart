import 'package:html/dom.dart';

List<Element> nextElementSiblingsWhile(
    Element element, bool test(Element element)) {
  final Element next = element.nextElementSibling;
  if (next != null && test(next)) {
    return [next] + nextElementSiblingsWhile(next, test);
  } else {
    return [];
  }
}

String classNameToString(List<Element> elements, String classNames) {
  return elements
      .expand((element) => element.getElementsByClassName(classNames))
      .map((element) => element.text.trim())
      .join('\n');
}

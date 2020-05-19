import 'dart:math';

final Random random = new Random();

T randomInstance<T>(Iterable<T> ts) {
  if (ts == null || ts.isEmpty) {
    return null;
  }
  return ts.elementAt(random.nextInt(ts.length));
}

import 'dart:math';

double toRadian(double degree) {
  return degree * ((2 * pi) / 360);
}

double toDegree(double radian) {
  return radian * (360 / (2 * pi));
}

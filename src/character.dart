library character;

import 'resource.dart';
import 'dart:math';

class Character
{
  int armor_bonus = 0;
  int max_dex_bonus = null;
  List<Feat> feats = [];
  Map<Ability, int> abilities = {};
  List<int> base_attack_bonus = [];
  Map<Class, int> classes = {};

  get level => classes.values.reduce(max);
}
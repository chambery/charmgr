library character;

import 'resource.dart';
import 'dart:math';

class Character
{
  int armor_bonus = 0;
  int max_dex_bonus = null;
  Map<Feat, List> _feats = {};
  Map<Ability, int> abilities = {};
  List<int> base_attack_bonus = [];
  Map<Class, int> classes = {};

  get feats => _feats.keys;

  get level => classes.values.reduce(max);

  addFeat(Feat feat) => _feats.putIfAbsent(feat, () => []);
  addFeatMulti(Feat feat, item)
  {
    addFeat(feat);
    _feats[feat].add(item);
  }
  
  removeFeat(Feat feat) => _feats.remove(feat);
}
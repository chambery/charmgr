library character;

import 'resource.dart';

class Character
{
  int armor_bonus = 0;
  int max_dex_bonus = null;
  List<Feat> feats;
  Map<Ability, int> abilities = {};
  List<int> base_attack_bonus;
}
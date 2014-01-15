library common;

import 'resource.dart';
import 'dart:math';

int calc_armor_acp(List<Armor> char_armors)
{
    int acp = 0;
    for (var armor in char_armors)
    {
//        armor = armors({
//            name: char_armors[i].armor_name
//        }).first();
        acp += armor.acp;
    }
    return acp;
}


int calc_armor_bonus(List<Armor> char_armor)
{
    int armor_bonus = 0;
    for (var armor in char_armor)
    {
      armor_bonus += armor.bonus;
    }

    return armor_bonus;
}

int calc_max_dex_bonus(List<Armor> char_armor)
{
    int max_dex_bonus = null;
    for (var armor in char_armor)
    {
      if(armor.max_dex_bonus != null)
      {
        max_dex_bonus = max_dex_bonus == null ? armor.max_dex_bonus : min(max_dex_bonus, armor.max_dex_bonus);

      }
    }

    return max_dex_bonus;
}


int calc_ranks(int char_skill_points, skill, classes) {
    bool class_skill = is_class_skill(skill, classes);
    double multiplier = (class_skill ? 1.0 : .5);             
    return (multiplier * char_skill_points).round();
}

bool is_class_skill(Skill skill, List<Class> classes) {
    for (Class clazz in classes) {
        if (skill.classes.contains(clazz)) {
          return true;
        }
    }
    return false;
}

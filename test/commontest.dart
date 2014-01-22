library commontest;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import '../src/resource.dart';
import '../src/ability.dart';
import '../src/common.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';
import 'dart:async';


void main() {
  useVMConfiguration();

  test('calc_armor_acp', () {
    Armor armor1 = new Armor("helmet", 1, -1, "light");
    Armor armor2 = new Armor("breastplate", 4, -2, "light");
    expect(calc_armor_acp([armor1, armor2]), equals(-3));

  });

  test('calc_armor_bonus', () {
    Armor armor1 = new Mail("helmet", 1, -1, "light");
    Armor armor2 = new Shield("breastplate", 4, -2, "light");
    expect(calc_armor_bonus([armor1, armor2]), equals(5));

  });

  test('calc_max_dex_bonus', () {
    Armor armor1 = new Mail("helmet", 1, -1, "light");
    Armor armor2 = new Shield("breastplate", 4, -2, "light");
    expect(calc_max_dex_bonus([armor1, armor2]), equals(null));
    armor2.max_dex_bonus = 3;
    expect(calc_max_dex_bonus([armor1, armor2]), equals(3));
    armor1.max_dex_bonus = 1;
    expect(calc_max_dex_bonus([armor1, armor2]), equals(1));
    armor1.max_dex_bonus = 4;
    expect(calc_max_dex_bonus([armor1, armor2]), equals(3));

  });

  test('calc_max_dex_bonus', () {
    Armor armor1 = new Mail("helmet", 1, -1, "light");
    Armor armor2 = new Shield("breastplate", 4, -2, "light");
    expect(calc_max_dex_bonus([armor1, armor2]), equals(null));
    armor2.max_dex_bonus = 3;
    expect(calc_max_dex_bonus([armor1, armor2]), equals(3));
    armor1.max_dex_bonus = 1;
    expect(calc_max_dex_bonus([armor1, armor2]), equals(1));
    armor1.max_dex_bonus = 4;
    expect(calc_max_dex_bonus([armor1, armor2]), equals(3));

  });

  test('is_class_skill', () {
    Skill knowledge = new Skill("Knowledge", null, Ability.INTELLIGENCE);
    new Class("Sorcerer", "Src");
    new Class("Fighter", "Ftr");
    Skill knowledge_arcana = new Skill("Arcana", [Class.get("Sorcerer")], knowledge.ability);
    expect(is_class_skill(knowledge, [Class.get("Sorcerer")]), isFalse);
    expect(is_class_skill(knowledge_arcana, [Class.get("Sorcerer"), Class.get("Fighter")]), isTrue);
    expect(is_class_skill(knowledge_arcana, [Class.get("Fighter")]), isFalse);
  });

  test('calc_ranks', () {
    Skill knowledge = new Skill("Knowledge", null, Ability.INTELLIGENCE);
    expect(knowledge.classes, isNotNull);
    expect(knowledge.classes.length, equals(0));
    new Class("Sorcerer", "Src");
    new Class("Fighter", "Ftr");
    Skill knowledge_arcana = new Skill("Arcana", [Class.get("Sorcerer")], knowledge.ability);
    knowledge.subtypes.add(knowledge_arcana);
    expect(calc_ranks(4, Skill.get("Arcana"), [Class.get("Sorcerer")]), equals(4));
    expect(calc_ranks(4, Skill.get("Arcana"), [Class.get("Fighter")]), equals(2));
  });

  test('load_skills', () {
    var file = new File('../src/resources/skills.yaml');
    String skills = file.readAsStringSync();
    print(skills);
    print(loadYaml(skills));
  });

}


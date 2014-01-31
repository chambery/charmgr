library resourcetest;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';
import '../src/resource.dart';
import '../src/character.dart';
import '../src/common.dart';
import '../src/store.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';
import 'dart:async';
import 'package:yaml/yaml.dart';
import 'dart:mirrors';

MirrorSystem mirrors = currentMirrorSystem();
LibraryMirror lm = mirrors.findLibrary(new Symbol('resource'));

void main() {
  useVMConfiguration();

//  test('constructor', () {
//
//    Skill skill = new Skill.map({
//                                  'name': 'foo',
//                                  'description': 'bar',
//                                  'baz' : 'qux',
//                                  'ability' : 'Strength',
//                                  'subtypes' : [
//                                                  { 'name' : 'foosub1',
//                                                    'description' : 'foosub1',
//                                                    'classes' : [Class.get('Fighter'), Class.get('Sorcerer')]
//                                                  }
//                                               ]
//                                });
//    expect(skill, isNotNull);
//    expect(skill.name, 'foo');
//    Skill foo = Skill.get('foo');
//    print('${foo}');
//    expect(foo, isNotNull);
//    expect(foo.description, 'bar');
//    expect(foo.subtypes.keys.length, 1);
//    expect(foo.subtypes['foosub1'], isNotNull);
//    expect(foo.subtypes['foosub1'].name, 'foosub1');
//    var foosub1 = Skill.get('foosub1');
//    expect(foosub1.parent, foo);
//
//    expect(foo.ability, Ability.STRENGTH);
//  });
//
//
//  test('feat prereqs', () {
//    load();
//    Feat deadlyStroke = Feat.get('Deadly Stroke');
//    Character char = new Character();
//    char.abilities =
//    {
//        Ability.STRENGTH : 12,
//        Ability.INTELLIGENCE : 12,
//        Ability.DEXTERITY : 12,
//        Ability.CONSTITUTION : 12,
//        Ability.WISDOM : 12,
//        Ability.CHARISMA : 12
//    };
//    char.base_attack_bonus = [11, 4];
//    char.feats =
//    [
//        Feat.get('Dazzling Display'),
//        Feat.get('Greater Weapon Focus'),
//        Feat.get('Shatter Defenses')
//    ];
//
//    expect(deadlyStroke.meetsPrereqs(char), isTrue);
//    char.removeFeat(Feat.get('Greater Weapon Focus'));
//    expect(deadlyStroke.meetsPrereqs(char), isFalse);
//    char.feats.add(Feat.get('Greater Weapon Focus'));
//    char.base_attack_bonus = [10, 5];
//    expect(deadlyStroke.meetsPrereqs(char), isFalse);
//
//  });
//
//  test('prereqs - mult, no OR', () {
//    load();
//    var data = loadYaml('''
//abilities:
//  Dex: 15
//feats:
//  - Deflect Arrows
//''');

//    for(var prereq in data.keys)
//    {
//      print('${prereq} > ${Feat.mappings[prereq]}');
//      ClassMirror cm = lm.declarations[Feat.mappings[prereq]];
//
//      InstanceMirror im = cm.newInstance(const Symbol(''), [prereq, data[prereq], lm.declarations[translations[prereq]]]);
//      Prereq p = im.reflectee;
//      expect(p.or, isFalse);
//    }
//  });
//
//  test('prereqs - 1 type with OR', () {
//    MirrorSystem mirrors = currentMirrorSystem();
//    LibraryMirror lm = mirrors.findLibrary(new Symbol('resource'));
//
//    var data = loadYaml('''
//abilities:
//  or:
//    Dex: 15
//    Int: 20
//''');
//      ClassMirror cm = lm.declarations[Feat.mappings['abilities']];
//      InstanceMirror im = cm.newInstance(const Symbol(''), ['abilities', data['abilities'], lm.declarations[translations['abilities']]]);
//      Prereq p = im.reflectee;
//      expect(p.or, isTrue);
//      expect(p.prereqs[Ability.get('Dex')], 15);
//      expect(p.prereqs[Ability.get('Str')], isNull);
//  });
//
//  test('prereqs - mult with or', () {
//    load();
//    MirrorSystem mirrors = currentMirrorSystem();
//    LibraryMirror lm = mirrors.findLibrary(new Symbol('resource'));
//    var data = loadYaml('''
//skills:
//  or:
//    Craft: 5
//    Profession: 3
//abilities:
//  or:
//    Dex: 15
//feats:
//  - "Gorgon's Fist"
//''');
//    var prereq = 'skills';
//    print('${prereq} > ${Feat.mappings[prereq]}');
//    ClassMirror cm = lm.declarations[Feat.mappings[prereq]];
//    InstanceMirror im = cm.newInstance(const Symbol(''), [prereq, data[prereq], lm.declarations[translations[prereq]]]);
//    Prereq p = im.reflectee;
//    expect(p.or, isTrue);
//    expect(p.prereqs[Skill.get('Craft')], 5);
//    expect(p.prereqs[Skill.get('Profession')], 3);
//
//    prereq = 'abilities';
//    print('${prereq} > ${Feat.mappings[prereq]}');
//    cm = lm.declarations[Feat.mappings[prereq]];
//    im = cm.newInstance(const Symbol(''), [prereq, data[prereq], lm.declarations[translations[prereq]]]);
//    p = im.reflectee;
//    expect(p.or, isTrue);
//    expect(p.prereqs[Ability.get('Dex')], 15);
//
//    prereq = 'feats';
//    print('${prereq} > ${Feat.mappings[prereq]}');
//    cm = lm.declarations[Feat.mappings[prereq]];
//    im = cm.newInstance(const Symbol(''), [prereq, data[prereq], lm.declarations[translations[prereq]]]);
//    p = im.reflectee;
//    expect(p.or, isFalse);
//    expect(p.prereqs.contains(Feat.get("Gorgon's Fist")), isTrue);
//
//  });
//
//  test('feats - test meets prereq', () {
//    load();
//    Character char = new Character();
//    char.abilities =
//    {
//        Ability.STRENGTH : 12,
//        Ability.INTELLIGENCE : 12,
//        Ability.DEXTERITY : 12,
//        Ability.CONSTITUTION : 12,
//        Ability.WISDOM : 12,
//        Ability.CHARISMA : 12
//    };
//    char.base_attack_bonus = [11, 4];
//    char.feats =
//    [
//        Feat.get('Weapon Focus')
//    ];
//    char.classes[Class.get('Fighter')] = 12;
//    Feat penetratingStrike = Feat.get('Penetrating Strike');
//
//    expect(penetratingStrike.meetsPrereqs(char), isTrue);
//    char.classes[Class.get('Fighter')] = 11;
//    print('\tchar classes: ${char.classes}');
//    expect(penetratingStrike.meetsPrereqs(char), isFalse);
//    char.classes[Class.get('Fighter')] = 12;
//    char.removeFeat(Feat.get('Weapon Focus'));
//    expect(penetratingStrike.meetsPrereqs(char), isFalse);
//
//    Feat shotOnTheRun = Feat.get('Shot on the Run');
//    expect(shotOnTheRun.meetsPrereqs(char), isFalse);
//    char.feats.add(Feat.get('Point-Blank Shot'));
//    expect(shotOnTheRun.meetsPrereqs(char), isFalse);
//    char.feats.add(Feat.get('Mobility'));
//    expect(shotOnTheRun.meetsPrereqs(char), isFalse);
//    char.base_attack_bonus = [3];
//    expect(shotOnTheRun.meetsPrereqs(char), isFalse);
//    char.base_attack_bonus = [4];
//    expect(shotOnTheRun.meetsPrereqs(char), isFalse);
//    char.abilities[Ability.DEXTERITY] = 15;
//    expect(shotOnTheRun.meetsPrereqs(char), isTrue);
//
//  });

  test('Pick prereq', () {
    load();
    Feat criticalMastery = Feat.get('Critical Mastery');
    Character char = new Character();

    char.addFeat(Feat.get('Critical Focus'));
    char.addFeat(Feat.get('Exhausting Critical'));
    char.addFeat(Feat.get('Sickening Critical'));

    char.classes[Class.get('Fighter')] = 14;

    expect(criticalMastery.meetsPrereqs(char), isTrue);
    char.classes[Class.get('Fighter')] = 13;
    expect(criticalMastery.meetsPrereqs(char), isFalse);
    char.classes[Class.get('Fighter')] = 14;
    char.removeFeat(Feat.get('Sickening Critical'));
    expect(criticalMastery.meetsPrereqs(char), isFalse);


  });

  test('feat multi', () {
    load();
    Feat weaponFocus = Feat.get('Greater Weapon Focus');
    Character char = new Character();
    char.addFeat(Feat.get('Simple Weapon Proficiency'));


//    for(Feat feat in weaponFocus.multi['feats'])
//    {
//      /* is a list, eg. feats: - Simple Weapon Proficiency, - Martial... */
//      var type = lm.declarations[translations[typename]];
//       getRelatedData(feat);
//      weaponFocus.multi[typename].intersection(char.feats);
//      weaponFocus.multi.intersection();
//    }
//
//
//    char.addFeat(Feat.get('Exotic Weapon Proficiency'));
//    printRelatedData(weaponFocus, char);
//    char.removeFeat(Feat.get('Simple Weapon Proficiency'));
//    printRelatedData(weaponFocus, char);
  });
}

printRelatedData(feat, char)
{
  for(var typename in feat.multi.keys)
  {
    /* is a list, eg. feats: - Simple Weapon Proficiency, - Martial... */
    var type = lm.declarations[translations[typename]];
//    feat.multi[typename].intersection()
  }
}

getRelatedData(Feat feat)
{
  print('${feat.name} : ${feat.related_data != null ? feat.related_data.data : 'NO RELATED DATA'}');
  if(feat.multi['feats'] != null)
  {
    for(var multi in feat.multi['feats'])
    {
      print('${multi}');
      getRelatedData(multi);
    }
  }
}
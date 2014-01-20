library storetest;

import '../src/store.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';
import '../src/resource.dart';
import '../src/ability.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

void main()
{
  useVMConfiguration();
  
  test('load', () {
    load();
    Skill skill = Skill.get('Acrobatics');
    expect(skill, isNotNull);
    expect(skill.classes.contains(Class.get('Barbarian')), isTrue);
    skill = Skill.get('Knowledge');
    expect(skill.subtypes['Planes'].classes.contains('Barbarian'), isFalse);
    skill = Skill.get('Planes');
    expect(skill.classes.contains('Barbarian'), isFalse);
    expect(Class.get('Cleric').spells[Spell.get('Chaos Hammer').classes[Class.get('Cleric')]].contains(Spell.get('Chaos Hammer')), isTrue);
    expect(Domain.get('Chaos').spells.contains(Spell.get('Magic Circle against Law')), isTrue);
    expect(Domain.get('Chaos').deities.contains(Deity.get('Lamashtu')), isTrue);
    expect(Domain.get('Chaos').deities.contains(Deity.get('Abadar')), isFalse);
    
    print('Wind Stance contains Dodge');
    expect(Feat.get('Wind Stance').prereqs['feats'].contains(Feat.get('Dodge')), isTrue);
    print('Staggering Critical contains Critical Focus');
    expect(Feat.get('Staggering Critical').prereqs['feats'].contains(Feat.get('Critical Focus')), isTrue);
    print('Snatch Arrows contains Deflect Arrows');
    expect(Feat.get('Snatch Arrows').prereqs['feats'].contains(Feat.get('Deflect Arrows')), isTrue);
    print('Whirlwind Attack contains Combat Expertise');
    expect(Feat.get('Whirlwind Attack').prereqs['feats'].contains(Feat.get('Combat Expertise')), isTrue);
    print('Improved Grapple contains Improved Unarmed Strike');    
    expect(Feat.get('Improved Grapple').prereqs['feats'].contains(Feat.get('Improved Unarmed Strike')), isTrue);
    print('Deflect Arrows requires Dex : 13');    
    expect(Feat.get('Deflect Arrows').prereqs['abilities'][Ability.DEXTERITY], 13);
    print('${Feat.get('Deflect Arrows').prereqs['feats'].runtimeType}');
    print('Deflect Arrows contains Improved Unarmed Strike');        
    print('${Feat.get('Deflect Arrows').prereqs['feats'].contains(Feat.get('Improved Unarmed Strike'))} :: ${Feat.get('Deflect Arrows').prereqs['feats'][0].hashCode} <> ${Feat.get('Improved Unarmed Strike').hashCode} ${Feat.get('Improved Unarmed Strike')}');
    expect(Feat.get('Deflect Arrows').prereqs['feats'].contains(Feat.get('Improved Unarmed Strike')), isTrue);

  });
}
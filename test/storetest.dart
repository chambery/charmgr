library storetest;

import '../src/store.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';
import '../src/resource.dart';

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

void main()
{
  useVMConfiguration();
  
  test('load', () {
    load();
    Skill skill = Skill.get('Acrobatics');
    expect(skill, isNotNull);
    print('${skill.classes}');
    expect(skill.classes.contains(Class.get('Barbarian')), isTrue);
    skill = Skill.get('Knowledge');
    expect(skill.subtypes['Planes'].classes.contains('Barbarian'), isFalse);
    skill = Skill.get('Planes');
    expect(skill.classes.contains('Barbarian'), isFalse);

  });
}
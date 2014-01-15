library resourcetest;

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

  test('constructor', () {
    
    Skill skill = new Skill.map({
                                  'name': 'foo', 
                                  'description': 'bar',
                                  'baz' : 'qux',
                                  'ability' : 'Strength',
                                  'subtypes' : [
                                                  { 'name' : 'foosub1', 
                                                    'description' : 'foosub1',
                                                    'classes' : [Class.get('Fighter'), Class.get('Sorcerer')]
                                                  }
                                               ]                                               
                                });
    expect(skill, isNotNull);
    expect(skill.name, 'foo');
    Skill foo = Skill.get('foo');
    print('${foo}');
    expect(foo, isNotNull);
    expect(foo.description, 'bar');
    expect(foo.subtypes.keys.length, 1);
    expect(foo.subtypes['foosub1'], isNotNull);
    expect(foo.subtypes['foosub1'].name, 'foosub1');
    var foosub1 = Skill.get('foosub1');
    expect(foosub1.parent, foo);
    
    expect(foo.ability, Ability.STRENGTH);
  });
}
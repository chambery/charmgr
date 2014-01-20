library store;

import 'package:darmatch/io_matchers.dart';
import 'package:darmatch/matchers.dart';
import 'package:darmatch/preconditions.dart';
import 'resource.dart';
import 'dart:mirrors';
import 'dart:io';
import 'package:yaml/yaml.dart';

Map load()
{
  var file = new File('../src/resources/classes.yaml');
  List classes = loadYaml(file.readAsStringSync());
  for(var clazz in classes)
  {
    new Class.map(clazz);
  }

  print('loading skills.yaml');
  file = new File('../src/resources/skills.yaml');
  List skills = loadYaml(file.readAsStringSync());
  for(var skill in skills)
  {
    new Skill.map(skill);
  }

  print('loading mail.yaml');
  file = new File('../src/resources/mail.yaml');
  List mails = loadYaml(file.readAsStringSync());
  for(var mail in mails)
  {
    new Mail.map(mail);
  }

  print('loading shields.yaml');
  file = new File('../src/resources/shields.yaml');
  List shields = loadYaml(file.readAsStringSync());
  for(var shield in shields)
  {
    new Shield.map(shield);
  }

  print('loading weapons.yaml');
  file = new File('../src/resources/weapons.yaml');
  List weapons = loadYaml(file.readAsStringSync());
  for(var weapon in weapons)
  {
    new Weapon.map(weapon);
  }

  print('loading deities.yaml');
  file = new File('../src/resources/deities.yaml');
  List deities = loadYaml(file.readAsStringSync());
  for(var deity in deities)
  {
    new Deity.map(deity);
  }

  print('loading spells.yaml');
  file = new File('../src/resources/spells.yaml');
  List spells = loadYaml(file.readAsStringSync());
  for(var spell in spells)
  {
    new Spell.map(spell);
  }
  
  Map clazzes = Class.get();
  Map spellss = Spell.get();
  for(Class clazz in clazzes.values)
  {
    for(Spell spell in spellss.values)
    {
      int class_level = spell.classes[clazz];
      if(class_level != null)
      {
        clazz.spells[class_level].add(spell);
        print('\tadding ${spell} to ${clazz} at level ${class_level + 1}');
      }
    }
  }

  print('loading domains.yaml');
  file = new File('../src/resources/domains.yaml');
  List domains = loadYaml(file.readAsStringSync());
  for(var domain in domains)
  {
	  new Domain.map(domain);
  }

  print('loading feats.yaml');
  file = new File('../src/resources/feats.yaml');
  List feats = loadYaml(file.readAsStringSync());
  /* have to create the feats so we can ref them from the prereqs */
  for(var feat in feats)
  {
    Feat f = new Feat(feat['name'], feat['description']);
	  Feat.put(f);
  }

  for(var feat in feats)
  {
	  new Feat.map(feat);
  }
}
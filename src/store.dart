library store;

import 'package:darmatch/io_matchers.dart';
import 'package:darmatch/matchers.dart';
import 'package:darmatch/preconditions.dart';
import 'armor.dart';
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

  file = new File('../src/resources/skills.yaml');
  List skills = loadYaml(file.readAsStringSync());
  for(var skill in skills)
  {
    new Skill.map(skill);
  }

  file = new File('../src/resources/mail.yaml');
  List mails = loadYaml(file.readAsStringSync());
  for(var mail in mails)
  {
    new Mail.map(mail);
  }
  file = new File('../src/resources/shields.yaml');
  List shields = loadYaml(file.readAsStringSync());
  for(var shield in shields)
  {
    new Shield.map(shield);
  }

}
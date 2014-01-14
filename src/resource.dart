library resource;

import 'ability.dart';
import 'dart:mirrors';

abstract class Resource {
  String name;
  String description;
  Resource(this.name, this.description);
  
  Resource.map(Map data)
  {
    print('\tcreating skill for ${data['name']}');
    ObjectMirror o = reflect(this);
    ClassMirror c = reflectClass(runtimeType);
    while(c != null && c.runtimeType != 'Object')
    {
      for (var k in c.declarations.keys) {
        print('\t${k}');
        if(data[MirrorSystem.getName(k)] != null)
        {
          print('\t\tsetting ${k} : ${data[MirrorSystem.getName(k)]}');
          o.setField(k, data[MirrorSystem.getName(k)]);        
        }
      }
      if(c != null)
      {
        c = c.superclass;
      }
      print('${c}');
    }
    print('resource db ${this._getDb()}');
    this._getDb()[name] = this;
    print('end constructor');
  }
  
  Map _getDb();

  toString()
  {
    return name;
  }

}

class Skill extends Resource
{
  /* skill 'database' */
  static Map<String, Skill> _skills = {};

  List<Class> _classes = [];
  bool untrained;
  String detail; 
  Map<String, Skill> _subtypes = {};
  Skill parent;
  Ability _ability;
  
  Skill(name, description, this.classes, ability) : super(name, description)
  {
    this.ability = ability; 
    if(classes == null)
    {
      _classes = [];
    }
    _skills[name] = this;
  }
  
  Skill.map(Map data) : super.map(data);

  get classes => _classes;

  set classes(List classes)
  {
    for(var clz in classes)
    {
      if(clz is String)
      {
        var clazz = Class.get(clz);
        if(clazz != null)
        {
          _classes.add(clazz);
        }

      }
      if(clz is Class)
      {
        _classes.add(clz);
      }
    }
  }

  get subtypes => _subtypes;
  
  set subtypes(List subskills)
  {
    print('processing subskills');
    for(Map subSkillData in subskills)
    {
      print('\t\t${subSkillData}');
      Skill subskill = new Skill.map(subSkillData);
      subskill.parent = this;
      _subtypes[subskill.name] = subskill;
      _skills[subskill.name] = subskill;
    }
    print('done processing subskills');
  }
  get ability => _ability;
  set ability(name) 
  {
    _ability = Ability.get(name); 
  }
  
  static Skill get(name)
  {
    return _skills[name];
  }
  
  Map _getDb()
  {
    return _skills;
  }
}

class Class extends Resource
{
  static Map<String, Class> _classes = {};
  String shortname;
  
  List base_attack_bonus = [];
  List spells = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []];
  List feats = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []];
  List specials = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []];
  List fort_save = [];
  List ref_save = []; 
  List will_save = [];
  List spells_per_day = [];
  int skill_points_per_level;
  List bonus_feats_levels = [];
  int hit_dice;
  
  Class(name, this.shortname, description) : super(name, description) 
  {
    _classes[name] = this;
  }
  
  Class.map(map) : super.map(map);
  
  static Class get(name)
  {
    return _classes[name];
  }
  
  Map _getDb()
  {
   return  _classes;
  }

}

class Armor extends Resource
{
  int acp;
  int bonus;
  String category;

  String cost;
  int max_dex_bonus = null;
  int spell_fail_pct;
  int speed30;
  int speed20;
  int weight;

  Armor(name, description, this.bonus, this.acp, this.category) : super(name, description);

  Armor.map(map) : super.map(map);
}

class Mail extends Armor
{
  Mail(name, description, bonus, acp, category) : super(name, description, bonus, acp, category);

  Mail.map(map) : super.map(map);
}

class Shield extends Armor
{
  Shield(name, description, bonus, acp, category) : super(name, description, bonus, acp, category);

  Shield.map(map) : super.map(map);
}


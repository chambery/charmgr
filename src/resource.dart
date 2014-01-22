library resource;

import 'ability.dart';
import 'alignment.dart';
import 'dart:mirrors';

class RelatedData
{
  ClassMirror type;
  var filter = {};

  RelatedData(map)
  {
    MirrorSystem mirrors = currentMirrorSystem();
    LibraryMirror lm = mirrors.findLibrary(new Symbol('resource'));
    type = lm.declarations[new Symbol(map['type'])];
    print('\t\trelated_data: ${this.type.reflectedType}');

//    for(var key in map['filter'].keys)
//    {
      // TODO - create a filter mechanism to use reflection to pick instances from the global hash whose fields match criteria
      /* Weapon.category == 'martial' */
      filter = map['filter'];
//      filter[type.getField(new Symbol(key))] = map['filter'][key];
//    }
  }


}

abstract class Resource
{
  String name;
  String description;
  Resource(this.name, this.description);

  Resource.map(Map data)
  {
    ObjectMirror o;

    if(this._getDb()[data['name']] != null)
    {
      o = reflect(this._getDb()[data['name']]);
    }
    else
    {
      o = reflect(this);
    }

    ClassMirror c = reflectClass(runtimeType);
    while(c != null && c.simpleName != #Object)
    {
//      print('${c}');
      for (var k in c.declarations.keys) {
        if(data[MirrorSystem.getName(k)] != null)
        {
//          print('\t\tsetting ${k} : ${data[MirrorSystem.getName(k)]}');
          o.setField(k, data[MirrorSystem.getName(k)]);
        }
      }
      if(c != null)
      {
        c = c.superclass;
      }
    }
//    print('${this.runtimeType} db ${this._getDb()}');
    if(this._getDb()[data['name']] == null)
    {
      this._getDb()[name] = this;
    }

    print('\t${this._getDb()[data['name']].name} - end constructor');
  }

  Map _getDb();

  toString()
  {
    return '${name} {${runtimeType}}';
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

  Skill(name, description, classes, ability) : super(name, description)
  {
    this.ability = ability;
    if(classes != null)
    {
      _classes = classes;
    }
    _skills[name] = this;
  }

  Skill.map(Map data) : super.map(data);

  get classes => _classes;

  set classes(List classes)
  {
    for(var clz in classes)
    {
      _classes.add(Class.get(clz));
    }
  }

  get subtypes => _subtypes;

  set subtypes(List subskills)
  {
//    print('processing subskills');
    for(Map subSkillData in subskills)
    {
      print('\t\t${subSkillData}');
      Skill subskill = new Skill.map(subSkillData);
      subskill.parent = this;
      _subtypes[subskill.name] = subskill;
      _skills[subskill.name] = subskill;
    }
//    print('done processing subskills');
  }
  get ability => _ability;
  set ability(name)
  {
    _ability = Ability.get(name);
  }

  static Skill get([name, filter])
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

  static get([name])
  {
    if(name == null)
    {
      return _classes;
    }

    return _classes[name];
  }

  Map _getDb()
  {
   return  _classes;
  }

}

class Armor extends Resource
{
  static Map<String, Armor> _armor = {};
  var acp;
  var bonus;
  String category;

  String cost;
  var max_dex_bonus;
  var spell_fail;
  var speed30;
  var speed20;
  int weight;

  Armor(name, description, this.bonus, this.acp, this.category) : super(name, description);

  Armor.map(map) : super.map(map);

  static get([name, filter])
  {
    if(name != null)
    {
      if(filter == null) filter = {};
      filter['name'] = name;
    }

    if(filter != null)
    {
      var result = [];
      for(var armor in _armor.values)
      {
        bool match = true;
        ObjectMirror m = reflect(armor);
        ClassMirror c = reflectClass(armor.runtimeType);
        // TODO - factor this mess out
        for(var field in filter.keys)
        {
          var fieldSym = new Symbol(field);
          if(m.getField(fieldSym) != null && m.getField(fieldSym).reflectee != filter[field])
          {
            match = false;
            break;
          }
        }
        if(match)
        {
          result.add(armor);
        }
      }

//      print('${result}');
      return name != null ? result[0] : result;
    }

    return _armor;
  }

  _getDb()
  {
    return _armor;
  }
}

class Mail extends Armor
{
  Mail(name, description, bonus, acp, category) : super(name, description, bonus, acp, category);

  Mail.map(map) : super.map(map);

  static Mail get(name)
  {
    return Mail._getDb()[name];
  }

  /* static members not inherited */
  _getDb()
  {
    return super._getDb();
  }
}

class Shield extends Armor
{
  Shield(name, description, bonus, acp, category) : super(name, description, bonus, acp, category);

  Shield.map(map) : super.map(map);

  static Shield get(name)
  {
    return Shield._getDb()[name];
  }

  /* static members not inherited */
  _getDb()
  {
    return super._getDb();
  }

}

class Weapon extends Resource
{
  static Map<String, Weapon> _weapons = {};
  String category;
  String usage;
  String damage;
  String critical;
  String range;
  var weight;
  List<String> damageType;
  String type;

  Weapon.map(map) : super.map(map);


  static Weapon get(name)
  {
    return _weapons[name];
  }

  _getDb()
  {
    return _weapons;
  }
}

class Deity extends Resource
{
  static Map<String, Deity> _deities = {};
  Alignment _alignment;
  Goodness _goodness;
  var portfolio = [];
  var domains = [];
  Weapon _weapon;

  Deity.map(map) : super.map(map);

  static Deity get(name)
  {
    return _deities[name];
  }

  get goodness => _goodness;

  set goodness(goodness)
  {
    _goodness = Goodness.get(goodness);
  }

  get alignment => _alignment;

  set alignment(alignment)
  {
    _alignment = Alignment.get(alignment);
  }

  get weapon => _weapon;

  set weapon(weapon)
  {
    _weapon = Weapon.get(weapon);
  }

  _getDb()
  {
    return _deities;
  }
}

class Domain extends Resource
{
  static Map<String, Domain> _domains = {};
  List<Deity> _deities = [];
  List<Spell> _spells = [];

  Domain.map(map) : super.map(map);

  static get([name])
  {
    if(name == null)
    {
      return _domains;
    }

    return _domains[name];
  }

  get spells => _spells;

  set spells (spells)
  {
    for(var spell in spells)
    {
      _spells.add(Spell.get(spell));
    }

  }

  get deities => _deities;

  set deities(deities)
  {
      for(var deity in deities)
      {
        _deities.add(Deity.get(deity));
      }
  }

  _getDb()
  {
    return _domains;
  }
}

class Spell extends Resource
{
  static Map<String, Spell> _spells = {};
  String summary;
  String school;
  String composition;
  String time;
  String range;
  String effect;
  String duration;
  String save;
  var sr;
  Map<Class, int> _classes = {};
  int phb;

  Spell.map(map) : super.map(map);

  static get([spell])
  {
    if(spell == null)
    {
      return _spells;
    }

    return _spells[spell];
  }

  get classes => _classes;

  set classes(Map classes)
  {
    for(var clazz in classes.keys)
    {
      _classes[Class.get(clazz)] = classes[clazz];
//      print('\t\t\tmapping ${Class.get(clazz)} :: ${classes[clazz]}');
    }
  }

  _getDb()
  {
    return _spells;
  }

}


class ClassFeature
{

}

class Feat extends Resource
{
  static Map<String, Feat> _feats = {};
  String cmb;
  Set<String> groups;
  Map<Skill, Map> _skills = {};
  Map _prereqs = {};
  String summary;
  var mobility;
  bool conditional;
  Map<Class, int> _classes = {};
  RelatedData _relatedData;
  Set<Goodness> _goodness;
  bool spell_related = false;

  Feat.map(map) : super.map(map);

  Feat(name, description) : super(name, description);

  static put([feat])
  {
    if(feat is Map<String, Feat>)
    {
      _feats = feat;
    }
    else if(feat is Feat)
    {
      _feats[feat.name] = feat;
    }

    return _feats[feat];
  }

  static get([feat])
  {
    if(feat == null)
    {
      return _feats;
    }

    return _feats[feat];
  }

  get classes => _classes;
  set classes(Map classes)
  {
    for(var clazz in classes.keys)
    {
      _classes[Class.get(clazz)] = classes[clazz];
//      print('\t\t\tmapping ${Class.get(clazz)} :: ${classes[clazz]}');
    }
  }

  get skills => _skills;
  set skills(Map skills)
  {
    for(var skill in skills.keys)
    {
      _skills[Skill.get(skill)] = skills[skill];
    }
  }

  get related_data => _relatedData;
  set related_data(map)
  {
    print('\t\trelated_data: ${map}');
    _relatedData = new RelatedData(map);

  }

  get prereqs => _prereqs;
  set prereqs(Map prereqs)
  {
    for(var prereq in prereqs.keys)
    {

      if(prereq == 'feats')
      {
        _prereqs['feats'] = [];
        /* feats : - Improved Overrun */
        for(var feat in prereqs['feats'])
        {
          _prereqs['feats'].add(Feat.get(feat));
        }
      }

      else if(prereq == 'abilities')
      {
        _prereqs['abilities'] = {};
        /* abilities:  Dex:  13 */
        for(var ability in prereqs['abilities'].keys)
        {
          _prereqs['abilities'][Ability.get(ability)] = prereqs['abilities'][ability];
        }
      }

      else if(prereq == 'level')
      {
        _prereqs['level'] = prereqs['level'];
      }

      else if(prereq == 'base_attack_bonus')
      {
        _prereqs['base_attack_bonus'] = prereqs['base_attack_bonus'];
      }

      else if(prereq == 'multi')
      {
        _prereqs['multi'] = [];
        for(var multi in prereqs['multi'])
        {
	        _prereqs['multi'].add(prereqs['multi']);
        }
      }

      else if(prereq == 'class_features')
      {
        _prereqs['class_features'] = [];
        for(var feature in prereqs[prereq])
        {
          // TODO - add features to the class
          _prereqs['class_features'].add(feature);
        }
      }
    }
  }

  get goodness => _goodness;
  set goodness(goodnesses)
  {
    for(var goodness in goodnesses)
    {
      _goodness.add(Goodness.get(goodness));
    }
  }

  _getDb()
  {
    return _feats;
  }

}
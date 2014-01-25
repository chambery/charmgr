part of resource;

class Feat extends Resource
{
  static final Symbol MapPrereq = new Symbol('MapPrereq');
  static final Symbol ListPrereq = new Symbol('ListPrereq');
  static final Symbol SimplePrereq = new Symbol('SimplePrereq');
  static Map<String, Symbol> mappings = {
      'skills' : Feat.MapPrereq,
//      'classes' : Feat.MapPrereq,
      'abilities' : Feat.MapPrereq,
      'feats' : Feat.ListPrereq
//      'class_features' : Feat.ListPrereq,
//      'base_attack_bonus' : Feat.SymbolPrereq,
//      'level' : Feat.SymbolPrereq
  };

  static Map<String, Feat> _feats = {};

  String cmb;
  List<String> groups;
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

  bool meetsPrereqs(Character char)
  {
    bool meets = true;
    for(String prereq in prereqs.keys)
    {
      if(prereq.startsWith('abilities'))
      {
        for(var ability in prereqs['abilities'])
        {
          if(char.abilities[ability] < prereqs['abilities'])
          {
            return false;
          }
        }
      }

      else if(prereq.startsWith('feats'))
      {
        var key = 'feats';
        if(prereq.endsWith(':or')) {
          key = 'feats:or';
        }
        for(var feat in prereqs[key])
        {
          if(key.endsWith(':or'))
          {
            if(char.feats.contains(feat))
            {
              break;
            }
          }
          if(!char.feats.contains(feat))
          {
            return false;
          }
        }
      }
      else if(prereq == 'base_attack_bonus')
      {
        if(char.base_attack_bonus[0] < prereqs['base_attack_bonus'])
        {
          return false;
        }
      }

//      ObjectMirror m = reflect(char);
//      m.getField(new Symbol(prereq)).reflectee;

    }
    return true;
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
    print('prereqs for: ${name}');
    for(var prereq in prereqs.keys)
    {
//      if(prereq == 'feats')
//      {
//        _prereqs['feats'] = [];
//        /* feats : - Improved Overrun */
//        for(var feat in prereqs['feats'])
//        {
//          _prereqs['feats'].add(Feat.get(feat));
//        }
//      }
//
//      else if(prereq == 'abilities')
//      {
//        _prereqs['abilities'] = {};
//        /* abilities:  Dex:  13 */
//        for(var ability in prereqs['abilities'].keys)
//        {
//          _prereqs['abilities'][Ability.get(ability)] = prereqs['abilities'][ability];
//        }
//      }
//
//      else if(prereq == 'level')
//      {
//        _prereqs['level'] = prereqs['level'];
//      }
//
//      else if(prereq == 'base_attack_bonus')
//      {
//        _prereqs['base_attack_bonus'] = prereqs['base_attack_bonus'];
//      }
//
//      else if(prereq == 'multi')
//      {
//        _prereqs['multi'] = [];
//        for(var multi in prereqs['multi'])
//        {
//          _prereqs['multi'].add(prereqs['multi']);
//        }
//      }
//
//      else if(prereq == 'class_features')
//      {
//        _prereqs['class_features'] = [];
//        for(var feature in prereqs[prereq])
//        {
//          // TODO - add features to the class
//          _prereqs['class_features'].add(feature);
//        }
//      }

//      else if(prereq == 'or')
//      {
//        /* run it back through reverse the logic */
//      }
//

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

class Prereq
{
  String name;
  var prereqs;
  bool or = false;
  Prereq(data) {
    if(data is Map && data.keys.contains('or')) {
      or = true;
      /* attach the 'real' data to the root */
      var foo = data['or'];
      data.clear();
      data.addAll(foo);
    }
  }

}

/**
 * Includes skills, classes, abilities
 */
class MapPrereq extends Prereq
{

  Map<Resource, int> prereqs = {};
  MapPrereq(map, type) : super(map)
  {
    for(var key in map.keys)
    {
      var resource = type.invoke(new Symbol('get'), [key]).reflectee;
      print('\tMapPrereq - ${resource}');
      prereqs[resource]= map[key];
    }
    print('\tMapPrereq - ${prereqs}');
  }
}

/**
 * Includes feats, class_features
 */
class ListPrereq extends Prereq
{
  List<Resource> prereqs = [];
  ListPrereq(list, type) : super(list)
  {
    print('\tListPrereq - ${type.reflectedType}');
    for(var item in list)
    {

      var resource = type.invoke(new Symbol('get'), [item]).reflectee;
      print('\tListPrereq - ${resource}');
      prereqs.add(resource);
    }
    print('\tListPrereq - ${prereqs}');
  }
}

/**
 * Key:value. Includes level, base_attack_bonus
 */
class SimplePrereq extends Prereq
{
  int prereq = 0;
  SimplePrereq(list, [type]) : super(list);
}
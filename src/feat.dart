part of resource;

class RelatedData
{
  String classname;
  List data = [];
  RelatedData(map)
  {
//    print('building related_data');
    MirrorSystem mirrors = currentMirrorSystem();
    LibraryMirror lm = mirrors.findLibrary(new Symbol('resource'));
    print('\ttype: ${map['type']}');
    classname = map['type'];
    var type = lm.declarations[new Symbol(map['type'])];
    var resources = type.invoke(new Symbol('get'), []).reflectee;
    for(var resource in resources.values)
    {
//      print('\t${resource}:');
      ObjectMirror o = reflect(resource);
      for(var key in map['filter'].keys)
      {
//        print('\t\tfiltering on ${key}');
        /* category : simple */
        var filterField = o.getField(new Symbol(key));
        if(filterField != null)
        {
          var instFilterValue = filterField.reflectee;
//          print('\t\t${instFilterValue} ?? ${map['filter'][key]}');
          if(map['filter'][key] == instFilterValue) data.add(resource);
        }
      }
    }
  }


}

class Feat extends Resource
{
  static final Symbol MapPrereq = new Symbol('MapPrereq');
  static final Symbol ListPrereq = new Symbol('ListPrereq');
  static final Symbol SimplePrereq = new Symbol('SimplePrereq');
  static final Symbol PickPrereq = new Symbol('PickPrereq');
  static Map<String, Symbol> mappings = {
      'skills' : Feat.MapPrereq,
      'classes' : Feat.MapPrereq,
      'abilities' : Feat.MapPrereq,
      'feats' : Feat.ListPrereq,
      'class_features' : Feat.ListPrereq,
      'base_attack_bonus' : Feat.SimplePrereq,
      'goodness' : Feat.ListPrereq,
      'level' : Feat.SimplePrereq,
      'pick' : Feat.PickPrereq
  };
  static Map<String, List<Feat>> groupToFeats = {};
  static Map<String, Feat> _feats = {};
  static LibraryMirror lm = currentMirrorSystem().findLibrary(new Symbol('resource'));

  String cmb;
  List<String> _groups = [];
  Map<Skill, Map> _skills = {};
  List<Prereq> _prereqs = [];
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

  get groups => _groups;
  set groups(List groups)
  {
    _groups = groups;
    for(var group in groups)
    {
      if(groupToFeats[group] == null) groupToFeats[group] = [];
      groupToFeats[group].add(this);
    }
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
    print('\t\t[${name}] related_data: ${map}');
    _relatedData = new RelatedData(map);

  }

  get prereqs => _prereqs;
  set prereqs(Map prereqs)
  {
//    print('prereqs for: ${name}');
    for(var prereq in prereqs.keys)
    {
//      print('\t${prereq}');
      ClassMirror cm = lm.declarations[Feat.mappings[prereq]];
      InstanceMirror im = cm.newInstance(const Symbol(''), [prereq, prereqs[prereq], lm.declarations[translations[prereq]]]);
      _prereqs.add(im.reflectee);
    }
//    print('prereqs for ${name}: ${_prereqs}');
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
  
  bool meetsPrereqs(Character char) {
    for(var prereq in _prereqs)
    {
      if(!prereq.meets(char))
      {
        return false;
      }
    }
    return true;
  }
}

class MultiSelectFeat extends Feat
{
  /* if the related_data should be filtered to include only the intersection
   * of comparable Character data.  eg. */
  bool char_filter;
  Map _multi = {};

  MultiSelectFeat.map(map) : super.map(map);

  MultiSelectFeat(name, description) : super(name, description);

  get multi => _multi;
  set multi(Map multi)
  {
    // TODO - UGLY
    if(multi['char_filter'] != null)
    {
      char_filter = multi['char_filter'];
      multi.remove('char_filter');
    }

    print('initializing multi [${name}]');
    for(var typename in multi.keys)
    {
      print('\tpopulating ${multi[typename]}');
      var type = lm.declarations[translations[typename]];
      for(var item in multi[typename])
      {
        print('\t\tfound ${item}');
        var resource = type.invoke(new Symbol('get'), [item]).reflectee;
        if(_multi[typename] == null) _multi[typename] = [];
        _multi[typename].add(resource);
      }
    }
  }


}

abstract class Prereq
{
  String name;
  var prereqs;
  bool or = false;
  Prereq(name, data) {
    this.name = name;
    if(data is Map && data.keys.contains('or')) {
      or = true;
      /* attach the 'real' data to the root */
//      print('\t\t\tbefore detach: ${data}');
      var foo = data['or'];
//      print('\t\t\tafter detach: ${foo}');
      data.clear();
      // TODO - hack b/c we can't repoint data/change its type for subclass constructor
      if(foo is List)
      {
        for(var item in foo)
        {
          data[item] = null;
        }
      }
      else
      {
        data.addAll(foo);
      }

    }
  }

  bool meets(Character char);

  toString()
  {
    return '${name} : ${prereqs}';
  }
}

/**
 * Includes skills, classes, abilities
 */
class MapPrereq extends Prereq
{

  Map<Resource, int> prereqs = {};
  MapPrereq(name, map, type) : super(name, map)
  {
    for(var key in map.keys)
    {
      var resource = type.invoke(new Symbol('get'), [key]).reflectee;
//      print('\tMapPrereq - ${resource}');
      prereqs[resource]= map[key];
    }
//    print('\tMapPrereq - ${prereqs}');
  }

  bool meets(Character char)
  {
//    var meets = or; // false, say
    var meets = !or;
    ObjectMirror o = reflect(char);
    Map map = o.getField(new Symbol(name)).reflectee;

    print('${map} ?? ${prereqs}');

    for(var prereq in prereqs.keys)
    {
      if(or)
      {
        if(prereqs[prereq] is int)
        {
//          print('\tvalue is int: ${prereqs[prereq]}');
          if (map[prereq] >= prereqs[prereq])
          {
//            print('OR: ${map} meets ${prereqs}');
            return true;
          }

        }
        else
        {
          if (map[prereq] == prereqs[prereq])
          {
//            print('OR: ${map} meets ${prereqs}');
            return true;
          }
        }
      }
      else
      {
        if(prereqs[prereq] is int)
        {
//          print('\tvalue is int: ${prereqs[prereq]}');
          if (map[prereq] < prereqs[prereq])
          {
//            print('${map} DOES NOT meet ${prereqs}');
            return false;
          }
        }
        else
        {
          if(map[prereq] != prereqs[prereq])
          {
//            print('${map} DOES NOT meet ${prereqs}');
            return false;
          }
        }
      }
    }
    return meets;
  }
}

/**
 * Includes feats, class_features
 */
class ListPrereq extends Prereq
{
  List<Resource> prereqs = [];
  ListPrereq(name, list, type) : super(name, list)
  {
    // TODO - we can't change the type in the super constructor
    if(list is Map)
    {
      list = list.keys;
    }
    
    if(name != 'class_features')
    {
//      print('\tListPrereq - ${name} ${type.reflectedType}');
//      print('\t\t\t${type.reflectedType}');
      for(var item in list)
      {

        var resource = type.invoke(new Symbol('get'), [item]).reflectee;
//        print('\tListPrereq - ${resource}');
        prereqs.add(resource);
      }
//      print('\tListPrereq - ${prereqs}');
    }
    else
    {
//      print('\n\t\t!!! ${name} CHANNEL FEATURES not implemented: ${list}\n');
    }
  }

  bool meets(Character char)
  {
//    var meets = or; // false, say
    var meets = !or;
    ObjectMirror o = reflect(char);
    Iterable list = o.getField(new Symbol(name)).reflectee;
    for(var prereq in prereqs)
    {
      if(or)
      {
        if(list.contains(prereq))
        {
          print('OR: ${list} contains ${prereq}');
          return true;
        }
      }
      else
      {
        if(!list.contains(prereq))
        {
          print('${list} DOES NOT contain ${prereq}');
          return false;
        }
      }
    }
    
    print('${list} contains all ${prereqs}');
    return meets;
  }

}

class PickPrereq extends Prereq
{
  int count;
  String group;

  PickPrereq(name, map, [type]) : super(name, map)
  {
    this.count = map['count'];
    this.group = map['group'];
  }


  bool meets(Character char)
  {
    print('PickPrereq meets()');
    int meetsCount = 0;
    for(var feat in Feat.groupToFeats[group])
    {
      if(char.feats.contains(feat))
      {
        print('\tfound a match for ${feat}: ${char.feats}');
        ++meetsCount;
        if(meetsCount == count)
        {
          return true;
        }
      }
    }
    return false;
  }
}

/**
 * key:value. Includes level
 */
class SimplePrereq extends Prereq
{
  int prereqs = 0;
  SimplePrereq(name, value, [type]) : super(name, value)
  {
    prereqs = value;
    /* base_attack_bonus is a list, hack to accomodate */
    if(value is List)
    {
      prereqs = value.reduce(max);
    }
  }
  
  bool meets(char) 
  {
    var meets = !or;
    ObjectMirror o = reflect(char);
    print('SimplePrereq ${name} ${prereqs}');
    var value = o.getField(new Symbol(name)).reflectee;
    /* base_attack_bonus is a list, hack to accomodate, not-so-simple */
    if(value is List)
    {
      value = value.reduce(max);
    }
    print('${name} ${value} : ${prereqs}');
    return value >= prereqs;
  }
}
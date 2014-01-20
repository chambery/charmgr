library ability;

class Ability
{
  final _name;
  final _shortname;
  const Ability._internal(this._name, this._shortname);
  toString() => 'Ability.$_name';

  static const STRENGTH = const Ability._internal('Strength', 'Str');
  static const INTELLIGENCE = const Ability._internal('Intelligence', 'Int');
  static const DEXTERITY = const Ability._internal('Dexterity', 'Dex');
  static const CONSTITUTION = const Ability._internal('Constitution', 'Con');
  static const WISDOM = const Ability._internal('Wisdom', 'Wis');
  static const CHARISMA = const Ability._internal('Charisma', 'Cha');
  
  static Ability get(name)
  {
    switch(name)
    {
	    case 'Strength': return Ability.STRENGTH;
	    case 'Str': return Ability.STRENGTH;
	    case 'Intelligence': return Ability.INTELLIGENCE;
	    case 'Int': return Ability.INTELLIGENCE;
	    case 'Dexterity': return Ability.DEXTERITY;
	    case 'Dex': return Ability.DEXTERITY;
	    case 'Constitution': return Ability.CONSTITUTION;
	    case 'Con': return Ability.CONSTITUTION;
	    case 'Wisdom': return Ability.WISDOM;
	    case 'Wis': return Ability.WISDOM;
	    case 'Charisma': return Ability.CHARISMA;
	    case 'Cha': return Ability.CHARISMA;
    }
  }
}
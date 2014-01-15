library alignment;

class Alignment
{
  final _name;
  const Alignment._internal(this._name);
  toString() => 'Alignment.$_name';

  static const LAWFUL = const Alignment._internal('Lawful');
  static const NEUTRAL = const Alignment._internal('Neutral');
  static const CHAOTIC = const Alignment._internal('Chaotic');

  static Alignment get(name)
  {
    switch(name)
    {
      case 'Lawful': return Alignment.LAWFUL;
      case 'Neutral': return Alignment.NEUTRAL;
      case 'Chaotic': return Alignment.CHAOTIC;
    }
  }
}


class Goodness
{
  final _name;
  const Goodness._internal(this._name);
  toString() => 'Goodness.$_name';

  static const GOOD = const Goodness._internal('Good');
  static const NEUTRAL = const Goodness._internal('Neutral');
  static const EVIL = const Goodness._internal('Evil');

  static Goodness get(name)
  {
    switch(name)
    {
      case 'Good': return Goodness.GOOD;
      case 'Neutral': return Goodness.NEUTRAL;
      case 'Evil': return Goodness.EVIL;
    }
  }
}
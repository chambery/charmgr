library armor;

class Armor
{
  String name;
  int acp;
  int bonus;
  String category;

  String cost;
  int max_dex_bonus = null;
  int spell_fail_pct;
  int speed30;
  int speed20;
  int weight;

  Armor(this.name, this.bonus, this.acp, this.category);
}

class Mail extends Armor
{
  Mail(name, bonus, acp, category) : super(name, bonus, acp, category);
}

class Shield extends Armor
{
  Shield(name, bonus, acp, category) : super(name, bonus, acp, category);
}

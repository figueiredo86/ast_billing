#!/usr/bin/perl -w

use Asterisk::AGI;

$agi = new Asterisk::AGI;

sub main () {
 # recebe e define as variáveis que serão utilizadas na sessão
 my $exten = $ARGV[0];
 &check_ext_type($exten);
}

sub check_ext_type () {
 my $exten = $_[0];
 if (substr($exten,0,1) != 0) { #tratamento para chamada interna
  $agi->noop("essa é uma chamada interna e não será tarifada");
  $agi->set_variable("CDR(userfield)","interna");
 } 
 elsif (substr($exten,1,1) != 0) { #tratamento para chamada local // definir regras para fixo e móvel
  $agi->noop("essa é uma chamada local e o minuto é igual a 0.05");
  $agi->set_variable("CDR(userfield)","local");
 }
 elsif (substr($exten,1,1) == 0) { #tratamento para chamada não local
  if (substr($exten,2,1) == 0) { #chamada internacional
   $agi->noop("essa é uma chamada internacional e o minuto é igual a 1.30");
   $agi->set_variable("CDR(userfield)","ddi");
  }
  else { #chamada interurbana
   $agi->noop("essa é uma chamada ddd e o minuto é igual a 0.15");
   $agi->set_variable("CDR(userfield)","ddd");
  }
 }
}

&main;
exit 0;

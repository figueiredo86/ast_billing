#!/usr/bin/perl -w

use Asterisk::AGI;
use Switch;

$agi = new Asterisk::AGI;

sub main () {
 # recebe e define as variáveis que serão utilizadas na sessão
 my $exten = $ARGV[0];
 &check_ext_type($exten);
 &select_route($call_type,$exten);
}

sub check_ext_type () {
 my $exten = $_[0];
 if (substr($exten,0,1) != 0) {
  $agi->noop("essa é uma chamada interna e não será tarifada");
  $agi->set_variable("CDR(userfield)","interna");
  $call_type = "interna";
  return $call_type;
 } 
 elsif (substr($exten,1,1) != 0) {
  $agi->noop("essa é uma chamada local e o minuto é igual a 0.05");
  $agi->set_variable("CDR(userfield)","local");
  $call_type = "local";
  return $call_type;
 }
 elsif (substr($exten,1,1) == 0) {
  if (substr($exten,2,1) == 0) {
   $agi->noop("essa é uma chamada internacional e o minuto é igual a 1.30");
   $agi->set_variable("CDR(userfield)","ddi");
   $call_type = "ddi";
   return $call_type;
  }
  else { 
   $agi->noop("essa é uma chamada ddd e o minuto é igual a 0.15");
   $agi->set_variable("CDR(userfield)","ddd");
   $call_type = "ddd";
   return $call_type;
  }
 }
}

sub select_route () {
 my $call_type = $_[0];
 my $exten = $_[1];
 switch ($call_type) {
  case "interna" {
   $agi->exec('Dial',"SIP/$exten,60,tTwW");
  }
 }
}

&main;
exit 0;

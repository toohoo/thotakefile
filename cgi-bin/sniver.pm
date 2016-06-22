package sniver;

#######################################################################################################################
##				Erstellung 16.03.2011 - Thomas Hofmann
##
##	Alle Funtionen die zur Verfuegung stehen befinden sich im @EXPORT
##	
##	alle Aenderungen : "NAM dd.mm.yyyy" (erste 3 Buchstaben Name in gross)
##
##	_Wir_ :-> haben nun ein Package, wo alles drin ist - fuer meine TH Schnittstellen
##
#######################################################################################################################

use strict;
use vars qw( @ISA @EXPORT);
use Exporter;
@ISA = ( 'Exporter' );

use lib '/intranet/www/www10001/www/ssl.innosystems.net/cgi-bin/sniver/general/';
#use innosystems;

#!/usr/bin/perl
use Time::Local;
use MIME::Base64;
use LWP;
#use LWP::UserAgent;


@EXPORT = qw(
PATH_SSL
PDFwebdir
PDFwebaddress
pfadunddat
nurpfad
nurdat
isunixundslash
isunix
slash
ENV2table
query2table
hash2table
array2table
getthvars
webabbruch
webwarnung
webreport
ansi2doppel
serverundweb
zufall
punkt2komma
komma2punkt
nachkomma
nachpunkt
rundennachkomma
rundennachpunkt
ascii2utf8
ascii2umlmark
umlmark2utf8
utf82ascii
utf82umlmark
umlmark2ascii
ascii2uml
sonder2ent
getdatetime
getdatetimehuman
scalar2queryx
scalar2ENVx
logtimeof
logtime
date2us
date2de
push2emailhashx
popfromemailhashx
ftp
scp
fehlermail
reportmail
reportmail2
PDF3mail
laendercodedat
hunderassedat
hunderassedat2
berufenvdat
berufenvdatneu
berufehkddat
beruferhiondat
berufeunfallcsvdat
landvoncode
jahrplus
jahrdiff
encode_base64
codesyntax
getfile
setquery
writefile
hunderasse
hunderasse2
queryland
getberufe
getberufesemi
getberufemitid
getberufemitid_allianz
getberufemitid2
berufe2key
berufe2keyhash
makeid
berufehtml
berufehtml_allianz
berufehtml2
berufehtml3
berufehtml4
berufeHtmlSortID
satz_direkt_abgeschlossen
satz_fehler_direkt_abgeschlossen
satz_fehler_direkt_abgeschlossen_mlp
errmailth
satzwebservicetest
satz_webservice_fehler
satz_vermittlernummer_fehlt
satz_kein_invitatio
satz_kein_rechnung
satz_auswahl_kein_direktabschluss
zwzuschlag
gesrabatt
laenderzeichendat
biproDatentypenDat
landzeichen
queryland2
testuser
testuserstring
checkVersicherungsort
getxmlfilename
erbe
isbeamter
mische
datusort
firstlast
datediff
checksendlistealt
innomail
partnermail
partnermails
gethashfromfile
writehash2file
anhangraus
getuserftp
zahlweisezahl
val2key
getBiproDatentypen
hash2select
hash2selectname
setOldQueryVars
urlok
mailok
anhaenge2gdv
fuell
innolog
client
umlaute
print_xml
Write_Client
setElContByID
setAttByID
setElCont
setElAttByID
getElCont
getElContVorsatz
getElStart
getElEnd
getElStartEnd
responseBodyLeer
responseIsErrorRhion
responseBodyFehler
responseBodyFehler0
getElByID
getElStartTagByID
wsFehlerseiteAbbruch
wsFehlerseiteAbbruchWW
xberufehtml2
xberufehtml3
xberufehtml4
xberufe2key
xberufe2keyhash
xmakeid
kundenftp
getcsvkunden
hashsortvalkeyarray
getanhangkunden
kundenftpimmer
mailempf
uebermittelteMailadressen
kundenMailempfUntermandant
get_vermittlernr2
vermittlersplit
filenameclear
runde2stufen
utf82ent
ansi2ent
ent2ansi
fz_datnam
get_STS_manager
berufeGothaerDat
getBerufeGothaer
berufeGothaerDat3
getBerufeGothaer3
BAKfromQuery
satz_unter_nummer_eingereicht
innoip
isinnoip
);

##########################################################################################
# Unterroutinen 
# Thomas Hofmann ab 01.02.2008
#
# Achtung:
#	Der Server laeuft derzeit ohne mod-perl, trotzdem gleich sauber programmieren
##########################################################################################

#if (!$main::PATH_SSL) { $main::PATH_SSL = &PATH_SSL(); }

sub PATH_SSL {
	return ("/intranet/www/www10001/www/ssl.innosystems.net/");
}

sub PDFwebdir {
	return( &PATH_SSL() . 'http-docs/pdfoutput/');
}

sub PDFwebaddress {
	return( 'https://'.$ENV{'SERVER_NAME'}.'/pdfoutput/');
}

## HOF 23.09.2008, wenn Laendercode nicht belegt, dann hier global vorbelegen?
## 	oder nur aufrufen, wenn es gebraucht wird?
# &queryland();



sub pfadunddat {
	my $pfad = $_[0];
	my $dat;
	#               'a/b/c', '/b/c', '/c'
	if ( $pfad =~ m/^(([^\/\\]*[\/\\])+)([^\/\\]+)$/i ) {
		$pfad = $1;
		$dat = $3;
		$pfad =~ s/([^\/\\])[\/\\]+$/$1/i;
	#               'a/b/', '/b/', '/'
	} elsif ($pfad =~ m/^(([^\/\\]*[\/\\])+)$/i) {
		$pfad = $1;
		$dat = "";
		$pfad =~ s/([^\/\\])[\/\\]+$/$1/i;
	} else {
		$dat = $pfad;
		$pfad = "";
	}
	return ($pfad, $dat);
}


sub nurpfad {
	my ($pfad, $dat) = ($_[0], "");
	($pfad, $dat) = &pfadunddat($pfad);
	return ($pfad);
}

sub nurdat {
	my ($pfad, $dat) = ($_[0], "");
	($pfad, $dat) = &pfadunddat($pfad);
	return ($dat);
}


sub isunixundslash {
	my $os = $ENV{"SERVER_SOFTWARE"};
	my $slash;
	my $isunix;
	if ($os =~ m/(linux|unix)/i) { 
		$isunix = 1;
		$slash = "\/";
	} else {
		undef $isunix;
		$slash = "\\";
	}
	return ($isunix, $slash);
}

sub isunix {
	my ($isunix, $slash) = &isunixundslash();
	return ($isunix);
}

sub slash {
	my ($isunix, $slash) = &isunixundslash();
	return ($slash);
}

sub ENV2table {
	my $envtable = "<table style='border:0px; margin:1px;'>\n";
	my ($farbe1, $farbe2) = ( '#FFFFCC', '#99CCFF' );
	if ( $main::thvars{'Zeilenfarbe1'} ) { $farbe1 = $main::thvars{'Zeilenfarbe1'}; }
	if ( $main::thvars{'Zeilenfarbe2'} ) { $farbe2 = $main::thvars{'Zeilenfarbe2'}; }
	#my $aktfarbe = $farbe1;
	$envtable .= "<tr><th colspan='2' style='background:$farbe2;'>Environment \%ENV</th></tr>\n";
	foreach my $k (sort(keys(%ENV))) {
		#$envtable .= "<tr><td style='background:$aktfarbe;'>" . $k . "</td><td style='background:$aktfarbe;'>" . $ENV{$k} . "</td></tr>\n";
		$envtable .= "<tr><td style='background:$farbe1;'>" . $k . "</td><td style='background:$farbe1;'>" . $ENV{$k} . "</td></tr>\n";
		#if ( $aktfarbe eq $farbe1 ) { $aktfarbe = $farbe2; } else { $aktfarbe = $farbe1; }
		($farbe1,$farbe2) = ($farbe2,$farbe1);
	}
	$envtable .= "</table>\n";
	return ($envtable);
}

sub query2table {
	my $querytable = "<table style='border:0px; margin:1px;'>\n";
	my ($farbe1, $farbe2) = ( '#FFFFCC', '#99CCFF' );
	if ( $main::thvars{'Zeilenfarbe1'} ) { $farbe1 = $main::thvars{'Zeilenfarbe1'}; }
	if ( $main::thvars{'Zeilenfarbe2'} ) { $farbe2 = $main::thvars{'Zeilenfarbe2'}; }
	#my $aktfarbe = $farbe1;
	my ($k, $v);
	$querytable .= "<tr><th colspan='2' style='background:$farbe2;'>Query \%query</th></tr>\n";
	foreach $k (sort(keys(%main::query))) {
		$v = $main::query{$k};
		$k =~ s/\</\&lt;/g;
		$v =~ s/\</\&lt;/g;
		#$querytable .= "<tr><td style='background:$aktfarbe;'>" . $k . "</td><td style='background:$aktfarbe;'>" . $v . "</td></tr>\n";
		$querytable .= "<tr><td style='background:$farbe1;'>" . $k . "</td><td style='background:$farbe1;'>" . $v . "</td></tr>\n";
		#if ( $aktfarbe eq $farbe1 ) { $aktfarbe = $farbe2; } else { $aktfarbe = $farbe1; }
		($farbe1,$farbe2) = ($farbe2,$farbe1);
	}
	$querytable .= "</table>\n";
	return ($querytable);
}

sub hash2table {
	my %hash = @_;
	my $envtable = "<table style='border:0px; margin:1px;'>\n";
	my ($farbe1, $farbe2) = ( '#FFFFCC', '#99CCFF' );
	if ( $main::thvars{'Zeilenfarbe1'} ) { $farbe1 = $main::thvars{'Zeilenfarbe1'}; }
	if ( $main::thvars{'Zeilenfarbe2'} ) { $farbe2 = $main::thvars{'Zeilenfarbe2'}; }
	my $aktfarbe = $farbe1;
	$envtable .= "<tr><th colspan='2' style='background:$farbe2;'>Hash-Variable</th></tr>\n";
	my $val;
	foreach my $k (sort(keys(%hash))) {
		#$envtable .= "<tr><td style='background:$aktfarbe;'>" . $k . "</td><td style='background:$aktfarbe;'>" . $hash{$k} . "</td></tr>\n";
		$val = $hash{$k};
		if ( $val =~ m|<([^>]*)>| ) {
			$val =~ s|<([^>]*)>|<font color="#FF0000">&lt;$1></font>|gs;
		} elsif ( $val =~ m|<| ) {
			$val =~ s|<|<font color="#FF0000">&lt;</font>|gs;
		}
		if ( $val =~ m|<([^>]*)$| ) {
			$val =~ s|<([^>]*)$|<font color="#FF0000">&lt;</font>$1|gs;
		}
		$envtable .= "<tr><td style='background:$farbe1;'>" . $k . "</td><td style='background:$farbe1;'>" . $val . "</td></tr>\n";
		#if ( $aktfarbe eq $farbe1 ) { $aktfarbe = $farbe2; } else { $aktfarbe = $farbe1; }
		($farbe1,$farbe2) = ($farbe2,$farbe1);
	}
	$envtable .= "</table>\n";
	return ($envtable);
}

sub array2table {
	my @arr = @_;
	my ($ent,$i,%arr,$arrtable);
	for ($i=0; $i<=$#arr; $i++) {
		$arr{$i} = $arr[$i];
	}
	$arrtable = &hash2table(%arr);
	$arrtable =~ s/Hash(-Variable)/Array$1/i;
	return($arrtable);
}

sub getthvars {
	## Achtung! man kann sich nicht auf $0 verlassen.
	## 	es kann sein, dass dieses Script mal von einer anderen Stelle aus aufgerufen wird
	## 	$PATH_SSL soll immer stimmen, oder selbst rein schreiben
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL();}
	my $thvarsdatnam = "thvars.ini";
	my ($isunix, $slash) = &isunixundslash();
	my $aktdir = &nurpfad($0);
	$aktdir = $PATH_SSL . "cgi-bin/vers2002/";
	#my $thvarsdat = "$aktdir$slash$thvarsdatnam";
	my $thvarsdat = "$aktdir$thvarsdatnam";
	my %thvars = ();
	my $line;
	my $errmail = &innomail('TH');
	
	if (-f $thvarsdat) { 
		if ( !(open(VARS, $thvarsdat)) ) { 
			&fehlermail(&errmailth(), &errmailth(), '', "Fehler thincs.pl-getthvars", "Kann Konstanten nicht einlesen. [$thvarsdat] "); 
			#&webwarnung("Kann Konstanten nicht einlesen. [$thvarsdat] "); 
		} 
		my @lines = <VARS>;
		close(VARS);
		foreach $line (@lines) {
			if ($line =~ m/^;/i) {
				#-- Kommenntar
			} elsif ($line =~ m/^\[/i) {
				#-- Abschnitt, das kriegen wir spaeter, jetzt nicht benoetigt
			} elsif ($line =~ m/^[ \t\r\n]*$/i) {
				#-- nur leer, nix machen
			} elsif ($line =~ m/^([^=]+)=(.*?)$/i) {
				#-- etwas Richtiges, Variable einlesen
				$thvars{$1} = $2;
			} else {
				#-- ja, Fehler koennen auch vorkommen, hier aber nix machen
			}
		}
		#-- cool! fertig!
	} else {
		undef(%thvars);
		#&webwarnung("Kann die Konstanten NICHT einlesen. [$thvarsdat] "); #-- alles Weitere wird danach normalerweise nicht mehr aufgerufen
		my $subj = "getthvars: Kann die Konstanten NICHT einlesen";
		my $mailtext = "$subj [$thvarsdat].";
		&fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (%thvars);
	}
	
	return(%thvars);
}

sub webabbruch {
	my $mess = $_[0];
	print "<p class='webabbruch'><span class='webabbruchhervor'>Abbruch:</span> $mess</p>\n";
	exit(1);
}

sub webwarnung {
	my $mess = $_[0];
	#$mess =~ s/\]/\&#93;/ig;
	#$mess =~ s/\[/\&#91;/ig;
	print "<p class='webwarnung'><span class='webwarnunghervor'>Warnung:</span> $mess</p>\n";
}

sub webreport {
	my $mess = $_[0];
	print "<p class='webreport'>$mess</p>\n";
}

sub ansi2doppel {
	my $stri = $_[0];
	$stri =~ s/\xE4/ae/g;
	$stri =~ s/\xF6/oe/g;
	$stri =~ s/\xFC/ue/g;
	$stri =~ s/\xC4/Ae/g;
	$stri =~ s/\xD6/Oe/g;
	$stri =~ s/\xDC/Ue/g;
	$stri =~ s/\xDF/ss/g;
	return($stri);
}

sub serverundweb {
	## Ermitteln des Serverpfades des aktuellen Scripts und des Webpfades
	my ($serv, $web);
	my $fn = $ENV{'SCRIPT_FILENAME'};
	#print "<p><b>serverundweb</b> SCRIPT_FILENAME [$ENV{SCRIPT_FILENAME}]</p>\n";
	$serv = &nurpfad($fn);
	my $host = $ENV{'HTTP_HOST'};
	my $serverpath = &nurpfad($ENV{'DOCUMENT_ROOT'});
	my $webpath = $serv;
	$webpath =~ s/$serverpath//;
	$web = "http://$host$webpath";
	return ($serv, $web);
}

sub zufall {
	my ($stellen, @rest) = @_;
	if (!$stellen) {$stellen = 8;}
	my $maske = '1' . '0' x ($stellen - 1);
	#print "stellen[$stellen]: [$maske]\n";
	#print length($maske), "\n";
	my $z = rand($maske);
	my $muster = "%0$stellen.0f";
	#print "muster: [$muster] -- z: [$z] \n";
	return (sprintf($muster, $z));
}

sub punkt2komma {
	my ($betrag, @rest) = @_;
	if ($betrag =~ m/,.*?\./) {
		$betrag =~ s/,//g;
	}
	$betrag =~ s/\./,/g;
	return ($betrag);
}

sub komma2punkt {
	my ($betrag, @rest) = @_;
	if ($betrag =~ m/\..*?,/) {
		$betrag =~ s/\.//g;
	}
	$betrag =~ s/,/./g;
	return ($betrag);
}

sub nachkomma {
	my ($betrag, $stellen, $istmittausender, @rest) = @_;
	if ($betrag =~ m/\..*?,/) {
		$betrag =~ s/\.//g;
	} elsif ($betrag =~ m/\.\d\d\d\.\d\d\d$/) {
		$betrag =~ s/\.//g;
	}
	if ($istmittausender) {
		$betrag =~ s/\.//g;
	}
	$betrag =~ s/,/\./;
	$betrag = sprintf("%.$stellen"."f", $betrag);
	$betrag =~ s/\./,/i;
	return ($betrag);
}

sub nachpunkt {
	my ($betrag, $stellen, $istmittausender, @rest) = @_;
	if ($betrag =~ m/\..*?,/) {
		$betrag =~ s/\.//g;
	} elsif ($betrag =~ m/\.\d\d\d\.\d\d\d$/) {
		$betrag =~ s/\.//g;
	}
	if ($istmittausender) {
		$betrag =~ s/\.//g;
	}
	$betrag =~ s/,/\./;
	$betrag = sprintf("%.$stellen"."f", $betrag);
	return ($betrag);
}

sub rundennachkomma {
	## rundet bei zahl=0.345 und stellen=2 auf 0.35
	my ($zahl, $stellen, $istmittausender, @rest) = @_;

	if ($zahl =~ m/\..*?,/) {
		$zahl =~ s/\.//g;
	} elsif ($zahl =~ m/\.\d\d\d\.\d\d\d$/) {
		$zahl =~ s/\.//g;
	}
	if ($istmittausender) {
		$zahl =~ s/\.//g;
	}
	$zahl =~ s/,/\./;
	
	my ($teiler, $plus) = (1, 0.1);
	if ($stellen > 0) { 
		my $nullen = '0' x $stellen;
		$teiler .= $nullen;
		$plus = '0.' . $nullen . '1';
	}
	#else { print "stellen <= 0"; }
	#print "nachkomma2: teiler: [$teiler]\n";
	
	# Eventuelle dritte Nachkommastelle auf / abrunden der beruehmte cent !!!
#	if ((($zahl * $teiler) - ( int($zahl * $teiler))) >= 0.5 ) {
#		$zahl = (int($zahl * $teiler + 1)) / $teiler  ;
#	} else {
#		$zahl = (int($zahl * $teiler)) / $teiler;
#	}

	$zahl += $plus;
	$zahl = sprintf("%.$stellen"."f", $zahl);
	$zahl =~ s/\./,/i;

	return ($zahl);
}

sub rundennachpunkt {
	## rundet bei zahl=0.345 und stellen=2 auf 0.35
	my ($zahl, $stellen, $istmittausender, @rest) = @_;

	if ($zahl =~ m/\..*?,/) {
		$zahl =~ s/\.//g;
	} elsif ($zahl =~ m/\.\d\d\d\.\d\d\d$/) {
		$zahl =~ s/\.//g;
	}
	if ($istmittausender) {
		$zahl =~ s/\.//g;
	}
	$zahl =~ s/,/\./;
	
	my ($teiler, $plus) = (1, 0.1);
	if ($stellen > 0) { 
		my $nullen = '0' x $stellen;
		$teiler .= $nullen;
		$plus = '0.' . $nullen . '1';
	}
	#else { print "stellen <= 0"; }
	#print "nachkomma2: teiler: [$teiler]\n";
	
	# Eventuelle dritte Nachkommastelle auf / abrunden der beruehmte cent !!!
#	if ((($zahl * $teiler) - ( int($zahl * $teiler))) >= 0.5 ) {
#		$zahl = (int($zahl * $teiler + 1)) / $teiler  ;
#	} else {
#		$zahl = (int($zahl * $teiler)) / $teiler;
#	}

	$zahl += $plus;
	$zahl = sprintf("%.$stellen"."f", $zahl);

	return ($zahl);
}

sub ascii2utf8 {
	my ($source, @rest) = @_;

	$source = &ascii2umlmark($source);
	$source = &umlmark2utf8($source);
	return($source);

	## lt. Herrn Brodbeck am 07.05.2008 noch aeiou mit "Akzent in beide Richtungen"
	## 	meint hier jeweils der Buchstabe mit acute Akzent und grave Akzent
}
	sub ascii2umlmark {
		my ($source, @rest) = @_;
		$source =~ s/\xE4/#ae#/g;
		$source =~ s/\xF6/#oe#/g;
		$source =~ s/\xFC/#ue#/g;
		$source =~ s/\xC4/#Ae#/g;
		$source =~ s/\xD6/#Oe#/g;
		$source =~ s/\xDC/#Ue#/g;
		$source =~ s/\xDF/#szlig#/g;

		$source =~ s/\xE1/#aacute#/g;
		$source =~ s/\xE9/#eacute#/g;
		$source =~ s/\xED/#iacute#/g;
		$source =~ s/\xF3/#oacute#/g;
		$source =~ s/\xFA/#uacute#/g;
		$source =~ s/\xE0/#agrave#/g;
		$source =~ s/\xE8/#egrave#/g;
		$source =~ s/\xEC/#igrave#/g;
		$source =~ s/\xF2/#ograve#/g;
		$source =~ s/\xF9/#ugrave#/g;

		$source =~ s/\x80/#euro#/g;
		$source =~ s/\xB0/#deg#/g;
		$source =~ s/\xA7/#sect#/g;
		$source =~ s/\x93/#ldquo#/g;
		$source =~ s/\x94/#rdquo#/g;
		return($source);
	}
	sub umlmark2utf8 {
		my ($source, @rest) = @_;
		$source =~ s/#Ae#/\xC3\x84/g;
		$source =~ s/#Oe#/\xC3\x96/g;
		$source =~ s/#Ue#/\xC3\x9C/g;
		$source =~ s/#ae#/\xC3\xA4/g;
		$source =~ s/#oe#/\xC3\xB6/g;
		$source =~ s/#ue#/\xC3\xBC/g;
		$source =~ s/#szlig#/\xC3\x9F/g;

		$source =~ s/#aacute#/\xC3\xA1/g;
		$source =~ s/#eacute#/\xC3\xA9/g;
		$source =~ s/#iacute#/\xC3\xAD/g;
		$source =~ s/#oacute#/\xC3\xB3/g;
		$source =~ s/#uacute#/\xC3\xBA/g;
		$source =~ s/#agrave#/\xC3\xA0/g;
		$source =~ s/#egrave#/\xC3\xA8/g;
		$source =~ s/#igrave#/\xC3\xAC/g;
		$source =~ s/#ograve#/\xC3\xB2/g;
		$source =~ s/#ugrave#/\xC3\xB9/g;

		$source =~ s/#euro#/\xE2\x82\xAC/g;
		$source =~ s/#deg#/\xC2\xB0/g;
		$source =~ s/#sect#/\xC2\xA7/g;
		$source =~ s/#ldquo#/\xE2\x80\x9C/g;
		$source =~ s/#rdquo#/\xE2\x80\x9D/g;
		return($source);
	}

sub utf82ascii {
	my ($source, @rest) = @_;

	$source = &utf82umlmark($source);
	$source = &umlmark2ascii($source);
	return($source);

	## lt. Herrn Brodbeck am 07.05.2008 noch aeiou mit "Akzent in beide Richtungen"
	## 	meint hier jeweils der Buchstabe mit acute Akzent und grave Akzent
}
	sub utf82umlmark {
		my ($source, @rest) = @_;
		# Achtung, '+', '-'
		my $pos = 0;
		while (($pos = index($source,'+',$pos)) >= 0) {
			substr($source,$pos,1) = '#plus#';
		}
		while (($pos = index($source,'-',$pos)) >= 0) {
			substr($source,$pos,1) = '#minus#';
		}
		
		$source =~ s/\xC3\x84/#Ae#/g;                                                  
		$source =~ s/\xC3\x96/#Oe#/g;                                                  
		$source =~ s/\xC3\x9C/#Ue#/g;                                                  
		$source =~ s/\xC3\xA4/#ae#/g;                                                  
		$source =~ s/\xC3\xB6/#oe#/g;                                                  
		$source =~ s/\xC3\xBC/#ue#/g;                                                  
		$source =~ s/\xC3\x9F/#szlig#/g;                                               

		$source =~ s/\xC3\xA1/#aacute#/g;                                              
		$source =~ s/\xC3\xA9/#eacute#/g;                                              
		$source =~ s/\xC3\xAD/#iacute#/g;                                              
		$source =~ s/\xC3\xB3/#oacute#/g;                                              
		$source =~ s/\xC3\xBA/#uacute#/g;                                              
		$source =~ s/\xC3\xA0/#agrave#/g;                                              
		$source =~ s/\xC3\xA8/#egrave#/g;                                              
		$source =~ s/\xC3\xAC/#igrave#/g;                                              
		$source =~ s/\xC3\xB2/#ograve#/g;                                              
		$source =~ s/\xC3\xB9/#ugrave#/g;                                              

		$source =~ s/\xE2\x82\xAC/#euro#/g;                                                
		return($source);
	}
	sub umlmark2ascii {
		my ($source, @rest) = @_;
		my $pos = 0;
		$source =~ s/#ae#/\xE4/g;
		$source =~ s/#oe#/\xF6/g;
		$source =~ s/#ue#/\xFC/g;
		$source =~ s/#Ae#/\xC4/g;
		$source =~ s/#Oe#/\xD6/g;
		$source =~ s/#Ue#/\xDC/g;
		$source =~ s/#szlig#/\xDF/g;

		$source =~ s/#aacute#/\xE1/g;
		$source =~ s/#eacute#/\xE9/g;
		$source =~ s/#iacute#/\xED/g;
		$source =~ s/#oacute#/\xF3/g;
		$source =~ s/#uacute#/\xFA/g;
		$source =~ s/#agrave#/\xE0/g;
		$source =~ s/#egrave#/\xE8/g;
		$source =~ s/#igrave#/\xEC/g;
		$source =~ s/#ograve#/\xF2/g;
		$source =~ s/#ugrave#/\xF9/g;

		$source =~ s/#euro#/\x80/g;

		while (($pos = index($source,'#plus#',$pos)) >= 0) {
			substr($source,$pos,length('#plus#')) = '+';
		}
		while (($pos = index($source,'#minus#',$pos)) >= 0) {
			substr($source,$pos,length('#minus#')) = '-';
		}
		return($source);
	}

sub ascii2uml {
		my ($source, @rest) = @_;
		$source =~ s/\xE4/ae/g;
		$source =~ s/\xF6/oe/g;
		$source =~ s/\xFC/ue/g;
		$source =~ s/\xC4/Ae/g;
		$source =~ s/\xD6/Oe/g;
		$source =~ s/\xDC/Ue/g;
		$source =~ s/\xDF/ss/g;

		$source =~ s/\xE1/a/g;
		$source =~ s/\xE9/e/g;
		$source =~ s/\xED/i/g;
		$source =~ s/\xF3/o/g;
		$source =~ s/\xFA/u/g;
		$source =~ s/\xE0/a/g;
		$source =~ s/\xE8/e/g;
		$source =~ s/\xEC/i/g;
		$source =~ s/\xF2/o/g;
		$source =~ s/\xF9/u/g;

		$source =~ s/\x80/euro/g;
		return($source);
}

sub sonder2ent {
	## Sonderzeichen in Entities.
	## ACHTUNG: keinen Code hier durch jagen, nur reinen Text wo auch wirklich alles umgewandelt werden soll
	my ($source, @rest) = @_;

	## HOF 21.09.2010; Aenderung wegen Rhion, da kamen noch '&' durch ins XML
	$source =~ s/(\&)([^;\&]*)(\&)/\&amp;$2\&/g;
	$source =~ s/(\&)([^;\&]*)(\&)/\&amp;$2\&/g;
	$source =~ s/(\&)([^;\&]*)$/\&amp;$2/g;

	$source =~ s/</&lt;/g;
	$source =~ s/>/&gt;/g;
	return($source);
}

	sub utf82ent {
		my ($source, @rest) = @_;
		$source =~ s/\xC3\x84/&Auml;/g;                                                  
		$source =~ s/\xC3\x96/&Ouml;/g;                                                  
		$source =~ s/\xC3\x9C/&Uuml;/g;                                                  
		$source =~ s/\xC3\xA4/&auml;/g;                                                  
		$source =~ s/\xC3\xB6/&ouml;/g;                                                  
		$source =~ s/\xC3\xBC/&uuml;/g;                                                  
		$source =~ s/\xC3\x9F/&szlig;/g;                                               

		$source =~ s/\xC3\xA1/&aacute;/g;                                              
		$source =~ s/\xC3\xA9/&eacute;/g;                                              
		$source =~ s/\xC3\xAD/&iacute;/g;                                              
		$source =~ s/\xC3\xB3/&oacute;/g;                                              
		$source =~ s/\xC3\xBA/&uacute;/g;                                              
		$source =~ s/\xC3\xA0/&agrave;/g;                                              
		$source =~ s/\xC3\xA8/&egrave;/g;                                              
		$source =~ s/\xC3\xAC/&igrave;/g;                                              
		$source =~ s/\xC3\xB2/&ograve;/g;                                              
		$source =~ s/\xC3\xB9/&ugrave;/g;                                              

		$source =~ s/\xE2\x82\xAC/&euro;/g;                                                
		return($source);
	}

	sub ansi2ent {
		my ($source, @rest) = @_;
		$source =~ s/\xC4/&Auml;/g;                                                  
		$source =~ s/\xD6/&Ouml;/g;                                                  
		$source =~ s/\xDC/&Uuml;/g;                                                  
		$source =~ s/\xE4/&auml;/g;                                                  
		$source =~ s/\xF6/&ouml;/g;                                                  
		$source =~ s/\xFC/&uuml;/g;                                                  
		$source =~ s/\xDF/&szlig;/g;                                               

		$source =~ s/\xE1/&aacute;/g;                                          
		$source =~ s/\xE9/&eacute;/g;                                          
		$source =~ s/\xED/&iacute;/g;                                          
		$source =~ s/\xF3/&oacute;/g;                                          
		$source =~ s/\xFA/&uacute;/g;                                          
		$source =~ s/\xE0/&agrave;/g;                                          
		$source =~ s/\xE8/&egrave;/g;                                          
		$source =~ s/\xEC/&igrave;/g;                                          
		$source =~ s/\xF2/&ograve;/g;                                          
		$source =~ s/\xF9/&ugrave;/g;                                          

		$source =~ s/\x80/&euro;/g;                                                
		return($source);
	}

	sub ent2ansi {
		my ($source, @rest) = @_;
		$source =~ s/\&Auml;/\xC4/g;                                                  
		$source =~ s/\&Ouml;/\xD6/g;                                                  
		$source =~ s/\&Uuml;/\xDC/g;                                                  
		$source =~ s/\&auml;/\xE4/g;                                                  
		$source =~ s/\&ouml;/\xF6/g;                                                  
		$source =~ s/\&uuml;/\xFC/g;                                                  
		$source =~ s/\&szlig;/\xDF/g;                                               

		$source =~ s/\&aacute;/\xE1/g;                                          
		$source =~ s/\&eacute;/\xE9/g;                                          
		$source =~ s/\&iacute;/\xED/g;                                          
		$source =~ s/\&oacute;/\xF3/g;                                          
		$source =~ s/\&uacute;/\xFA/g;                                          
		$source =~ s/\&agrave;/\xE0/g;                                          
		$source =~ s/\&egrave;/\xE8/g;                                          
		$source =~ s/\&igrave;/\xEC/g;                                          
		$source =~ s/\&ograve;/\xF2/g;                                          
		$source =~ s/\&ugrave;/\xF9/g;                                          

		$source =~ s/\&euro;/\x80/g;                                                
		return($source);
	}


sub getdatetime {
	my $nodelim = shift;  ## delimiter inerhalb date und time raus, dazwischen immer ja
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
                = localtime (time);
    my $delim = $nodelim ? '' : '-';
    my $middelim = $nodelim == 2 ? '' : '-';
    return( $year + 1900 . $delim . substr('0' . ($mon + 1), -2) . $delim . substr('0' . $mday, -2) . $middelim . substr('0' . $hour, -2) . $delim . substr('0' . $min, -2) . $delim . substr('0' . $sec, -2) );
}

sub getdatetimehuman {
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
                = localtime (time);
        my ($zeit, $datum);
        $zeit="$hour:$min:$sec:";
        $zeit =~ s/(\d):/0$1:/g;
        $zeit =~ s/(\d)0(\d)/$1$2/g;
        #$zeit =~ s/:/-/g;
        chop($zeit);
        ++$mon;
        $year += 1900;
        $datum="$mday.$mon.$year";
        $datum =~ s/(\d)\./0$1\./g;
        $datum =~ s/(\d)0(\d)\./$1$2\./g;
        #$datum =~ s/\./-/g;
        #chop($datum);
	return( $datum, $zeit );
}

#sub scalar2query {
#	my ($var, @rest) = @_;
#	my $count = '';
#	if ($var) {
#		while ( $query{"scalar2query-$var$count"} ) {
#			$count++;
#		}
#		$query{"scalar2query-$var$count"} = eval('$' . $var);
#		return ("scalar2query-$var$count");
#	} else {
#		return undef;
#	}
#}

#sub scalar2query2 {
#	my ($varname, $inhalt, @rest) = @_;
#	my $count = '';
#	if ($varname) {
#		while ( $query{"scalar2query2-$varname$count"} ) {
#			$count++;
#		}
#		$query{"scalar2query2-$varname$count"} = $inhalt;
#		return ("scalar2query2-$varname$count");
#	} else {
#		return undef;
#	}
#}

sub scalar2queryx {
	my ($varname, $inhalt, $query, @rest) = @_; # $query = \%query
	my $count = '';
	if ($varname) {
		while ( $$query{"scalar2queryx-$varname$count"} ) {
			$count++;
		}
		$$query{"scalar2queryx-$varname$count"} = $inhalt;
		return ("scalar2queryx-$varname$count");
	} else {
		return undef;
	}
}

#sub scalar2ENV {
#	my ($var, @rest) = @_;
#	my $count = '';
#	if ($var) {
#		while ( $query{"sclar2ENV-$var$count"} ) {
#			$count++;
#		}
#		$ENV{"sclar2ENV-$var$count"} = eval('$' . $var);
#		return ("sclar2ENV-$var$count");
#	} else {
#		return undef;
#	}
#}

sub scalar2ENVx {
	my ($varname, $inhalt, @rest) = @_;
	my $count = '';
	if ($varname) {
		while ( $main::query{"sclar2ENV-$varname$count"} ) {
			$count++;
		}
		$ENV{"sclar2ENV-$varname$count"} = $inhalt;
		return ("sclar2ENV-$varname$count");
	} else {
		return undef;
	}
}

sub logtimeof{
	my ($datu, $zeit, @rest ) = @_;
	#my ($datu, $zeit) = &getdatetimehuman();
	return( &date2us($datu) . 'T' . $zeit );
}

sub logtime{
	#my ($datu, $zeit, @rest ) = @_;
	my ($datu, $zeit) = &getdatetimehuman();
	return( &date2us($datu) . 'T' . $zeit );
}

sub date2us {
	my ($datu, @rest) = @_;
	my @datfeld;
	my $datuneu;
	if ($datu !~ m/^\d{1,2}\.\d{1,2}\.\d{1,4}$/) {
		if ($datu !~ m/^\d{1,4}\-\d{1,2}\-\d{1,2}$/) {
			return($datu);
		} else {
			@datfeld = split(/\-/,$datu,3);
			$datuneu = join( '-', substr( '000' . $datfeld[0], -4 ), substr( '0' . $datfeld[1], -2), substr( '0' . $datfeld[2], -2 ) );
		}
	} else {
		@datfeld = split(/\./,$datu,3);
		$datuneu = join( '-', substr( '000' . $datfeld[2], -4 ), substr( '0' . $datfeld[1], -2), substr( '0' . $datfeld[0], -2 ) );
	}
	return($datuneu);
}
sub date2de {
	my $datu = shift;
	my @datfeld;
	my $datuneu;
	if ( $datu !~ m/^\d{1,4}-\d{1,2}-\d{1,2}$/ ) {
		if ( $datu !~ m/^\d{1,2}\.\d{1,2}\.\d{1,4}$/ ) {
			return( $datu );
		} else {
			@datfeld = split(/\./,$datu,3);
			$datuneu = join( '.', substr( '0' . $datfeld[0], -2 ), substr( '0' . $datfeld[1], -2), substr( '000' . $datfeld[2], -4 ) );
		}
	} else {
		@datfeld = split(/\-/,$datu,3);
		$datuneu = join( '.', substr( '0' . $datfeld[2], -2 ), substr( '0' . $datfeld[1], -2), substr( '000' . $datfeld[0], -4 ) );
	}
	return($datuneu);
}

sub push2emailhashx {
	my ($addr, $typ, $hash) = @_; # $hash ist referenz auf %Hash: $hash = \%to
	my $count = '';
	my $temp = '';
	my $q = \%main::query;
	my @t;
	if (!&mailok($addr)) {
		&reportmail(&innomail('TH'),&innomail('TH'),'','push2emailhashx: falsche Adresse',
			"$addr \n modul[$$q{'modul'}] \n user[$$q{'user'}] \n untermandant[$$q{'untermandant'}]" . 
			" \n $$q{'Nachname'} $$q{'Vorname'}");
		#print "\t>>> push2emailhash: falsche Adresse [$addr]\n";
	}
	@t = keys(%$hash);
	if ( $#t < 0 ) {
		#print "\$#t < 0 [$#t]\n";
		$$hash{$addr} = $typ;
		#print "Anz:" , keys(%hash);
		#<STDIN>;
	}
	elsif ($$hash{$addr} ne undef) {
		#print "\$hash{$addr} ne undef: [$hash{$addr}]\n";
		#<STDIN>;
		#$temp = "\"$typ$count\" <$addr>";
		while ($$hash{"\"$typ$count\" <$addr>"} ne undef) {
			$count++;
			#print "count: $count\n";
		}
		#print "count:$count\n";
		$$hash{"\"$typ$count\" <$addr>"} = $typ;
	} else {
		$$hash{$addr} = $typ;
		#print "else\n";
		#print "\$hash{$addr} = $typ;\n";
		#<STDIN>;
	}
	return (%$hash);
}

sub popfromemailhashx {
	my ($addr, $hash, $typ) = @_; # $hash ist referenz auf %Hash: $hash = \%to
	if (!$addr) {return (%$hash);}
	if ($addr =~ m/^[ \t\r\n]*$/i) {return (%$hash);}
	my $temp = '';
	my @t = keys(%$hash);
	my $derhash;
	foreach $temp(@t) {
		$derhash .= "$temp: $$hash{$temp}, \n";
		if ($temp =~ m/$addr/i) { 
		  if(($typ) && ($$hash{$temp} =~ m/$typ/i)) {
			delete $$hash{$temp}; 
		  } elsif (!($typ)) {
			delete $$hash{$temp}; 
		  }
		}
		#if (($temp =~ m/\@drklein.de/i) && ($$hash{$temp} =~ m/(Untermandant|bcm)/i)) { delete $$hash{$temp}; }
	}
	@t = keys(%$hash);
	my ($thm,$tanz,$tstring) = ('thofmann@innosystems.de',$#t+1,join(';',@t));
	#reportmail($thm,$thm,'',"popfromemailhashx","anzahl \@t[$tanz] -- addr[$addr] -- typ[$typ] -- \nkeys[$tstring] \nhash [$derhash]\n");
	return (%$hash);
}

sub ftp   {

	my ($server, $login, $passwd, $datei, $remotedir, $localdir, $remotefile, $isscp, $scpkeyfile, $scpport, @rest) = @_;
	## TH 28.04.2015; Rueckgabe Erfolg: 1 (scp returned 'OK'); Error: undef or "(Fehlermaldung)";
	$localdir =~ s/\/$//i;
	$datei =~ s/^\///i;
	innolog("ftp: server[$server] login[$login] isscp[$isscp] ", "$localdir\/$datei");
	if ($isscp) {
	  return scp($server, $login, $passwd, $datei, $remotedir, $localdir, $remotefile, $scpkeyfile, $scpport);  ## scp Erfolg: 'OK'; Error: undef?
	}
	my ($ftp, $FEHLER, $passive); #my ($ftp, *FTPMAIL, $FEHLER);
	my ($from, $repl, $to);
	$from = $repl = $to = &innomail('TH');
		
    # FTP
    use Net::FTP;
    #use File::Copy;

        eval {
   
            # lokaler dateiname
            my $localfilename;
            $localfilename = "$localdir\/$datei"; #$localfilename = "$PATH_DIR"."$file";

            # FTP Daten des Gegners
            ## HOF 22.07.2008, werden oben uebergeben.
	    my $remotefilename;
            if ($remotefile ne '') {
			    $remotefilename = $remotefile;
            } else {
			    $remotefilename = $datei;
            }

                # Datei per FTP verschieben.
                # Conopera braucht passive
              if ($server =~ m/(conopera|176.98.166.98|www.iivs.de)/i) { # fies, name wurde in IP geaendert
              	$passive = 1;
                $ftp = Net::FTP->new($server, Passive => 1)
                	or die "Cannot connect to $server (Passive=$passive): $@";
              } else {
                $ftp = Net::FTP->new($server)
                	or die "Cannot connect to $server: $@";
              }
                $ftp->login($login, $passwd)
                	or die "Cannot login (Passive=$passive) ", $ftp->message;
                $ftp->cwd($remotedir)
                	or die "Cannot change working directory (Passive=$passive) ", $ftp->message;
                $ftp->binary
                	or die "Cannot change to binary mode (Passive=$passive) ", $ftp->message;
                $ftp->put($localfilename, $remotefilename)
                	or die "put failed (Passive=$passive) ", $ftp->message, "; localfilename: [$localfilename], remotefilename: [$remotefilename]";
                $ftp->quit;

                #unlink($localfilename); #das loescht das Dokument!!! UAAAH
        };  ## ENDE eval
            $FEHLER = 1 if ($@);

        # Mail bei Fehler
	if ( $FEHLER == 1 ) {

		my $mailprog = '/usr/sbin/sendmail'; # $date ueber getdatetime

		open( FTPMAIL, "|$mailprog -oi -t -odq" ) || die "Can't open $mailprog \n";
		print FTPMAIL <<__END_FTP__;
From: $from
Reply-To: $repl
To: $to
CC: 
Subject: FTP Uploadfehler $server $datei

Die Datei
$datei
konnte nicht auf Server $server kopiert werden.
Fehlermeldung:
$@
mein Server:
$ENV{'SERVER_NAME'}
meine IP
$ENV{'SERVER_ADDR'}

(ftp user[$login])
__END_FTP__

		close (FTPMAIL);
		return '';
	}
	return 1;
}

sub scp   {

	my ( $server, $login, $passwd, $datei, $remotedir, $localdir, $remotefile, $scpkeyfile, $scpport, @rest ) = @_;
	my ( $ftp, $FEHLER ); # *FTPMAIL, -
	my ( $from, $repl, $to );
	$from = $repl = $to = innomail('TH');
	my $run;

	#scp -2 -q -C -i innosystems.key -P48143 -oBatchMode=yes -oStrictHostKeyChecking=no test.txt innosystems@matrix.asi-online.de:/home/innosystems/test.txt
		
    # SCP fuer asi-online.de, user: ASIW48
    #use Net::FTP;
    #use File::Copy;


        eval {
   
            # lokaler dateiname
            my $localfilename;
            #$localfilename = "$PATH_DIR"."$file";
            $localdir =~ s|\/$||i;
            $localfilename = "$localdir\/$datei";

            # FTP Daten des Gegners
            ## HOF 22.07.2008, werden oben uebergeben.
		    my $remotefilename;
            #$remotedir = "/tmp";
            #$remotefilename = "$file";
            if ( $remotefile ne '' ) {
		    	$remotefilename = $remotefile;
            } else {
		    	$remotefilename = $datei;
            }
            if ( $remotedir ) { 
            	$remotedir =~ s|\/$||i;
            	$remotefilename = "$remotedir\/$remotefilename"; 
            }

	    my $isport = '';
	    if ( $scpport ) { $isport = "-P$scpport"; }
                #open (FILE, ">$localfilename") or die "Can't open $localfilename\n";

                # Datei per FTP verschieben.
                
            my $ident = '';
            if ( $scpkeyfile ) { $ident = "-i $scpkeyfile"; }

	    my ($errdat,$err,@err);
	    $errdat = &PDFwebdir . "\/scperr.txt";
	    $errdat =~ s|\/\/scperr.txt|\/scperr.txt|i;
	    $run = "scp -2 -q -C $ident $isport -oBatchMode=yes -oStrictHostKeyChecking=no $localfilename $login\@$server:$remotefilename 2>$errdat";
	    reportmail( innomail('TH'), innomail('TH'), '', "SCP vor run", $run );
		$@ = `scp -2 -q -C $ident $isport -oBatchMode=yes -oStrictHostKeyChecking=no $localfilename $login\@$server:$remotefilename 2>$errdat`;
	    if ( open( SCPERRDAT, $errdat ) ) {
	    	my $orgein = $/; undef $/;
	    	@err = <SCPERRDAT>;
	    	close (SCPERRDAT);
	    	$/ = $orgein;
	    	if ( $err ) {$err .= "\n";}
		$err .=  join( "\n", @err );
		$@ .= $err;
	    }

                #unlink($localfilename); #das loescht das Dokument!!! UAAAH
        };  ## ENDE eval
        if ( $@ ) {
			$FEHLER=1;
        }

        # Mail bei Fehler
	if ( $FEHLER == 1 ) {

		my $mailprog = '/usr/sbin/sendmail';
		#$date = `/bin/date`; chop ($date);

		open ( SCPMAIL, "|$mailprog -oi -t -odq") || die "Can't open $mailprog \n";
		print  SCPMAIL <<__END_SCP__;
From: $from
Reply-To: $repl
To: $to
CC: 
Subject: SCP Uploadfehler $server $datei

Die Datei
$datei
konnte nicht per SCP auf Server $server kopiert werden.
Aufruf:
$run

Fehlermeldung:
$@
__END_SCP__

		close (SCPMAIL);
		return '';
	}
	return 'OK';
}

sub fehlermail {
	my ($from, $to, $cc, $subject, $text, @rest) = @_;
		my $mailprog = '/usr/sbin/sendmail';
		my $date = `/bin/date`; 
		chop ($date);
		local (*FEHLERMAIL);

		open (FEHLERMAIL, "|$mailprog -oi -t -odq") || die "Can't open $mailprog \n";
		print FEHLERMAIL <<__END_FEHLERMAIL__;
From: $from
To: $to
CC: $cc
Subject: $subject

$text
__END_FEHLERMAIL__

		close (FEHLERMAIL);
		return(1);
}

sub reportmail {
	my ($from,$to,$cc,$subject,$text,$anhdat,$anhcont,$anhpdfdat,$anhpdfcont,$anhdat2,$anhcont2,$encoding,@rest) = @_;
	## neu: Format uebergeben fuer Anh1 u. Anh3 falls BASE64 gewuenscht;
	## Wahl zwischen logischer 2er und 3er Uebergabe (mittlerer Anhang ist PDF)
	## '10' = Anh1=Base64, Anh3!Base64 // '001' = Anh1!Base64, Anh3=Base64 // '1' = Anh1=Base64, Anh3!Base64
	if ($main::query{'modul'} eq 'HUN') {
		#&reportmail2(&innomail('TH'),&innomail('TH'),'',"reportmail-encoding-par","[$encoding]");
	}

#	if (($main::query{'user'} eq 'THOFMANN') && (substr($main::query{'gesnr'},-3) eq '515')) {
#		#&reportmail2(&innomail('TH'),&innomail('TH'),'',"reportmail-encoding-par","[$encoding]");
#		$text .= "\n\n VORHER anhdat[$anhdat]--anhcont(".length($anhcont).")--anhpdfdat[$anhpdfdat]--anhpdfcont(".
#		length($anhpdfcont).")--anhdat2[$anhdat2]--anhcont2(".length($anhcont2).")--anhpdfcont:".substr($anhpdfcont,0,5);
#	}

	my $sicpdf = $anhpdfcont;
	if (substr($anhpdfcont,0,4) eq '%PDF') { $anhpdfcont = MIME::Base64::encode($anhpdfcont);} 

#	if (($main::query{'user'} eq 'THOFMANN') && (substr($main::query{'gesnr'},-3) eq '515')) {
#		#&reportmail2(&innomail('TH'),&innomail('TH'),'',"reportmail-encoding-par","[$encoding]");
#		$text .= "\n\n anhdat[$anhdat]--anhcont(".length($anhcont).")--anhpdfdat[$anhpdfdat]--anhpdfcont(".
#		length($anhpdfcont).")--anhdat2[$anhdat2]--anhcont2(".length($anhcont2).")--anhpdfcont:".substr($anhpdfcont,0,5);
#	}

	my ($encoding1,$encoding2) = (0,0);
	my ($encod1,$encod2) = ('ISO-8859-1','ISO-8859-1');
	if ($encoding ne '') {
		$encoding1=substr($encoding,0,1);
		if ((length($encoding)==2) || (length($encoding)==3)) {
			$encoding2 = substr($encoding,-1);
		}
		my $encblock = <<__ENCBLOCK__;
		encoding: [$encoding]
		encoding1: [$encoding1]
		encoding2: [$encoding2]
__ENCBLOCK__
		#&reportmail2(&innomail('TH'),&innomail('TH'),'',"reportmail-encoding",$encblock);
	}
		my $mailprog = '/usr/sbin/sendmail';
		#my $date = `/bin/date`; 
		#chop ($date);
		#local (*REPORTMAIL); ## will kein local drin haben, geht nicht mit my
	my $boundary = "Message-Boundary-innosystems";

		open (REPORTMAIL, "|$mailprog -oi -t -odq") || die "Can't open $mailprog \n";
		print REPORTMAIL <<__END_REPORTMAIL__;
From: $from
To: $to
CC: $cc
Subject: $subject
X-Accept-Language: de
MIME-Version: 1.0
Content-type: Multipart/mixed;
	boundary=$boundary


--$boundary
Content-Type: text/plain
Content-description: Report
Content-transfer-encoding: ISO-8859-1

$text

__END_REPORTMAIL__

		if (($anhdat) && ($anhcont)) {
			if ($encoding1) {$encod1='base64';$anhcont=MIME::Base64::encode($anhcont);}
			print REPORTMAIL <<__END_REPORTMAIL_ANH__;
--$boundary
Content-type: text/plain; name=\"$anhdat\";
Content-Transfer-Encoding: $encod1
Content-disposition: attachment; filename=\"$anhdat\" 

$anhcont

__END_REPORTMAIL_ANH__

		}

		if (($anhpdfdat ne '') && ($anhpdfcont ne '')) {
			# doch pruefen, ob schon encoded?
			if ($anhpdfcont =~ m/^\%PDF/s) { # sonst wenn bereits encoded ist der Beginn JVBER
#				reportmail2(innomail('TH'),innomail('TH3'),'',"sniver.pm: reportmail: PDF noch NICHT encoded",
#				 "Laenge:".length($anhpdfcont)." Beginn:".substr($anhpdfcont,0,5));
				$anhpdfcont = MIME::Base64::encode($anhpdfcont);
			} else {
#				reportmail2(innomail('TH'),innomail('TH3'),'',"sniver.pm: reportmail: PDF SCHON encoded",
#				 "Laenge:".length($anhpdfcont)." Beginn:".substr($anhpdfcont,0,5));
			}
			print REPORTMAIL <<__END_REPORTMAIL_PDF__;
--$boundary
Content-Type: application/pdf; name=\"$anhpdfdat\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$anhpdfdat\" 

$anhpdfcont

__END_REPORTMAIL_PDF__

		}

		if (($anhdat2) && ($anhcont2)) {
			if ($encoding2) {$encod2='base64';$anhcont2=MIME::Base64::encode($anhcont2);}
			print REPORTMAIL <<__END_REPORTMAIL_ANH2__;
--$boundary
Content-type: text/plain; name=\"$anhdat2\";
Content-Transfer-Encoding: $encod2
Content-disposition: attachment; filename=\"$anhdat2\" 

$anhcont2

__END_REPORTMAIL_ANH2__

		}

		close (REPORTMAIL);
		return(1);
}

sub reportmail2 {
	my ($from,$to,$cc,$subject,$text,$anhdat,$anhcont,$anhpdfdat,$anhpdfcont,$anhdat2,$anhcont2,$encoding,@rest) = @_;
	#reportmail2 noch anpassen auf base64?
	my ($encoding1,$encoding2) = (0,0);
	my ($encod1,$encod2) = ('ISO-8859-1','ISO-8859-1');
	if ($encoding ne '') {
		$encoding1=substr($encoding,0,1);
		if ((length($encoding)==2) || (length($encoding)==3)) {
			$encoding2 = substr($encoding,-1);
		}
	}

		my $mailprog = '/usr/sbin/sendmail';
		my $date = `/bin/date`; 
		chop ($date);
		local (*FEHLERMAIL2);
	my $boundary = "Message-Boundary-innosystems";

		open (FEHLERMAIL2, "|$mailprog -oi -t -odq") || die "Can't open $mailprog \n";
		binmode FEHLERMAIL2;
		print FEHLERMAIL2 <<__END_REPORTMAIL2__;
From: $from
To: $to
CC: $cc
Subject: $subject
X-Accept-Language: de
MIME-Version: 1.0
Content-type: Multipart/mixed;
	boundary=$boundary


--$boundary
Content-Type: text/plain
Content-description: Report
Content-transfer-encoding: ISO-8859-1

__END_REPORTMAIL2__

		print FEHLERMAIL2 $text;
		print FEHLERMAIL2 "\n\n";



		if (($anhdat) && ($anhcont)) {
			if ($encoding1) {$encod1='base64';$anhcont=MIME::Base64::encode($anhcont);}
			print FEHLERMAIL2 <<__END_REPORTMAIL_ANH_2__;
--$boundary
Content-type: text/plain; name=\"$anhdat\";
Content-Transfer-Encoding: $encod1
Content-disposition: attachment; filename=\"$anhdat\" 

__END_REPORTMAIL_ANH_2__

			print FEHLERMAIL2 $anhcont;
			print FEHLERMAIL2 "\n\n";


		}

		if (($anhpdfdat) && ($anhpdfcont)) {
			if ($anhpdfcont =~ m/^\%PDF/s) { # sonst wenn bereits encoded ist der Beginn JVBER
				$anhpdfcont = MIME::Base64::encode($anhpdfcont);
			}
			print FEHLERMAIL2 <<__END_REPORTMAIL_PDF2__;
--$boundary
Content-Type: application/pdf; name=\"$anhpdfdat\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$anhpdfdat\" 

__END_REPORTMAIL_PDF2__

			print FEHLERMAIL2 $anhpdfcont;
			print FEHLERMAIL2 "\n\n";


		}

		if (($anhdat2) && ($anhcont2)) {
			if ($encoding2) {$encod2='base64';$anhcont2=MIME::Base64::encode($anhcont2);}
			print FEHLERMAIL2 <<__END_REPORTMAIL_ANH2_2__;
--$boundary
Content-type: text/plain; name=\"$anhdat2\";
Content-Transfer-Encoding: $encod2
Content-disposition: attachment; filename=\"$anhdat2\" 

__END_REPORTMAIL_ANH2_2__

			print FEHLERMAIL2 $anhcont2;
			print FEHLERMAIL2 "\n\n";


		}

		close (FEHLERMAIL2);
		return(1);
}

sub PDF3mail {
	my ( $from, $to, $cc, $subject, $text, $anh1nam, $anh1cont, $anh2nam, $anh2cont, $anh3nam, $anh3cont, @rest ) = @_;
	## 3 PDF
	## Format alle BASE64

	my $mailprog = '/usr/sbin/sendmail';

	my $boundary = "Message-Boundary-innosystems";

		open (PDF3MAIL, "|$mailprog -oi -t -odq") || die "Can't open $mailprog \n";
		print PDF3MAIL <<__END_PDF3MAIL__;
From: $from
To: $to
CC: $cc
Subject: $subject
X-Accept-Language: de
MIME-Version: 1.0
Content-type: Multipart/mixed;
	boundary=$boundary


--$boundary
Content-Type: text/plain
Content-description: Report
Content-transfer-encoding: ISO-8859-1

$text

__END_PDF3MAIL__

		if (($anh1nam) && ($anh1cont)) {
			
			if ($anh1cont =~ m/^\%PDF/s) { # doch pruefen, ob schon encoded? # sonst wenn bereits encoded ist der Beginn JVBER
				$anh1cont = MIME::Base64::encode($anh1cont);
			}
			print PDF3MAIL <<__END_REPORTMAIL_PDF1__;
--$boundary
Content-Type: application/pdf; name=\"$anh1nam\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$anh1nam\" 

$anh1cont

__END_REPORTMAIL_PDF1__

		}

		if (($anh2nam) && ($anh2cont)) {
			
			if ($anh2cont =~ m/^\%PDF/s) { # doch pruefen, ob schon encoded? # sonst wenn bereits encoded ist der Beginn JVBER
				$anh2cont = MIME::Base64::encode($anh2cont);
			}
			print PDF3MAIL <<__END_REPORTMAIL_PDF2__;
--$boundary
Content-Type: application/pdf; name=\"$anh2nam\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$anh2nam\" 

$anh2cont

__END_REPORTMAIL_PDF2__

		}

		if (($anh3nam) && ($anh3cont)) {
			
			if ($anh3cont =~ m/^\%PDF/s) { # doch pruefen, ob schon encoded? # sonst wenn bereits encoded ist der Beginn JVBER
				$anh3cont = MIME::Base64::encode($anh3cont);
			}
			print PDF3MAIL <<__END_REPORTMAIL_PDF3__;
--$boundary
Content-Type: application/pdf; name=\"$anh3nam\"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$anh3nam\" 

$anh3cont

__END_REPORTMAIL_PDF3__


		}

		close (PDF3MAIL);
		return(1);
}


sub laendercodedat {
	return 'laender-code.dat';
}

sub hunderassedat {
	return 'hunderasse.dat';
}

sub hunderassedat2 {
	return 'hunderassen.csv';
}

sub berufenvdat {
	return 'berufe-nv.dat';
}
sub berufenvdatneu {
	my $PATH_SSL = PATH_SSL();
	my $path = $PATH_SSL . 'cgi-bin/out/';
	#return ($path . 'nvberufneu.csv');
	return ('nvberufneu.csv'); # ist noch alt, immer in out, wird in getberufemitid schon selbst eingestellt
}

sub berufehkddat {
	return 'berufe-hkd.dat';
}
sub beruferhiondat {
	return 'berufe-rhion.dat';
}
sub berufeunfallcsvdat {
	my $PATH_SSL = PATH_SSL();
	my $path = $PATH_SSL . 'cgi-bin/import_tables/'; # Serverumstellung vor 27.05.2013, vorher import2002
	return($path . 'unfallberufe.csv');
}

# berufeGothaerDat siehe gothaer


sub landvoncode {
	my ($code, @rest) = @_;

	## HOF 07.11.2008; Herr Bayer moechte dass die benutzten Textdateien nicht mehr .txt heissen, 
	## 	weil diese nicht mehr bei Server-Kopien mitgenommen werden
	#my $lcodedat = 'laender-code.txt';
	my $lcodedat = &laendercodedat();

	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	## so
	my $PATH_OUT = $PATH_SSL . 'cgi-bin/out';
	my $datnam = $PATH_OUT. '/' . $lcodedat;

	## oder so
	#my ($isunix, $slash) = &isunixundslash();
	#my $aktdir = &nurpfad($0);
	#my $aktdir = &nurpfad($aktdir);

	## HOF 07.11.2008; Herr Bayer moechte dass die benutzten Textdateien nicht mehr .txt heissen, 
	## 	weil diese nicht mehr bei Server-Kopien mitgenommen werden
	# #my $lcodedat = 'laender-code.txt';
	#my $lcodedat = &laendercodedat();
	#my $datnam = "$aktdir$slash" . "out$slash$lcodedat";

	local (*LANDVONCODEDAT);
	my $from = &innomail('TH');
	my $to = $from;
	
	if (!open(LANDVONCODEDAT, $datnam)) {
		&fehlermail(
			$from, $to, '', "Fehler landvoncode: Kann Laender-Code LANDVONCODEDATei nicht lesen",
			"Die Laender-Code LANDVONCODEDATei kann nicht gelesen werden: [$datnam]"
		);
		return($code);
	}
	my @lcode = <LANDVONCODEDAT>;
	close (LANDVONCODEDAT);
	my (%lcode, $lcode, $iscode);
	allecodes:
	foreach $lcode (@lcode) {
		$lcode =~ s/[\r\n]+$//;
		if ( $lcode =~ m/^([0-9]+)\t(.*?)$/) {
			if ($code == $1) {
				$iscode = $2;
				last allecodes;
			}
		}
	}
	return ($iscode);
}

sub jahrplus {
	## Datum im Format TT.MM.TTTT
	## zum Datum x Jahre dazu
	my ($datu, $plus, @rest) = @_;
	
	my ($tt, $mm, $j) = split (/\./, $datu, 3);
	$j += $plus;
	return( join("\.", $tt, $mm, $j) );
}

sub jahrdiff {
	## Datum im Format TT.MM.TTTT
	## Differenz Jahre zwischen zwei Datumsangaben
	## Vorsicht, wuerde vom 31.12.2008 zum 01.01.2009 auch 1 Jahr Differenz zurueckgeben
	my ($datu, $bisdatu, @rest) = @_;
	$datu = &date2us($datu);
	$bisdatu = &date2us($bisdatu);
	($datu, $bisdatu) = sort ($datu, $bisdatu);
	my ($j, $mm, $tt) = split (/\-/, $datu, 3);
	my ($j2, $m2, $t2) = split (/\-/, $bisdatu, 3);
	return( $j2 - $j );
}

sub encode_base64 ($;$){
                 my $res = "";
                 my $eol = $_[1];
                 $eol = "\n" unless defined $eol;
                 pos($_[0]) = 0;                          # ensure start at the beginning
                 while ($_[0] =~ /(.{1,45})/gs) {
                          $res .= substr(pack('u', $1), 1);
                          chop($res);
                 }
                 $res =~ tr|` -_|AA-Za-z0-9+/|;               # # help emacs
                 # fix padding at the end
                 my $padding = (3 - length($_[0]) % 3) % 3;
                 $res =~ s/.{$padding}$/'=' x $padding/e if $padding;
                 # break encoded string into lines of no more than 76 characters each
                 if (length $eol) {
                          $res =~ s/(.{1,76})/$1$eol/g;
                 }
                 $res;
}

sub codesyntax {
	my ($code, @rest) = @_;
	
	## Code umwandeln
	$code =~ s/</\&lt;/gs;
	$code =~ s/>/\&gt;/gs;
	$code =~ s/\n/\n<br>/gs;
	$code =~ s/(<br>) /$1\&nbsp;/gs;
	$code =~ s/(\&nbsp;)        /$1\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)        /$1\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)        /$1\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)    /$1\&nbsp;\&nbsp;\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)    /$1\&nbsp;\&nbsp;\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)    /$1\&nbsp;\&nbsp;\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)  /$1\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)  /$1\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;)  /$1\&nbsp;\&nbsp;/gs;
	$code =~ s/(\&nbsp;) /$1\&nbsp;/gs;
	$code =~ s/(\&nbsp;) /$1\&nbsp;/gs;
	$code =~ s/(\&nbsp;) /$1\&nbsp;/gs;
	$code =~ s/\t/<nobr> \&nbsp; \&nbsp; <\/nobr>/gs;

	## syntax highligting

	## Kommentare
	#$code =~ s/(\&lt;!--)(.*?)(--\&gt;)/<font color=grey class=comments>\1\2\3<\/font>/g;
	## Kommentare harte Version
	$code =~ s/(\&lt;!--)/<font color=grey class=comments>$1/g;
	$code =~ s/(--\&gt;)/$1<\/font>/g;

	## Tag-Namen
	$code =~ s/\&lt;(\/?)([a-z0-9\.\_\:]+)([ >]|\&gt;)/\&lt;<font color=blue class=tagname>$1$2<\/font>$3/gsi;
	
	## alle Tags von Beginn bis Ende
	#$code =~ s/(\&lt;)/<font color=darkcyan>\1<\/font>/gs;
	#$code =~ s/(\&gt;)/<font color=darkcyan>\1<\/font>/gs;
	$code =~ s/(\&lt;)/<font color=darkcyan class=tags>$1/gs;
	$code =~ s/(\&gt;)/$1<\/font>/gs;
	
	## Attribute
	$code =~ s/(<\/font>|") ([a-z0-9\.\_\:]+)=/$1 <font color=brown class=attrname>$2<\/font>=/gsi;
	$code =~ s/(<\/font>=")([^"]+)"/$1<font color=green class=attrval>$2<\/font>"/gsi;
	
	## sicherheitshalber ein paar schliessende font
	$code .= "</font></font></font>";
	
	## das mit den Kommentaren funktioniert nicht gut, wenn Tags in den Kommentaren stehen
	## 	am besten zwischen Kommentar Anfang und Ende alle Formatierung raus.
	my $i;
	my $commstart = '<font color=grey class=comments>';
	my $commend = "--\&gt;";
	my ($commstartp, $commendp, $comment);
	## Achtung: vorher '--</font>&gt;' /font rausnehmen
	$code =~ s#--</font>&gt;#--&gt;#g;
	## nochmal Achtung: Auch Anfang von comments die falschen fonts raus
	## erstmal anders, bei comments gar nicht erst Formatierung rein
	#$code =~ s/\&lt;<font color=blue class=tagname>([a-z0-9\.\_\:]+)([ >]|\&gt;)/\&lt;<font color=blue class=tagname>\1\2<\/font>\3/gsi;
	allecomments:
	while (
		( ($commstartp = index($code, $commstart, $i)) > -1 )
	) {
		if ( ($commendp = index($code, $commend, $commstartp)) < 0 ) { last allecomments; }
		$comment = substr($code, $commstartp + length($commstart), $commendp - ($commstartp + length($commstart)) );
		#&webreport("--- comment vorher ---<br>" . $comment);
		$comment =~ s#(<font[^>]*>|<\/font>)##g; 
		#&webwarnung("--- comment nachher ---<br>" . $comment);
		#$comment =~ s#(<font[^>]*>)##g; 
		substr($code, $commstartp + length($commstart), $commendp - ($commstartp + length($commstart)) ) = $comment;
		$i = $commstartp + length($commstart);
	}
	
	$code = "<tt class=codealles>$code<\/tt>";
	
	return ($code);
}

sub getfile {
	my ($filepath, @rest) = @_;
	my $content = undef;
	my $orgein = $/;
	local (*GETFILEDAT);
	
	if (!open(GETFILEDAT, $filepath)) {
		return ($content);
	}
	undef ($/);
	binmode(GETFILEDAT);
	$content = <GETFILEDAT>;
	close (GETFILEDAT);
	$/ = $orgein;
	
	return ($content);
}

sub setquery {
	## das query setzen aus einer Datei.
	## a) aus einer Textdatei immer: Key Tabulator Value
	## b) aus einer html-Datei mit 1(!) zweispaltigen Tabelle, 
	## 	jede Tabellenzeile muss in einer Zeile stehen, 
	## 	keine Leerzeichen/Tabz zwischen Tags
	## 	keine TH (werden ueberlesen)
	## 	keine < und > in key, werden entfernt
	## 	value kann tags enthalten, dann darf aber der value innerhalb der Tabelle nicht mit Tags umschlossen werden
	## der Unterschied wird an der Endung 'txt' oder 'htm' oder 'html' erkannt
	my ($datnam, @rest) = @_;
	if (!$datnam) {return('');}
	if ($datnam !~ m/\.(txt|htm|html)$/i) {return('');}
	my ($istxt, $ishtml);
	if ($datnam =~ m/\.txt$/i) {
		$istxt = 1;
	} elsif ($datnam =~ m/\.html?$/i) {
		$ishtml = 1;
	}
	local (*SETQUERYDAT);
	if (!open(SETQUERYDAT, $datnam)) {
		return('');
	}
	my @zeilen = <SETQUERYDAT>;
	close(SETQUERYDAT);
	my ($z, $k, $v, $anz);
	allezeilensetquery:
	foreach $z (@zeilen) {
		$z =~ s/[\r\n]//g;
		if ($istxt) {
			if ($z !~ m/^([^\t]+)\t(.*?)$/) { 
				next allezeilensetquery;
			}
			($k, $v) = ($1, $2);
		} elsif ($ishtml) {
			if ($z !~ m/<tr[^>]*><td[^>]*>(.*?)<\/td><td[^>]*>(.*?)<\/td><\/tr>/i) { 
				next allezeilensetquery;
			}
			($k, $v) = ($1, $2);
			$k =~ s/<[^>]+>//ig;
			## value kann tags enthalten, dann darf aber der value innerhalb der Tabelle nicht mit Tags umschlossen werden
			#$v =~ s/<[^>]+>//ig;
		} else {
			next allezeilensetquery;
		}
		$main::query{$k} = $v;
		$anz++;
	}
	return ($anz);
}

sub writefile {
	my ($dirdat, $cont, $rights, @rest) = @_;
	my ($mes, $tit, $len);
	local (*WRITEFILEDAT);
	my ($from, $to, $cc) = (&innomail('TH'), &innomail('TH'), '');
	my $host = $ENV{'HTTP_HOST'};
	if ( !$host ) { $host = $ENV{'SERVER_NAME'} };

	if (!open(WRITEFILEDAT, ">$dirdat")) {
		$tit = "writefile: Kann Datei nicht schreiben";
		$mes = "$tit [$dirdat].\n  - HTTP_HOST:[$host]";
		#&webwarnung($mes);
		&fehlermail($from, $to, '', $tit, $mes);
		return ('');
	}
	binmode(WRITEFILEDAT);
	print WRITEFILEDAT $cont;
	close(WRITEFILEDAT);
	if ($rights) {
		$rights = $rights =~ m/^\d{3}$/i ? "0$rights" : $rights ;
		my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
		 $atime,$mtime,$ctime,$blksize,$blocks)
			 = stat($dirdat);
		my $right = sprintf "%04o", $mode & 07777; $right = substr( $right, -3 ); #gehe davon aus, dass immer oktal 3 Stellen uebergeben wird.
		if ( substr($rights, -3) ne $right ) {
			$len = chmod (oct("$rights"), $dirdat);
			if ($len < 1) {
				$tit = "writefile: Kann Datei-Attribute nicht aendern";
				$mes = "$tit [$rights][$dirdat]  - HTTP_HOST:[$host].";
				#&webwarnung($mes);
				&fehlermail($from, $to, '', $tit, $mes);
			}
		}
	}
	$len = length($cont);
	if ($len) { return($len); }
	else { return(1); }
}

sub hunderasse {
	my ($code, @rest) = @_;

	## HOF 07.11.2008; Herr Bayer moechte dass die benutzten Textdateien nicht mehr .txt heissen, 
	## 	weil diese nicht mehr bei Server-Kopien mitgenommen werden
	#my $hundedat = 'hunderasse.txt';
	my $hundedat = &hunderassedat();

	## so
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my $PATH_OUT = $PATH_SSL."cgi-bin/out";
	my $datnam = "$PATH_OUT/$hundedat";

	## oder so
	#my ($isunix, $slash) = &isunixundslash();
	#my $aktdir = &nurpfad($0);
	#my $aktdir = &nurpfad($aktdir);
	#my $datnam = "$aktdir$slash" . "out$slash$hundedat";

	local (*HUNDERASSEDAT);
	my $from = &innomail('TH');
	my $to = $from;
	
	if (!open(HUNDERASSEDAT, $datnam)) {
		&fehlermail(
			$from, $to, '', "Fehler hunderasse: Kann Hunde-Code Datei nicht lesen",
			"Die Hunde-Code Datei kann nicht gelesen werden: [$datnam]"
		);
		return($code);
	}
	my @hcode = <HUNDERASSEDAT>;
	close (HUNDERASSEDAT);
	my (%hcode, $hcode, $iscode);
	allecodes:
	foreach $hcode (@hcode) {
		$hcode =~ s/[\r\n]+$//;
		if ( $hcode =~ m/^([0-9]+)\t(.*?)$/) {
			if ($code == $1) {
				$iscode = $2;
				last allecodes;
			}
		}
	}
	return ($iscode);
}

sub hunderasse2 {
	my ($code, @rest) = @_;
	## HOF 08.11.2011; andere Datei fuer die aktuelle Hundemaske
	my $hundedat = &hunderassedat2();
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my $PATH_IMPORT = $PATH_SSL."cgi-bin/import_tables"; # Serverumstellung vor 27.05.2013, vorher: import2002
	my $datnam = "$PATH_IMPORT/$hundedat";

	#local (*HUNDERASSEDAT);
	my $from = &innomail('TH');
	my $to = $from;
	
	if (!open(HUNDERASSEDAT2, $datnam)) {
		&fehlermail(
			$from, $to, '', "Fehler hunderasse: Kann Hunde-Code Datei nicht lesen",
			"Die Hunde-Code Datei kann nicht gelesen werden: [$datnam]"
		);
		return($code);
	}
	my @hcode = <HUNDERASSEDAT2>;
	close (HUNDERASSEDAT2);
	my (%hcode, $hcode, $iscode);
	my $hundhead = shift(@hcode); # header entfernen: IND;HUNDERASSE;KAMPFHUND;Reserve;muh
	my ($rasse2,$kampfhund2,@hund2line,$aktrasse);
	allecodes2:
	foreach $hcode (@hcode) {
		$hcode =~ s/[\r\n]+$//;
		@hund2line = split(/[;\t]/, $hcode);
		if ( $hund2line[0] =~ m/^([0-9]+)$/) {
			# Mist, in Mischling kommt der Code und in Hunderasse aber der Name.
			$aktrasse = $hund2line[1];
			if ($code =~ m/^$aktrasse$/) {
				$rasse2 = $code;
				$kampfhund2 = $hund2line[2];
				last allecodes2;
			}
			if ($code == $hund2line[0]) {
				$rasse2 = $hund2line[1];
				$kampfhund2 = $hund2line[2];
				last allecodes2;
			}
			
		}
	}
	# es laesst sich die Rueckgabe immer noch auf $kampfhund2 pruefen, wenn leer, dann "nichts gefunden"
	if (!($rasse2)) { $rasse2 = $code; }
	return ($rasse2,$kampfhund2);
}

sub queryland {
	## HOF festgestellt um den 23.09.2008, war in den ganzen alten sub html() drin, fehlt jetzt
	## 	besser zentral festlegen oder?
	## 	oder nur dann belegen (fuer mich), wenn ich es brauche?

	if ($main::query{'land'} eq '') {
		if ($main::query{'NATIONALITAETVN'} eq 'Deutschland') {
			$main::query{'land'} = 'D';
		} elsif ($main::query{'NATIONALITAETVN'}) {
			$main::query{'land'} = substr($main::query{'NATIONALITAETVN'}, 0, 1);
			if ($main::query{'land'} eq 'D') {
			## 'D' aber nicht Deutschland
				$main::query{'land'} = 'X';
			}
		} else {
			$main::query{'land'} = 'D';
		}
	}
}

sub getberufe {
	my ($datnam, @rest) = @_;
	## 	$PATH_SSL soll immer stimmen, oder selbst rein schreiben
	if (!$datnam) { return(); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	#my $aktdir = $PATH_SSL . "cgi-bin/vers2002/";
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	#my $thvarsdat = "$aktdir$slash$thvarsdatnam";
	my $berufedat = "$aktdir$datnam";
	my %berufe = ();
	my $line;
	my $errmail = &innomail('TH');
	local (*BERUF);
	
	if ( !(open(BERUF, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getberufe: $mess";
		my $mailtext = "$subj [$berufedat].";
		#&webwarnung($mailtext); #-- hier total abbrechen?
		&fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (%berufe);
	} else {
		my @lines = <BERUF>;
		close(BERUF);
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/^([^\t]+)\t(.*?)$/i) {
				$berufe{$1} = $2;
			}
		}
		#-- cool! fertig!
	}
	
	return(%berufe);
}

sub getberufesemi { # semi == Semikolon  != Komma  != TAB
	my ($datnam, $from, $to, @rest) = @_;
	## 	$PATH_SSL soll immer stimmen, oder selbst rein schreiben
	if (!$datnam) { return(); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	#my $aktdir = $PATH_SSL . "cgi-bin/vers2002/";
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	#my $thvarsdat = "$aktdir$slash$thvarsdatnam";
	my $berufedat = "$aktdir$datnam";
#	$berufedat = $datnam if ($datnam =~ m|\/\\|s);
	if ($datnam =~ m|[\/\\]|s) {
		$berufedat = $datnam;
		#print "datnam matcht slash berufedat:[$berufedat]\n";
	} else {
		#print "datnam matcht NICHT slash berufedat:[$berufedat]\n";
	}
	#print "Datei: [$datnam]\n";
	my %berufe = ();
	my $line;
	my $errmail = &innomail('TH');
	$from = $errmail if !$from;
	$to   = $errmail if !$to;
	local (*BERUF);
	
	if ( !(open(BERUF, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getberufesemi: $mess";
		my $mailtext = "$subj [$berufedat].";
		#webwarnung($mailtext); #-- hier total abbrechen?
		#print ($mailtext); #-- hier total abbrechen?
		&fehlermail($from, $to, '', $subj, $mailtext);
		return (%berufe);
	} else {
		my @lines = <BERUF>;
		close(BERUF);
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/^([^\t;]+);(.*?)$/i) {
				$berufe{$1} = $2;
			}
		}
		#-- cool! fertig!
	}
	
	return(%berufe);
}

sub getberufemitid {
	my ($datnam, $idnam, $idgef, @rest) = @_;
	# Vars: $idnam, $idgef sind uebergebene hashref, return faellt weg, nur undef/1
	if (!$datnam) { return(); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	#my $aktdir = $PATH_SSL . "cgi-bin/vers2002/";
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	my $berufedat = "$aktdir$datnam";
	#my %berufe = ();
	my $line;
	my $errmail = &innomail('TH');
	
	if ( !(open(BERUFMITID, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getberufemitid: $mess";
		my $mailtext = "$subj [$berufedat].";
		#&webwarnung($mailtext); #-- hier total abbrechen?
		&fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (undef); # 
	} else {
		my @lines = <BERUFMITID>;
		close(BERUFMITID);
		my ($key,$bez,$gef);
		berufmitidzeile:
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/(gefahr(en)?gruppe|bezeichnung)/i) { next berufmitidzeile; }
			if ($line =~ m/^([^\t;]+)[\t;]([^\t;]+)[\t;](.*?)$/i) {
				($key,$bez,$gef) = ($1,$2,$3);
				if (length($bez) <=2) {$bez = '_leer_';$gef='C';} # next berufmitidzeile;
				if ((length($gef) >1) || (length($gef) <1)) {$gef='C';} # next berufmitidzeile;
				$$idgef{$key} = $gef; # $3
				$$idnam{$key} = $bez; # $2
			}
		}
	}
	
	return(1);
}

sub getberufemitid_allianz {
	my ($datnam, @rest) = @_;
	# Vars: return hash
	my %berufe_hash;
	if (!$datnam) { return(); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	my $berufedat = "$aktdir$datnam";
	#my %berufe = ();
	my $line;
	my $errmail = &innomail('TH');
	
	if ( !(open(BERUFMITID, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getberufemitid_allianz: $mess";
		my $mailtext = "$subj [$berufedat].";
		#&webwarnung($mailtext); #-- hier total abbrechen?
		&fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (undef); # 
	} else {
		my @lines = <BERUFMITID>;
		close(BERUFMITID);
		my ($key,$bez);
		berufmitidzeile:
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/(gefahr(en)?gruppe|bezeichnung)/i) { next berufmitidzeile; }
			if ($line =~ m/^([^\t;]+)[\t;]([^\t;]+)[\t;]?(.*?)$/i) {
				($key,$bez) = ($1,$2);
				if (length($bez) <=2) {$bez = '_leer_';} # next berufmitidzeile;
				#if ((length($gef) >1) || (length($gef) <1)) {$gef='C';} # next berufmitidzeile;
				$berufe_hash{$key} = $bez; # $2
			}
		}
	}
	
	return(%berufe_hash);
}

sub getberufemitid2 {
	# bezieht sich auf Standard-Datei von TS in import2002/unfallberufe.csv
	#   siehe berufeunfallcsvdat
	# Format: id;bezeichnung;risiko;gruppe;NDX
	my ($datnam, $idnam, $idgef, @rest) = @_;
	my $sicdatnam = $datnam;
	# Vars: $idnam, $idgef sind uebergebene hashref, return faellt weg, nur undef/1
	if (!$datnam) { return(); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	#my $aktdir = $PATH_SSL . "cgi-bin/vers2002/";
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	$aktdir = $PATH_SSL . "cgi-bin/import_tables/"; # Serverumstellung vor 27.05.2013, vorher import2002
	if ($datnam =~ m|\/|) {
		($aktdir, $datnam) = pfadunddat($datnam);
		if ($aktdir !~ m|\/$|) { $aktdir .= '/'; }
	}
	my $berufedat = "$aktdir$datnam";
	#my %berufe = ();
	my $line;
	my $errmail = &innomail('TH');
	
	if ( !(open(BERUFMITID, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getberufemitid: $mess";
		my $mailtext = "$subj [$berufedat].";
		#&webwarnung($mailtext); #-- hier total abbrechen?
		&fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (undef); # 
	} else {
		my @lines = <BERUFMITID>;
		close(BERUFMITID);
		berufmitidzeile2:
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/gefahr(en)?gruppe|bezeichnung/i) { next berufmitidzeile2; }
			#				id;bezeichnung;risiko;gruppe;NDX
			if ($line =~ m/^([^;]+);([^;]+);([^;]+);([^;]+);(.*?)$/i) {
				$$idgef{$1} = $3;
				$$idnam{$1} = $2;
			}
		}
	}
	
	return(1);
}

sub berufe2key {
	## unguenstig, da ich die Zuordnung auch gleich machen koennte, besser zweite Routine mit Rueckgabe Hash
	my @berufe = @_;
	my ($b, $k, @key, $i);
	## for wegen gleicher Reihenfolge, also vorher selber sortieren
	for ($i=0; $i<=$#berufe; $i++) { push(@key, &makeid($berufe[$i])); }
	return(@key);
}

sub berufe2keyhash {
	my @berufe = @_;
	my ($b, $k, %key, $i);
	## Achtung! Hier koennen Werte (doppelte Keys) ueberschrieben werden und verloren gehen
	for( $i = 0; $i <= $#berufe; $i++) { $b = &makeid( $berufe[$i] ); $key{$b} = $berufe[$i]; }
	return(%key);
}

sub makeid {
	my ($str, @rest) = @_;
	my $id = (split(/[\r\n]/, $str))[0];
	$id =~ s/^[ \t]+//g;
	$id =~ s/[ \t]+$//g;

	$id =~ s/\xE4/ae/g;
	$id =~ s/\xF6/oe/g;
	$id =~ s/\xFC/ue/g;
	$id =~ s/\xC4/Ae/g;
	$id =~ s/\xD6/Oe/g;
	$id =~ s/\xDC/Ue/g;
	$id =~ s/\xDF/ss/g;

	#$id =~ s/[^a-z0-9]/./ig;
	#$id =~ s/\.\.+/./ig;
	
	return($id);
}

sub berufehtml {
	## erwartet Hash Beruf->zugeordneter_Wert
	## erzeugt Dropdown mit <option value="zugeordneter_Wert">Beruf</option>
	my %berufe = @_;
	my ($b, $k, @key, $i, $html, $temp);
	@key = sort(keys(%berufe));
	$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	for ($i=0; $i<=$#key; $i++) { 
		$temp = $berufe{$key[$i]};
		$html .= "\t\t<option value=\"$temp\">" . $key[$i] . "</option>\n";
	}
	$html .= "\t</select>\n";
	return($html);
}

sub berufehtml_allianz {
	## erwartet Hash Beruf->zugeordneter_Wert
	## erzeugt Dropdown mit <option value="zugeordneter_Wert">Beruf</option>
	my %berufe = @_;
	my ($b, $k, @key, $i, $html, $temp);
	@key = sort(keys(%berufe));
	$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	my $inputs;
	for ($i=0; $i<=$#key; $i++) { 
		$temp = $berufe{$key[$i]};
		$html .= "\t\t<option value=\"$temp\">" . $key[$i] . "</option>\n";
		#$inputs = "\t\t<input type=\"hidden\" name=\"BERUF_ALLIANZ\" value=\"" . $key[$i] . "\">\n";
	}
	$html .= "\t</select>\n";
	#$html .= $inputs;
	return($html);
}

sub berufehtml2 {
	## erwartet wird ein Hash aus Beruf (Name) und zugehoeriger Gefahrgruppe
	## baut HTML mit 2 Teilen: a) select (Beruf->ID = eindeutige Berufs-ID) - b) inputs mit Berufs-ID->Gefahrgruppe
	## kann man gebrauchen wenn ein javascript abfragen will welche Gefahrengruppe ein Beruf ist ueber Werte im HTML
	## Achtung! Kann das vorhande input bzw. name= ueberschreiben?
	my %berufegefahr = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	%berufe = &berufe2keyhash(keys(%berufegefahr));
	@key = sort(keys(%berufe));
	$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	for ($i=0; $i<=$#key; $i++) { 
		$html .= "\t\t<option value=\"$key[$i]\">" . $berufe{$key[$i]} . "</option>\n";
		$berufsid{$key[$i]} = $berufe{$key[$i]};
		$tempid = $berufsid{$key[$i]};
		$inputs .= "\t\t<input type=\"hidden\" name=\"$key[$i]\" value=\"" . $berufegefahr{$tempid} . "\">\n";
	}
	$html .= "\t</select>\n";
	$html .= $inputs;
	return($html);
}

sub berufehtml3 {
	## Kopie von berufehtml2; soll zusaetzlich schreiben: (unter "baut HTML")
	## erwartet wird ein Hash aus Beruf (Name) und zugehoeriger Gefahrgruppe
	## 	baut HTML mit 2 Teilen: a) select (Beruf->ID = eindeutige Berufs-ID) - b) inputs mit Berufs-ID->Gefahrgruppe
	## 	zusaetzlich c) inputs mit Berufs-ID->Berufname
	## kann man gebrauchen wenn ein javascript abfragen will welche Gefahrengruppe ein Beruf ist ueber Werte im HTML
	## Achtung! Kann das vorhande input bzw. name= ueberschreiben?
	my ($person,%berufegefahr) = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	%berufe = &berufe2keyhash(keys(%berufegefahr));
	@key = sort(keys(%berufe));
	#$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw&#xE4;hlen</option>\n";
	$html = "\t<select name=\"berufehtml\" onchange=\"checkberufe$person()\">\n\t\t<option value=\"\">bitte ausw&#xE4;hlen</option>\n";
	for ($i=0; $i<=$#key; $i++) { 
		$html .= "\t\t<option value=\"$key[$i]\">" . $berufe{$key[$i]} . "</option>\n";
		$berufsid{$key[$i]} = $berufe{$key[$i]};
		$tempid = $berufsid{$key[$i]};
		$inputs .= "\t\t<input type=\"hidden\" name=\"$key[$i]\" value=\"" . $berufegefahr{$tempid} . "\">\n";
		$inputs .= "\t\t<input type=\"hidden\" name=\"x.$key[$i]\" value=\"" . $berufe{$key[$i]} . "\">\n";
	}
	$html .= "\t</select>\n";
	$html .= $inputs if( $person == 1 ); # nur bei 1. Person, sonst alle hidden inputs doppelt.
	return($html);
}

sub berufehtml4 {
	## Kopie von berufehtml4; ich hab hier schon zwei Hashes: id->beruf; id->gefahr
	## erwartet werden zwei Hashref: id->beruf; id->gefahr
	## 	baut
	## 	a) select (Beruf->ID) 
	## 	b) inputs mit Berufs-ID->Gefahrgruppe
	## 	c) inputs mit Berufs-ID->Berufname
	## kann man gebrauchen wenn ein javascript abfragen will welche Gefahrengruppe ein Beruf ist ueber Werte im HTML
	## Achtung! Kann das vorhande input bzw. name= ueberschreiben?
	my ($person,$idberuf,$idgefahr,@rest) = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	# brauch ich nicht da schon uebergeben
	#%berufe = &berufe2keyhash(keys(%berufegefahr));
	#@key = sort(keys(%berufe));
	# Berufe nach Name sortieren
	my @ids = &hashsortvalkeyarray($idberuf);
	#$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw&#xE4;hlen</option>\n";
	$html = "\t<select name=\"berufehtml\" onchange=\"checkberufe$person()\">\n\t\t<option value=\"\">bitte ausw&#xE4;hlen</option>\n";
	berufehtml4zeilen:
	for ($i=0; $i<=$#ids; $i++) { 
		if ($ids[$i] =~ m/^[ \t]*$/i) { next berufehtml4zeilen; }
		$html .= "\t\t<option value=\"$ids[$i]\">" . $$idberuf{$ids[$i]} . "</option>\n";
		# Quatsch
		#$berufsid{$ids[$i]} = $$idberuf{$ids[$i]};
		#$tempid = $berufsid{$ids[$i]};
		$inputs .= "\t\t<input type=\"hidden\" name=\"g.$ids[$i]\" id=\"g.$ids[$i]\" value=\"" . $$idgefahr{$ids[$i]} . "\">\n";
		$inputs .= "\t\t<input type=\"hidden\" name=\"b.$ids[$i]\" id=\"b.$ids[$i]\" value=\"" . $$idberuf{$ids[$i]} . "\">\n";
	}
	$html .= "\t</select>\n";
	#$html .= $inputs;
	return($html,$inputs);
}

sub berufeHtmlSortID {
	## erwartet Hash Beruf->zugeordneter_Wert
	## erzeugt Dropdown mit <option value="zugeordneter_Wert">Beruf</option>
	## Besonderheit: Sortierung nach ID, also Beachtung Umlaute und Ignore-case
	my %berufe = @_;
	my ($k, @key, $i, $html, $temp, @ber, %key, @key2, $i); # $a, $b, 
	@ber = keys( %berufe );
	%key = berufe2keyhash( @ber );

	@key2 = keys( %key );
	@key = sort { lc( $a ) cmp lc( $b ) } @key2;

	$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	for ($i = 0; $i <= $#key; $i++) { 
		$temp = $berufe{ $key{ $key[$i] } };
		$html .= "\t\t<option value=\"$temp\">" . $key{ $key[$i] } . "</option>\n";
	}
	$html .= "\t</select>\n";
	return($html);
}


 sub hashsortvalkeyarray {
	my ($h,@rest) = @_; # erwarten hashref id->name
	# umdrehen
	my %v2k = &val2key(%$h);
	my @a = undef;
	my ($temp,$k,$v);
	foreach $v(sort(keys(%v2k))) { # in den keys stehen jetzt die namen
		push(@a,$v2k{$v});
	}
	return(@a); # ich returniere die nach Namen sortierten IDs
 }

sub satz_direkt_abgeschlossen {
	my $satz = "\n<p><b>Dieser Antrag wurde bei der Versicherung direkt eingereicht. </b></p>\n";
	return ($satz);
}

sub satz_unter_nummer_eingereicht {
	my ( $nr, $art, @rest ) = @_;
	if ( !$nr ) { return ''; }
#	print "<p> >>> sniver.pm: satz_unter_nummer_eingereicht: nr/art ($nr/$art)</p>\n" if $main::query{'user'} =~ /THOFMANN/i;
	$art =~ m/002/i;
	my ( $ges, $dieart ) = ( '', '' );
	if ( $main::query{'Gesellschaft'} ) { $ges = " $main::query{'Gesellschaft'} "; }
	if ( $art ) { 
		if ( $art eq '001' ) { $dieart = " (ProzessID) "; } # siehe Antragstracking
		elsif ( $art eq '002' ) { $dieart = " (VorgangsID) "; } 
		elsif ( $art eq '003' ) { $dieart = " (Versicherungsscheinnummer) "; } 
		else { $dieart = " ($art) "; }
	}
	my $satz = "\n<p>Der Antrag wurde bei der Gesellschaft $ges unter der Nummer $dieart $nr eingereicht. </p>\n";
	return ($satz);
}

sub satz_fehler_direkt_abgeschlossen {
	my ($satz, $isweitergeleitet, $aktion, @rest) = @_;
	my $suchsatz = "Dieser Antrag wurde bei der Versicherung direkt eingereicht.";
	my $suchwort = "direkt eingereicht";
	my $suchsatz1 = "Dieser Antrag wurde bei der Versicherung ";
	my $suchsatz2 = "direkt eingereicht.";
	## nicht gut
	#$satz =~ s/$suchsatz/<font color="#ff0000">$suchsatz<\/font>/i;
	$satz =~ s/$suchsatz1$suchsatz2/<font color="#ff0000">$suchsatz1 NICHT $suchsatz2<\/font>/i;
	if ($isweitergeleitet) {
		$satz =~ s/(<\/font>)/<br>Der Antrag wurde per E-Mail an die Gesellschaft zur manuellen Bearbeitung weitergeleitet.$1/i;
	}
	if ($aktion) {
		$satz =~ s/(<\/font>)/<br>$aktion$1/i;
	}
	return ($satz);
}

sub satz_fehler_direkt_abgeschlossen_mlp {
	my ($satz, @rest) = @_;
	my $suchsatz = "Dieser Antrag wurde bei der Versicherung direkt eingereicht.";
	my $ersetze = "Der Antrag konnte vom Versicherer nicht automatisch verarbeitet werden! Die Daten wurden zur manuellen Pr\&uuml;fung an den Versicherer weitergeleitet. Der Versicherungsschutz besteht im beantragten Umfang.";
	$satz =~ s/$suchsatz/<font color="#ff0000">$ersetze<\/font>/i;
	return ($satz);
}

sub errmailth {
	#return "thofmann\@innosystems.net";
	return(&innomail('TH'));
}

sub satzwebservicetest {
	my $loeschen = shift;
  	my $pre = "<p><b><i>Der folgende Satz &uuml;ber die Direktanbindung ist ein Test. " . 
  		"Die Versicherung ist noch nicht direkt angebunden aber in Vorbereitung.</i></b></p>\n";
  	if ($loeschen) {
  		$pre = "<p><b><i>Der folgende Satz &uuml;ber die Direktanbindung ist ein Test. " . 
  		"<font color=\"#ff0000\">Diese Email kann gelöscht werden!</font></i></b></p>\n";
  	}
  	return($pre);
}

sub satz_webservice_fehler {
	my ($phrase, $aktion, @rest) = @_;
	my $mess = "\n<p><b><font color=\"#ff0000\">Achtung, Fehler beim Webservice. " . 
		"Der Vertrag konnte nicht direkt abgeschlossen werden. " . 
		"Der Kunde sollte sich mit dem Makler und dieser mit der Versicherung in Verbindung setzen.</font></b></p>\n";
	if ($phrase) { $mess =~ s/(beim Webservice)/$1 ($phrase)/i;}
	if ($aktion) { $mess =~ s/(Der Kunde sollte sich mit dem Makler und dieser mit der Versicherung in Verbindung setzen.)/$aktion/i; }
	return $mess;
}


sub satz_vermittlernummer_fehlt {
	# EK: Rdmine 1713: "als von" -> "von"
	return("\n<p><b>Achtung: Die Vermittlernummer fehlt, der Vertrag wird bei der Versicherung von INNOFINANCE online eingereicht.</b></p>\n");
}

sub satz_kein_invitatio {
	return("\n<p><b>Die Versicherung bietet kein Modell Invitatio an. Der Makler muss den Invitatio Antrag selbst bearbeiten.</b></p>\n");
}

sub satz_kein_rechnung {
	my ($nurtarif, @rest) = @_;
	my $nurdieser;
	if ($nurtarif) { $nurdieser = ' bei diesem Tarif/dieser Zahlungsweise'; }
	return("\n<p><b><font color=\"#ff0000\">Die Versicherung bietet$nurdieser keine Zahlart '\xFCberweisen' an. " .
					"Bitte reichen Sie den Antrag noch einmal mit SEPA-Lastschrift ein.</font></b></p>\n");
}

sub satz_auswahl_kein_direktabschluss {
	my ($auswahl, $wert, @rest) = @_;
	my $mess = "\n<p><b><font color=\"#ff0000\">Achtung: " . 
		"Die Gesellschaft bietet f\xFCr die vorgenommene Auswahl keinen Direktabschluss an.\n" .
		"Bitte reichen Sie den Vertrag herk\xF6mmlich ein.</font></b></p>\n";
	if ($auswahl) { 
	    if ($wert) { 
		$mess =~ s/(vorgenommene Auswahl)/$1 ($auswahl : [$wert])/i;
	    } else {
		$mess =~ s/(vorgenommene Auswahl)/$1 ($auswahl)/i;
	    }
	    if ($mess !~ m|</font></b></p>\n$|) {
	    	$mess .= "</font></b></p>\n";
	    }
	    #&reportmail(&errmailth(), &errmailth(), '', "thincs: satz_auswahl_kein_direktabschluss", "auswahl[$auswahl] -- wert[$wert]\n--[$mess]--");
	}
	return $mess;
}

sub zwzuschlag {
## Zahlweise Zuschlag
	my %z = (
		1, 0,
		2, 3,
		4, 5,
		12, 5
	);
	return (%z);
}

sub gesrabatt {
	my ($ges, @rest) = @_;

## KB:	
# anbei die Gesellschaftsnummern und die entsprechenden Rabatte.
# 
# 5568: 20%
# 5569: 30%
# 5543: 30%
# 14597: 20%
# HOF 26.04.2012: TS: diese raus: |5543 # bei Rhion UNF
	
	my %rab = (
		5568, 0.2,
		5569, 0.3,
		5543, 0.3,
		14597, 0.2,
	);
	return ($rab{"$ges"});
}

sub laenderzeichendat {
	return 'bipro-datentypen_1.0.xsd';
}

sub biproDatentypenDat {
	return 'bipro-datentypen-shu-2.0.xsd';
}

sub biproKatalogeDat {
	return 'bipro-kataloge-2.1.1.xsd';
}

## HOF 09.01.2009
## 	_sub landzeichen {
## 	ist hier unguenstig. Ich brauche dafuer soap-inc.pl
## 	aber dann ist thincs nicht mehr unabhaengig
## auslagern in soap-inc.pl oder hier selber anders programmieren
sub landzeichen {
	my ($code, @rest) = @_;  ## ACHTUNG! $code ist hier der Laendername
	## wir haben da ein paar 'nette' Sachen, vorher raus!
	$code =~ s/Aegypten/\xC4gypten/;
	$code =~ s/Aequatorialguinea/\xC4quatorialguinea/;  ## gibts derzeit in der XSD nicht
	$code =~ s/Aethiopien/\xC4thiopien/;
	$code =~ s/Oesterreich/\xD6sterreich/;
	$code =~ s/\(.*?\)//;  ## derzeit bei Ost Timor(alt)
	$code =~ s/Zentral-afrikanische Republik/Zentralafrik. Republik/;
	$code =~ s/Weissrussland/Belarus/;

	## HOF 09.01.2009, von Rhion angemeckert, dass Laenderzeichen nicht stimmt.
	## 	ist momentan nur einstellig. War wohl damals wegen NV,
	## 	hatte Schnellschuss gemacht und nur erstes Zeichen vom Name genommen (Oesterreich -> 'O')
	## 	Rhion nimmt bipro-datentypen_1.0.xsd
	my $lsigndat = &laenderzeichendat();

	## so
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my $PATH_OUT = $PATH_SSL . 'cgi-bin/out';
	my $datnam = $PATH_OUT. '/' . $lsigndat;
	#my $datnam = "d:/Dokumente2/Server2/cgi-bin/out" . '/' . $lsigndat;

	## HOF 07.11.2008; Herr Bayer moechte dass die benutzten Textdateien nicht mehr .txt heissen, 
	## 	weil diese nicht mehr bei Server-Kopien mitgenommen werden

	local (*LANDZEICHENDAT);
	my $from = &errmailth();
	my $to = $from;
	
	if (!open(LANDZEICHENDAT, $datnam)) {
		#print "Die Laender-Zeichen Datei kann nicht gelesen werden: [$datnam]\n";
		&fehlermail(
			$from, $to, '', "Fehler landzeichen: Kann Laender-Zeichen Datei nicht lesen",
			"Die Laender-Zeichen Datei kann nicht gelesen werden: [$datnam]"
		);
		return('');
	}
	my $orgein = $/;
	undef($/);
	my $lzeichcont = <LANDZEICHENDAT>;
	$/ = $orgein;
	close (LANDZEICHENDAT);
	## ACHTUNG! XSD ist bestimmt UTF-8
	$lzeichcont = &utf82ascii($lzeichcont);

	my (%lcode, $lcode, $iscode, $lzeich, @lzeich, $zeich, $land);

	if ($lzeichcont !~ m/<simpleType name="ST_Laenderkennzeichen">(.*?)<\/simpleType>/is) {
		#print "In der Laender-Zeichen Datei koennen die Zeichen nicht gefunden werden: [$datnam]\n";
		&fehlermail(
			$from, $to, '', "Fehler landzeichen: Kann Laender-Zeichen Abschnitt nicht finden",
			"In der Laender-Zeichen Datei koennen die Zeichen nicht gefunden werden: [$datnam]"
		);
		return('');
	}
	$lzeich = $1;
	
	@lzeich = split(/<\/enumeration>/, $lzeich);

	allecodes:
	foreach $lcode (@lzeich) {
		if ( $lcode =~ m/<enumeration value="([^"]+)">.*?<documentation[^>]*>([^<]+)<\/documentation>/is ) {
			($zeich, $land) = ($1, $2);
			$land =~ s/\(.*?\)//;  ## derzeit bei Belarus (Weissrussland)
			if ( $land =~ m/$code/i ) {  ## ACHTUNG, als $code soll der Name des Landes uebergeben werden
				$iscode = $zeich;
				last allecodes;
			}
#		} else {
#			print "nichts gefunden in dieser Zeile:\n", '_' x 40, "\n";
#			print "$lcode\n";
#			print '_' x 40, "\n";
#			<STDIN>;
		}
	}
	return ($iscode);
}

sub queryland2 {
	&queryland();
	## geht nicht, Mist! warum? im XML kommt D an obwohl Oesterreich ausgewaehlt
	#if ($main::query{'land'} eq '') {  ## geht hier gar nicht mehr, weil oben queryland
	if (($main::query{'land'} ne 'D') || ($main::query{'NATIONALITAETVN'} !~ m/Deutschland/i)) {  ## D ist immer Deutschland, ich setz sonst in queryland ein X rein, wenn anderes Land mit D beginnt
		## an dieser Stelle ist queryland gelaufen, also falscher 1 Buchstabe -> korrigieren
		my $landtemp;
		if ( ($landtemp = &landzeichen($main::query{'NATIONALITAETVN'})) ) {  
			$main::query{'land'} = $landtemp;  ## &landtemp in thincs.pl, Basis ist Bipro XSD von Rhion, also bei Aenderung neues XSD auf Server
			return($landtemp);
		}
	}
	return($main::query{'land'});
}

sub testuser {
	return('DK05ABK', 'DKM2008');
}

sub testuserstring {
	my @testuser = &testuser();
	return (' ' . join(' ', @testuser) . ' ');
}

	sub checkVersicherungsort {
	## 17.04.2009 HOF, hier Kopie von _sub in genxml.pl
		if (($main::query{'Versicherungsort_Strasse'} eq "") && ($main::query{'abweichende_strasse'} ne "")) {
			$main::query{'Versicherungsort_Strasse'} = $main::query{'abweichende_strasse'};}
		if (($main::query{'Versicherungsort_Hausnummer'} eq "") && ($main::query{'abweichende_hausnummer'} ne "")) {
			$main::query{'Versicherungsort_Hausnummer'} = $main::query{'abweichende_hausnummer'};}
		if (($main::query{'Versicherungsort_PLZ'} eq "") && ($main::query{'abweichende_plz'} ne "")) {
			$main::query{'Versicherungsort_PLZ'} = $main::query{'abweichende_plz'};}
		if (($main::query{'Versicherungsort_Ort'} eq "") && ($main::query{'abweichende_ort'} ne "")) {
			$main::query{'Versicherungsort_Ort'} = $main::query{'abweichende_ort'};}
		if (($main::query{'Versicherungsort_Ort'} eq "") && ($main::query{'Versicherungsort_Wohnort'} ne "")) {
			$main::query{'Versicherungsort_Ort'} = $main::query{'Versicherungsort_Wohnort'};}
	}

sub getxmlfilename {
	my ($sparte, $gesellschaft, $vermittlernr, @rest) = @_;
	my ($fn, $temp, $sp);
	my %query = %main::query;
	if (($gesellschaft =~ m/Ammerl..?nder/i) && ($sparte =~ m/(Hausrat|Unfall)/i)) {
		$temp = &getdatetime();
		$temp =~ s/[^0-9]//ig;
		$temp =~ s/(.{8})/$1\x5F/;
		if ($sparte =~ m/Hausrat/i) {
			$sp = 'HR';
		} elsif ($sparte =~ m/Unfall/i) {
			$sp = 'UN';
		} else {
			## sonst Fehler, es gaebe noch Wohngebaeude = 'WG', haben wir aber nicht
			$sp = 'XXX';
		}
		$fn = "$sp\_$vermittlernr\_$temp\.xml";
	} elsif (  ($gesellschaft) && !($vermittlernr) ) {
		$fn = "$sparte\_$gesellschaft\_" . &getdatetime() . "_$query{'Nachname'}_$query{'Vorname'}.xml";
	} elsif ( !($gesellschaft) || !($vermittlernr) ) {
		$fn = "$sparte\_$query{'Nachname'}_$query{'Vorname'}.xml";
	} else {
		$fn = "$sparte\_$gesellschaft\_" . &getdatetime() . "_$vermittlernr\_$query{'Nachname'}_$query{'Vorname'}.xml";
	}
	$fn = filenameclear( $fn );
#	$fn = &ascii2uml($fn);
#	$fn =~ s/ /-/g;
#	$fn =~ s/[^a-z0-9\_\-\.~]/_/ig;
	return($fn);
}

sub erbe {
	my ($key, @rest) = @_;
	#print "-->key:[$key]";
	my %erbe = (
		'a', "sein \xFCberlebender Ehegatte, mit dem er zum Zeitpunkt des Ablebens verheiratet war",
		'b', 'seine ehelichen und die ihnen gesetzlich gleichgestellten Kinder zu gleichen Teilen',
		'c', 'seine Eltern zu gleichen Teilen',
		'd', 'seine Erben zu gleichen Teilen',
	);
	if ($key =~ m/^ *([a-d]) *$/i) {
		#return ($erbe{$1});
		## HOF 20.05.2009 lt. Herr Belting von Rhion
		return ('gesetzliche Erben');
	} elsif ($key =~ m/^ *$/i) {
		return ('gesetzliche Erben');
	} else {
		return ($key);
	}
}

sub isbeamter {  ## 29.01.2010 HOF; Fehlermeldung von Domcura: im XML wird OEDkenner nicht gesetzt: KB: Beamter: targru==1
	if ( ($main::query{'texttgru'} =~ m/(Beamter|ffentlicher Dienst)/) || ($main::query{'targru'} == 1) || ($main::query{'targru'} =~ m/Beamter/) ) { 
		return('1'); 
	} else { 
		return('0'); 
	}
}

sub mische {
	## mische ein Array
	my @dati = @_;
	my (@gemischt, $i, $x, $y, $temp, $index, %dati);
	$index = $#dati;
	foreach (@dati) { $dati{$_} = 'x'; }
	for($i=0;$i<=$index;$i++) { 
		@dati = keys(%dati);
		$x = int(rand($#dati));
		push(@gemischt, $dati[$x]);
		delete $dati{$dati[$x]};
	}
	return(@gemischt);
}

sub datusort {
	## Rueckgabe: sortiertes Array deutscher Datumsangaben
	my @dati = @_;
	my (@datarr, $t, $m, $j, @sorted);
	foreach (@dati) { push (@datarr, join('-', reverse(split(/\./, $_, 3)))); }
	@datarr = sort(@datarr);
	foreach (@datarr) { push (@sorted, join('.', reverse(split(/-/, $_, 3)))); }
	return (@sorted);
}

sub firstlast {
	## Rueckgabe: erster und letzter in einem Array deutscher Datumsangaben, Sortierung findet hier intern statt
	my @dati = @_;
	my (@sorted) = &datusort(@dati);
	return ($sorted[0], $sorted[$#dati]);
}

sub datediff {
	## Rueckgabe: "(Differenz Tage).(Diff Monat).(Diff Jahr)"
	## bei Uebergabe $opt =~ m/abs/ mit Vorzeichen (DateBis - DateVon); also im Sinne: von DateVon bis DateBis sind es ...
	## bei Uebergabe $opt =~ m/(jahr|alter)/ Rueckgabe nur Jahr (Verwendung z.B. Alter)
	my ($datevon, $datebis, $opt, @rest) = @_;
	## Die Optionen sollen sein:
	## 'abs' = absolut, also mit Vorzeichen, Standard ist ohne Vorzeichen
	## 'jahr' oder 'alter' = nur das Jahr zurueck liefern
	my ($d1, $d2, $m1, $m2, $y1, $y2, $dd, $dm, $dy);
	my $neg = '';
	($d1, $m1, $y1) = split(/\./, $datevon, 3);
	($d2, $m2, $y2) = split(/\./, $datebis, 3);
	my ($dz1, $dz2) = ( join('',reverse($d1, $m1, $y1)), join('',reverse($d2, $m2, $y2)) );
	if ($dz2 < $dz1) {
		($d1, $m1, $y1, $d2, $m2, $y2) = ($d2, $m2, $y2, $d1, $m1, $y1);
		($dz1, $dz2) = ($dz2, $dz1);
		$neg = '-';
	} 
	$dy = $y2 - $y1;
	$dm = $m2 - $m1;
	$dd = $d2 - $d1;
	if ($dd < 0) { $dm-=1; $dd+=31;}
	if ($dm < 0) { $dy-=1; $dm+=12;}
	my $vor;
	if ($opt =~ m/abs/i) {
		$vor = $neg;
	}
	if ($opt =~ m/(jahr|alter)/i) {
		return($vor . $dy);
	} else {
		return($vor . join('.',$dd,$dm,$dy));
	}
}

sub checksendlistealt {
	my ($listedat, $datumdat, $difftage, $antrag, $cc, @rest) = @_;
	## Pruefen ob Liste dem vorgegebenen Alter entspricht
	## 	Referenzdatum ist immer heute, gemessen wird Anzahl in Tagen
	## 	dann Liste mailen und leeren
	## uebergebenen Antrag (Zeile) an Liste anhaengen
	## Achtung! wenn Liste nicht alt, dann Rueckgabe 0, das ist ne undef 
		## Zwickmuehle:
		## 	eigentlich in Liste aufnehmen, bevor FTP, 
		## 	damit auf jeden Fall in Liste, auch wenn FTP schief geht.
		## 	aber in _sub "die" mit drin, der kann also vorm FTP beenden! "die" lieber raus?

	#my (*LIST, *DATUM);
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my ($datum, $zeit);
	my ($heute, $jetzt);
	my ($liste,$orgein, @liste, $listanz);
	my $datumdatvoll = "$PATH_SSL/cgi-bin/vers2002/$datumdat";
	my $listedatvoll = "$PATH_SSL/cgi-bin/vers2002/$listedat";
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
	## Datum Liste lesen
	if ( !(open(DATUM, "$datumdatvoll")) ) {
	## Fehler
		($datum, $zeit) = &getdatetimehuman();
		if ( !(open(DATUM, ">$datumdatvoll")) ) {
			&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nAlte Datumsdatei nicht vorhanden, kann neue nicht schreiben.");
			#die("checksendlistealt: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datu[$datu]\nAlte Datumsdatei nicht vorhanden, kann neue nicht schreiben.");
			return('');
		}
		&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nAlte Datumsdatei nicht vorhanden, schreibe neue.");
		print DATUM "$datum\n";
		close DATUM;
		chmod (0666, "$datumdatvoll");
	} else {
	## sonst lesen
		$datum = <DATUM>;
		close DATUM;
	}
	$datum =~ s/[\r\n]+$//g;
	($heute, $jetzt) = &getdatetimehuman();
	my $spd = 60 * 60 * 24;
	my ($d,$m,$y) = $heute =~ m|(\d+)\.(\d+)\.(\d+)|;
	my $timet = timelocal(0, 0, 0, $d, $m-1, $y);
	my $timetest = $timet - ($spd * $difftage);
	
	#my @datutest = localtime($timetest);
	# ## ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)
	#($d,$m,$y) = ($datutest[3], $datutest[4], $datutest[5] );
	#$m++;
	#$y+=1900;
	
	($d,$m,$y) = $datum =~ m/(\d+)\.(\d+)\.(\d+)/;
	my $timeold = timelocal(0, 0, 0, $d, $m-1, $y);

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timet);
	$mon += 1; $year += 1900;
	my ($datet) = "$mday\.$mon\.$year $hour\:$min\:$sec";

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timetest);
	$mon += 1; $year += 1900;
	my ($datetest) = "$mday\.$mon\.$year $hour\:$min\:$sec";

	   ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($timeold);
	$mon += 1; $year += 1900;
	my ($dateold) = "$mday\.$mon\.$year $hour\:$min\:$sec";

	## ist Liste alt?
	
#print <<__LISTE_ALT__;
#<hr>
#<p>
#Liste alt? (timeold <= timetest)
#</p><pre>
#timet   [$timet] $datet
#timetest[$timetest] $datetest
#timeold [$timeold] $dateold
#</pre>
#<hr>
#
#__LISTE_ALT__

	if ($timeold <= $timetest) {
		#print "<p>$timeold <= $timetest\n";
		if ( !(open(LIST, "$listedatvoll")) ) {
		## Fehler, Liste neu anlegen, Fehlermail
			if ( !(open(LIST, ">$listedatvoll")) ) {
				&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nAlte Listedatei nicht vorhanden, kann neue nicht schreiben.");
				#die("listedat[$listedat] - datumdat[$datumdat] - datu[$datu]\nAlte Listedatei nicht vorhanden, kann neue nicht schreiben.");
				return('');
			}
			&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nAlte Listedatei nicht vorhanden, schreibe neue.");
			print LIST "\n";
			close LIST;
			chmod (0666, "$listedatvoll");
			$liste = "\n";
			
			$listanz = 0;
		} else {
			$orgein = $/;
			undef $/;
			$liste = <LIST>;
			close LIST;
			$/ = $orgein;

			$liste =~ s/[\r\n]+$//s;
			@liste = split (/[\r\n]+/, $liste);
			#$listanz = @liste;
			$listanz = $#liste + 1;
			#print "<p>listanz[$listanz]</p>\n";
		}
		
		#$liste =~ s/[\r\n]+$//s;
		#@liste = split (/[\r\n]+/, $liste);
		# #$listanz = @liste;
		#$listanz = $#liste + 1;
		#print "<p>listanz[$listanz]</p>\n";
		
		&reportmail(&errmailth(),&errmailth(),$cc,"checksendlistealt: Liste $listedat am $heute", "s. Anhang\nlistedat[$listedat] - datumdat[$datumdat] - datum[$datum]", $listedat, $liste);
		if ( !(open(LIST, ">$listedatvoll")) ) {
			&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: Liste leeren: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nKann Liste nicht leeren/ schreiben.");
			#die("Liste leeren: listedat[$listedat] - datumdat[$datumdat] - datu[$datu]\nKann Liste nicht leeren/ schreiben.");
		} else {
			print LIST "\n";
			close LIST;
			chmod (0666, "$listedatvoll");
		}
		## auch Datu-Datei neu schreiben
		if ( !(open(DATUM, ">$datumdatvoll")) ) {
			&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nDatumsdatei: Kann neues Datum nicht schreiben.");
			#die("checksendlistealt: listedat[$listedat] - datumdat[$datumdat] - datu[$datu]\nDatumsdatei: Kann neues Datum nicht schreiben.");
		}
		print DATUM "$heute\n";
		close DATUM;
		chmod (0666, "$datumdatvoll");
		
	} else {
		#print "<p>!($timeold <= $timetest)\n";
		$listanz = 0;
	}
	
	## Antrag anhaengen
	if ( !(open(LIST, ">>$listedatvoll")) ) {
		&fehlermail(&errmailth(),&errmailth(),'',"checksendlistealt: Antrag anhaengen: $listedat", "listedat[$listedat] - datumdat[$datumdat] - datum[$datum]\nKann Antrag nicht anhaengen/ schreiben.");
		#die("Antrag anhaengen: listedat[$listedat] - datumdat[$datumdat] - datu[$datu]\nKann Antrag nicht anhaengen/ schreiben.");
		return('');
	}
	$antrag =~ s/(\r?\n)/#nl#/g;
	print LIST "$antrag\n";
	close LIST;
	chmod (0666, "$listedatvoll");

	#$listanz = 0;
	#$liste =~ s/[\r\n]+$//s;
	#@liste = split (/[\r\n]+/, $liste);
	# #$listanz = @liste;
	#$listanz = $#liste + 1;
	#print "<p>listanz[$listanz]</p>\n";
	return($listanz);
}

sub innomail {
	my ($kuerzel, @rest) = @_;
	my %mail = (
		'AQ', "aquast\@innosystems.de",
		'BAY', "bayer\@salmacis.com",
		'CL', "close\@innofinance.de",
		'DR', "drank\@innosystems.de",
		'EK', "ekassen\@innosystems.de",
		'GRA', "cgraf\@salmacis.com",
		'KAS', "bkasparek\@innosystems.de",
		'KB', "kbrodbeck\@innosystems.de",
		'KOPIE', "kopie\@innosystems.net",
		'MD', "mdaigeler\@innofinance.de",
		'MFK', "mfknauff\@innosystems.de",
		'NS', "nsinger\@innofinance.de",
		'RH', "rhessler\@innosystems.de",
		#'TH', "thofmann\@innosystems.net",
		'TH', "thofmann\@innosystems.de",
		'TH2', "thofmann\@innosystems.de",
		'TH3', "thofmann\@innosystems.net",
		'TS', "tstoiber\@innosystems.de",
		'IF', "antrag\@innofinance.de",
		'SCHNITTSTELLE', "direktanbindung\@innosystems.de",
		'DIREKTANBINDUNG', "direktanbindung\@innosystems.de",
		'ENTW', 'entwicklung@innosystems.net',
		'ENTWICKLUNG', 'entwicklung@innosystems.net',
		'MAILERROR', "mailerror\@innosystems.net",
		'INFO', "info\@innosystems.net",
		'INFODE', "info\@innosystems.de",
		'AW', "awittmann\@innosystems.de",
		'SUPPORT', "support\@innosystems.de",
		'PK', "pkrummenauer\@innosystems.de",
		'DP', "dpeter\@innosystems.de",
		'LW', "lwang\@innosystems.de",
		'TN', "tnikolaienko\@innosystems.de",
	);
	if (!($mail{"\U$kuerzel"})) {
		return ($mail{'TH'});
	} else {
		return ($mail{"\U$kuerzel"});
	}
}

sub partnermail {
	## hier alle EMail-Adressen rein, die mit Direktanbindungen zu tun haben
	## HOF, letzter Stand 10 Adressen am 09.03.2010
	## Das ist wichtig! Das wird benutzt um zu pruefen, ob der Empfaenger eine Direktanbindung ist, 
	## 	dann Absender &innomail('schnittstelle')
	## 	siehe vertrag_outfile.inc
	## auslagern um ganze Liste zu bekommen: partnermails
	my ($kuerzel, @rest) = @_;
	my %mail = &partnermails();
	if (!($mail{"\U$kuerzel"})) {
		return (&innomail('TH'));
	} else {
		return ($mail{"\U$kuerzel"});
	}
}

sub partnermails {
	my %mails = (
		'RHION', "Thomas.Belting\@rheinland-versicherungen.de",
		'RHIONWS', "SNIVER_SHU_prod_Antraege\@rhion.de",
		'RHIONRASTEN', '', # Frau Rasten hat das Unternehmen verlassen # Ariane.Rasten@RheinLand-Versicherungen.de
		'DOMCURA', "R.Schnittger\@domcura.de",
		'DOMCURA2', "D.Schimmer\@domcura.de", # frueher J.Gerth; nochmal frueher r.schnittger
		'DOMCURAANTRAG', "antragseingang\@domcura.de", # TH 12.06.2015, Herr Holz gibt fuer ab sofort dies als Standard-Adresse fuer Antraege an
		'IDEAL', 'vpb@ideal-versicherung.de',
		'IDEAL2', 'info@ideal-versicherung.de',
		'IDEAL3', 'service@ideal-versicherung.de',
		'IDEALTEST', "toohoo\@gmail.com",
		'IDEALMUELLER', 'mueller@ideal-versicherung.de',
		'AUXILIA', "afisxml\@auxilia.de",
		'AUXILIATEST', "entwicklung\@innosystems.de",
		'AUXILIATESTMITAUXILIA', "xmlint\@apptest.ks-auxilia.de",
		'NV0', "dmenker\@nv-online.de",
		'NV', 'info@nv-online.de',
		'NVTEST', "phartzsch\@nv-online.de",
		'NV2', "phartzsch\@nv-online.de",
		'NVNEU', "kbikker\@nv-online.de",
		'AMMER', 'detlef.schuetz@vicotec.de',
		'AMMERLAENDER', 'info@ammerlaender-versicherung.de',
		'JANITOS', 'versicherung@janitos.de',
		'SPAR', 'service@sparkassen-direkt.de',
		'DADIREKT',  'KFZ-kooperationen@da-direkt.de',
		'DADIREKT2', 'kfz-antrag-koop@da-direkt.de',
		'WW', "S12-KBPK09\@wuerttembergische.de", 
		'WW2', "S12-KB1\@wuerttembergische.de", 
		'WUERTTEMBERGISCHE', "S12-KBPK09\@wuerttembergische.de", 
		'WALDENBURGER0', 'matias.petrusic@waldenburger.com', # Hr. Bader 29.10.2010, bitte Mails an ihn statt an Petrusic
		'WALDENBURGER', 'Hartmut.Bader@waldenburger.com',
		'WALDENBURGER2', 'thomas.benndorf@waldenburger.com', # Herr Bader Tel.: zusaetzlich diese
		'WALDENBURGER3', 'antrag@waldenburger.com', # 26.04.2012 Herr Bader moechte heute sich und Herrn Bemmdorf raus, dafuer diese
		'MLPKFZ', "kfz\@mlp.de",
		'MLPPREDIKANT', "marion.predikant\@mlp.de",
		'INTERLLOYD', "klaus.schiefer\@interlloyd.de",
		'ZUERICH', "vertrag\@zurich.com",
		'BAVARIADIREKT0', "info\@bavariadirekt.de",
		'BAVARIADIREKT', "vertrieb\@bavariadirekt.de",
		'CONCEPTIF', "bearbeitung\@conceptif.de",
		'CONCEPTIF1', "h.wenzke\@cevo.de",
		'CONCORDIA-RS', "innosystems\@concordia.de",
		'AXAKFZ', 'geue-retail-ifk@axa.de', # nur fuer Kfz benutzen
		'AXA', 'geue-retail-ifk@axa.de', # HOF, die nur mal vorsichtshalber
		'AXASACH', 'geue-retail-ifk@axa.de', # HOF, die nur mal vorsichtshalber
		'AXAKV', 'geue-retail-ifk@axa.de', # HOF, die nur mal vorsichtshalber
		'GVO', 'online@g-v-o.de', 
		'GOTHAERFEHLER', 'gkc_mm@gothaer.de', 
		'TAURESDOKU', 'dokumentation@taures.de', 
		'INTERRISK', 'antrag@interrisk.de', 
		'INTERRISKFEHLER', 'Bahadir.Dikmen@interrisk.de', 
		
	);
	return(%mails);
}

sub gethashfromfile {
	## einen Hash holen aus einer Datei.
	## a) aus einer Textdatei immer: Key Tabulator Value
	## b) aus einer html-Datei mit 1(!) zweispaltigen Tabelle, 
	## 	jede Tabellenzeile muss in einer Zeile stehen, 
	## 	keine Leerzeichen/Tabz zwischen Tags
	## 	keine TH (werden ueberlesen)
	## 	keine < und > in key, werden entfernt
	## 	value kann tags enthalten, dann darf aber der value innerhalb der Tabelle nicht mit Tags umschlossen werden
	## der Unterschied wird an der Endung 'txt' oder 'htm' oder 'html' erkannt
	my ($datnam, @rest) = @_;
	my (%h);
	if (!$datnam) {return('');}
	if ($datnam !~ m/\.(txt|htm|html)$/i) {return('');}
	my ($istxt, $ishtml);
	if ($datnam =~ m/\.txt$/i) {
		$istxt = 1;
	} elsif ($datnam =~ m/\.html?$/i) {
		$ishtml = 1;
	}
	local (*GETHASHFROMFILEDAT);
	if (!open(GETHASHFROMFILEDAT, $datnam)) {
		return('');
	}
	my @zeilen = <GETHASHFROMFILEDAT>;
	close(GETHASHFROMFILEDAT);
	my ($z, $k, $v, $anz);
	allezeilengethashff:
	foreach $z (@zeilen) {
		$z =~ s/[\r\n]//g;
		if ($istxt) {
			if ($z !~ m/^([^\t]+)\t(.*?)$/) { 
				next allezeilengethashff;
			}
			($k, $v) = ($1, $2);
		} elsif ($ishtml) {
			if ($z !~ m/<tr[^>]*><td[^>]*>(.*?)<\/td><td[^>]*>(.*?)<\/td><\/tr>/i) { 
				next allezeilengethashff;
			}
			($k, $v) = ($1, $2);
			$k =~ s/<[^>]+>//ig;
			## value kann tags enthalten, dann darf aber der value innerhalb der Tabelle nicht mit Tags umschlossen werden
			#$v =~ s/<[^>]+>//ig;
		} else {
			next allezeilengethashff;
		}
		$h{$k} = $v;
		$anz++;
	}
	return (%h);
}

sub writehash2file {
	## einen Hash schreiben eine Datei.
	## a) in eine Textdatei immer: Key Tabulator Value
	my ($datnam, %h) = @_;
	if (!$datnam) {return('');}
	if ($datnam !~ m/\.(txt)$/i) {
		#print '!~ m/\.(txt)$/i\n'; 
		return('');
	}
	my ($istxt, $ishtml);
	if ($datnam =~ m/\.txt$/i) {
		$istxt = 1;
	} elsif ($datnam =~ m/\.html?$/i) {
		$ishtml = 1;
	}
	#my (*DAT);
	if (!open(DAT, ">$datnam")) {
		#print "!open[>$datnam]\n";
		return('');
	}
	my ($z, $k, $v, $anz);
	allezeilenwritehash2f:
	foreach $k (keys(%h)) {
		$k =~ s/[\r\n]//g;
		if ($istxt) {
#			if ($z !~ m/^([^\t]+)\t(.*?)$/) { 
#				next allezeilenwritehash2f;
#			}
			print DAT $k , "\t" , $h{$k} , "\n";
			#($k, $v) = ($1, $2);
		} elsif ($ishtml) {
#			if ($z !~ m/<tr[^>]*><td[^>]*>(.*?)<\/td><td[^>]*>(.*?)<\/td><\/tr>/i) { 
#				next allezeilenwritehash2f;
#			}
#			($k, $v) = ($1, $2);
#			$k =~ s/<[^>]+>//ig;
#			## value kann tags enthalten, dann darf aber der value innerhalb der Tabelle nicht mit Tags umschlossen werden
#			#$v =~ s/<[^>]+>//ig;
		} else {
			next allezeilenwritehash2f;
		}
		$anz++;
	}
	close(DAT);
	chmod (oct("666"), $datnam);
	return ($anz);
}

sub anhangraus {
	my ($cont, @rest) = @_;
	my ($kopf, $dateiname, $contneu, $encode);
	if (!($cont)) { return ''; }
	if (!($cont =~ m/(--Message-Boundary.*?)\r?\n\r?\n/is)) {
		my $temp = substr($cont, 0, 300);
		&fehlermail(&innomail('TH'), &innomail('TH'), '', 'thincs--anhangraus', "Fehler siehe Betreff, kann Message-Boundary nicht finden.\n$temp");
		return '';
	} else {
		$kopf = $1;
		$contneu = $';
		if ($kopf =~ m/filename="([^"]+)"/) {
			$dateiname = $1;
		} elsif ($kopf =~ m/name="([^"]+)"/) {
			$dateiname = $1;
		}
		if ($kopf =~ m/Content-Transfer-Encoding: *([^ \t\r\n]+)[ \t\r\n]/) {
			$encode = $1;
			if ($encode =~ m/base64/i) {
				$contneu = &decode_base64($contneu);
			}
		}
		return($dateiname, $contneu);
	}

}

sub getuserftp {
	## HOF 04.08.2010; Auch SCP user soll es geben und also eine Uebertragung, 2 zusaetzliche Parameter, fehlt noch: Port
	# HOF 30.04.2013, Mantis 3284, ftp.conopera-fs.de -> 176.98.166.98
	my %ftps = (
	    ## $deruser	$server	$benutzer	$pass	$verz	$var	$act	$isscp	$scpkeyfile	$scpport
		'DMUD55',	"mydegenia.de	inno	6.QdWjPp8Y?UQ67c	", # geaendert 22.03.2013 HOF, vorher: degenia.de inno sg456sy
		## Test fuer a-fk.de , dafuer originales THOFMANN aendern mit Server a-fk.de
#		'THOFMANN',	'www.iivs.de	iiv00096	2134hoto	public_html/inno/	VN_ID	http://www.th-o.de/cgi-bin/nachricht.pl?from=t*th-o.de&to=toohoo*gmail.com&subject=test-nachricht&zauberwort=bitte&vn_id=[VN_ID]&file1=[DATEINAME]',
		'THOFMANN',	'www.a-fk.de	innosystems	inno87vx	in	VN_ID	http://www.th-o.de/cgi-bin/nachricht.pl?from=t*th-o.de&to=toohoo*gmail.com&subject=test-nachricht&zauberwort=bitte&vn_id=[VN_ID]&file1=[DATEINAME]',
		'FKAG89',	'www.a-fk.de	innosystems	inno87vx	in	VN_ID	https://www.a-fk.de/MSC3/triggerinnosystems?prefix=FK&id=[VN_ID]&file1=[DATEINAME]',
		'FKIF89',	'www.a-fk.de	innosystems	inno87vx	in	VN_ID	https://www.a-fk.de/MSC3/triggerinnosystems?prefix=FK&id=[VN_ID]&file1=[DATEINAME]',
		'CNPS51',	'176.98.166.98	sniver_test	jk48vnKL!5#DC	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
## HOF 14.07.2010; Conopera diese User ab kommenden Monatg live; einfach die andere Gruppe Zeilen ausREMen
## test
#		'CNPR01',	'176.98.166.98	sniver_test	jk48vnKL!5#DC	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
#		'CNPR02',	'176.98.166.98	sniver_test	jk48vnKL!5#DC	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
#		'CNPR03',	'176.98.166.98	sniver_test	jk48vnKL!5#DC	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
#		'CNPR04',	'176.98.166.98	sniver_test	jk48vnKL!5#DC	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
## produktiv
		'CNPR01',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		'CNPR02',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		'CNPR03',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		'CNPR04',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
## Ende Conopera produktiv
		'CNPR05',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		#'CNPR05',	'176.98.166.98	sniver_test	jk48vnKL!5#DC	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		'CNPR06',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		'CNPR07',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
## SCP fuer asi-online.de, Herr Schenk, Herr Weiler
#scp -2 -q -C -i innosystems.key -P48143 -oBatchMode=yes -oStrictHostKeyChecking=no test.txt innosystems@matrix.asi-online.de:/home/innosystems/test.txt
#		user     	server          	username	pass    	verz	var	act	isscp	scpkeyfile	scpport
		'ASIW48',	'matrix.asi-online.de	innosystems	jk48vnKL!5#DC				ja	asionline.key	48143',
# HOF 03.08.2011; CNPR08 fehlt, hat das mal jemand ueberschrieben?
		'CNPR09',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
# auf Nachfrage bei Conopera / Wopitec (Herr Palko) soll auch CNPR08
		'CNPR08',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
# Frau Kassen volz-itsc, Mantis 2976
	    ## $deruser		$server			$benutzer	$pass		$verz	$var	$act	$isscp	$scpkeyfile	$scpport
		'VOLZTA',	'transfer.volz-itsc.de	innosystems	4pAtANx7I1	test', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
		'FINM22',	'transfer.volz-itsc.de	innosystems	4pAtANx7I1	finmap', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
# von DR am 22.12.2011
		'CNPR10',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
# von DR am 23.04.2012
		'CNPR11',	'176.98.166.98	sniver_produktiv	Conopera2010	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
# Finas
		'FIVM06',	'finaswb.homeip.net	Innosystems	1nn0P455w0rd4m3	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
# Finanz-Zirkel, redmine #4142
		'FZGC31',	'innosystems.calcutronic.com	innofzdaten	_F6t32zb	', ## IP=62.159.69.189 ; sniver_produktiv	ak548CN58v.1#
	);
	return (%ftps);
}

sub zahlweisezahl {
	my ($zw, @rest) = @_;
	my %zwz = (
		"j\xE4hrlich", 1,
		"halbj\xE4hrlich", 2,
		"viertelj\xE4hrlich", 4,
		'monatlich', 12,
		'jaehrlich', 1,
		'halbjaehrlich', 2,
		'vierteljaehrlich', 4,
		"j\xC3\xA4hrlich", 1,
		"halbj\xC3\xA4hrlich", 2,
		"viertelj\xC3\xA4hrlich", 4,
	);
	return($zwz{$zw});
}

sub val2key {
	# key und value vertauschen
	# geht nicht immer einfach, weil der key einmalig sein muss aber nicht der value
	# was dann? dann gibt es also zu einem neuen key (ehemals value) mehrere keys, evtl.
	# evtl. mehrere alte keys bzw. neue val's mit einem zeichen trennen. welches?
	# null?
	my (%hash) = @_;
	my $sep = "\x00";
	my (%neu, $temp, $k, $v);
	foreach $k(keys(%hash)) {
		if ($neu{$hash{$k}}) {  ## entspricht $x  ne ''
			$neu{$hash{$k}} .= $sep . $k;
		} else {
			$neu{$hash{$k}} = $k;
		}
	}
	return (%neu);
}

sub getBiproDatentypen {

	my ($schluessel,@rest) = @_;
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) {$PATH_SSL = &PATH_SSL();}
	#$PATH_SSL =~ s/[\/\\]$//i;
	if ($PATH_SSL !~ m/\/$/i) {$PATH_SSL .= '/';}
	my $verspfad = $PATH_SSL . "cgi-bin/vers2002/";
	my $outpfad = $PATH_SSL . "cgi-bin/out/";
	my $datydat = &biproDatentypenDat();
	my $datydatnam = "$outpfad$datydat";

#print "... vor if NOT open DAT\n";
	if (!open(DAT, $datydatnam)) {
		#print "Die Bibro Datentypen-Datei kann nicht gelesen werden: [$datydatnam]\n";
#print "... vor fehlermail NOT open\n";
		my ($host,$name,$user,$modul) = 
		  ($main::ENV{'HTTP_HOST'},$main::ENV{'SERVER_NAME'},$main::query{'user'},$main::query{'modul'});
		&fehlermail(
			&innomail('TH'), &innomail('TH'), '', 
			"Fehler getBiproDatentypen: Kann Bipro Datentypen-Datei nicht lesen",
			"Die Bipro Datentypen-Datei kann nicht gelesen werden: [$datydatnam],\n " .
			"host[$host] - name[$name] - user[$user] - modul[$modul]"
		);
#print "... nach fehlermail NOT open\n";
		return('');
	}
#print "... nach if NOT open DAT\n";
	my $orgein = $/;
	undef($/);
	my $datycont = <DAT>;
	$/ = $orgein;
	close (DAT);
	## ACHTUNG! XSD ist bestimmt UTF-8
	$datycont = &utf82ascii($datycont);

	if ($datycont !~ m/<simpleType name="$schluessel">(.*?)<\/simpleType>/is) {
		#print "In der Laender-Zeichen Datei koennen die Zeichen nicht gefunden werden: [$datnam]\n";
		&fehlermail(
			&innomail('TH'), &innomail('TH'), '', 
			"Fehler getBiproDatentypen: Kann Bipro Datentypen-Abschnitt nicht finden",
			"In der Bipro Datentypen-Datei kann der Schluessel [$schluessel] nicht gefunden werden: [$datydatnam]"
		);
		return('');
	}
	my $typcont = $1;
	
	my @typcont = split(/<\/enumeration>/, $typcont);

	my ($tcode,$key,$val,%typ);
	allecodes:
	foreach $tcode (@typcont) {
		if ( $tcode =~ m/<enumeration value="([^"]+)">.*?<documentation[^>]*>([^<]+)<\/documentation>/is ) {
			($key, $val) = ($1, $2);
			$typ{"$1"} = "$2";
			#print "\t->$1: $2\n";
			#print "\t\t->$key: $val\n";
		}
	}
	return (%typ);

}

sub getBiproKataloge {

	my ($schluessel,@rest) = @_;
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) {$PATH_SSL = &PATH_SSL();}
	#$PATH_SSL =~ s/[\/\\]$//i;
	if ($PATH_SSL !~ m/\/$/i) {$PATH_SSL .= '/';}
	my $verspfad = $PATH_SSL . "cgi-bin/vers2002/";
	my $outpfad = $PATH_SSL . "cgi-bin/out/";
	my $datydat = &biproKatalogeDat();
	my $datydatnam = "$outpfad$datydat";

#print "... vor if NOT open DAT\n";
	if (!open(DAT, $datydatnam)) {
		#print "Die Bibro Datentypen-Datei kann nicht gelesen werden: [$datydatnam]\n";
#print "... vor fehlermail NOT open\n";
		&fehlermail(
			&innomail('TH'), &innomail('TH'), '', 
			"Fehler getBiproKataloge: Kann Bipro Kataloge-Datei nicht lesen",
			"Die Bipro Kataloge-Datei kann nicht gelesen werden: [$datydatnam]"
		);
#print "... nach fehlermail NOT open\n";
		return('');
	}
#print "... nach if NOT open DAT\n";
	my $orgein = $/;
	undef($/);
	my $datycont = <DAT>;
	$/ = $orgein;
	close (DAT);
	## ACHTUNG! XSD ist bestimmt UTF-8
	$datycont = &utf82ascii($datycont);

	if ($datycont !~ m/<(xs:)?simpleType name="$schluessel">(.*?)<\/(xs:)?simpleType>/is) {
		#print "In der Laender-Zeichen Datei koennen die Zeichen nicht gefunden werden: [$datnam]\n";
		&fehlermail(
			&innomail('TH'), &innomail('TH'), '', 
			"Fehler getBiproKataloge: Kann Bipro Kataloge-Abschnitt nicht finden",
			"In der Bipro Kataloge-Datei kann der Schluessel [$schluessel] nicht gefunden werden: [$datydatnam]"
		);
		return('');
	}
	my $typcont = $2;
	
	my @typcont;
	@typcont = split(/<\/(xs:)?enumeration>/, $typcont);

	my ($tcode,$key,$val,%typ);
	allecodes:
	foreach $tcode (@typcont) {
		if ( $tcode =~ m/<(xs:)?enumeration value="([^"]+)">.*?<(xsd:)?documentation[^>]*>([^<]+)<\/(xsd:)?documentation>/is ) {
			($key, $val) = ($2, $4);
			$typ{"$key"} = "$val";
			#print "\t->$2: $4\n";
			#print "\t\t->$key: $val\n";
		}
	}
	return (%typ);

}

sub hash2select {
	## erwartet wird ein Hash key->value
	## baut HTML mit HTML-Code fuer select (value->key = eindeutiger key)
	my %keyhash = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	@key = sort(keys(%keyhash));
	$html = "\t<select name=\"hash2select\">\n\t\t<option value=\"\"></option>\n"; # alt: bitte auswaehlen
	for ($i=0; $i<=$#key; $i++) { 
		$html .= "\t\t<option value=\"$key[$i]\">" . $keyhash{$key[$i]} . "</option>\n";
	}
	$html .= "\t</select>\n";
	return($html);
}

sub hash2selectname {


	## erwartet wird 1. Name des select; 2. Hash key->value
	## baut HTML mit HTML-Code fuer select (value->key = eindeutiger key)

	my ($name,%keyhash) = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	@key = sort(keys(%keyhash));
	$html = "\t<select name=\"$name\">\n\t\t<option value=\"\"></option>\n"; # alt: bitte auswaehlen

	my$backbutton;
	for ($i=0; $i<=$#key; $i++) { 

		# Im Rahmen des Projektes "Antraege speichern" ist es fundamenmtal wichtig das die Janitos ihr
		# Berufsdropdown auch angepasst hat.
		# BAY 17.04.2012
	    if ($name eq "ST_BerufBranche" || $name eq "ST_Taetigkeitsstatus") {
    	    $backbutton="[".$name."_".$key[$i]."_SELECTED]";
	    }

		$html .= "\t\t<option value=\"$key[$i]\" $backbutton>" . $keyhash{$key[$i]} . "</option>\n";
	}
	$html .= "\t</select>\n";
	return($html);
}

sub setOldQueryVars {
	## HOF 21.07.2010
	## Entstehung: Conopera bemaengelt, das Telefonnummer in GDV nicht befuellt wird
	## in GDV steht $query{'TelefonPrivat'}; wir haben aber nur $query{'Telefon'}
	## nach Auftreten hier ergaenzen
	if (($main::query{'TelefonPrivat'} =~ m/^[ \t]*$/i) && ($main::query{'Telefon'} !~ m/^[ \t]*$/i)) {
		$main::query{'TelefonPrivat'} = $main::query{'Telefon'}
	}
}

sub urlok {
	my ($url,@rest) = @_;
	if ($url =~ m/^(https?:\/\/)?(www\.)?([a-z0-9_\-]+\.)+[a-z]{2,6}(\/([a-z0-9_\-\.]+\/?)?)*([\?\/][^ \t\r\n]*)?$/i) {
		return(1);
	} else {
		return(0);
	}
}

sub mailok {
	my ($mail,$extended,@rest) = @_;
	# extended==1 -> erweiterte Schreibweise wie:
	# "Vorname Nachname" <alias@domain.de>
	# korrektes match waere:
	# /^([a-z0-9][a-z0-9_\.\-]*)\@([a-z0-9][a-z0-9_\-]*[a-z0-9]\.)+[a-z]{2,6}$/i
	# .. wobei das 2. "[a-z0-9]" bei der Domain in ernst nur fuer die second level domain gilt, Subdomains trifft diese Einschraenkung nicht
    if ($extended) {
		if ($mail =~ m/^"[^"]+" +<([a-z0-9_\.\-]+)\@([a-z0-9_\-]+\.)+[a-z]{2,7}>$/i) {
			return(1);
		} elsif ($mail =~ m/^([a-z0-9_\.\-]+)\@([a-z0-9_\-]+\.)+[a-z]{2,7}$/i) {
			return(1);
		} elsif ($mail =~ m/^MLP Angebotscenter <angebotscenter\@mlp-kfz.de>$/i) {
			return(1);
		} else {
			return(0);
		}
    } else {
		if ($mail =~ m/^([a-z0-9_\.\-]+)\@([a-z0-9_\-]+\.)+[a-z]{2,7}$/i) {
			return(1);
		} elsif ($mail =~ m/^MLP Angebotscenter <angebotscenter\@mlp-kfz.de>$/i) {
			return(1);
		} else {
			return(0);
		}
    }
}

sub anhaenge2gdv {
	my ($gdvsatz,@anhang) = @_;
	my $gdvneu = $gdvsatz;
	$gdvsatz =~ s/[\r\n]+$//sg;
	my @gdv = split(/\r?\n/, $gdvsatz);
	my $gdvlast = pop(@gdv);
	$gdvlast = substr($gdvlast,4); # die ersten vier 9 '9999' wegschneiden, dann bleibt die Anzahl der Zeilen
	# Achtung! Anzahl einstellig oder zweistellig?
	# fuer alle Anhaenge: die hier auffuehren
	my $vorspann = substr($gdv[$#gdv],0,42);
	substr($vorspann,0,4) = '9950';
	my ($i,$anhangzeile,@anh,$z,$ii);
	for ($i=0; $i<=$#anhang; $i++) {
		$z=$i + 1;
		$anhangzeile = $vorspann . &fuell($anhang[$i],209,' ') . &fuell($z,4,'0','L') . '1';
		push (@anh,$anhangzeile);
	}
	push (@gdv,@anh);
	$i = index($gdvlast,' ');
	$ii = substr($gdvlast,0,$i);
	$ii += $z;
	$gdvlast = '9999' . $ii . substr($gdvlast, length($ii));
	push (@gdv, $gdvlast);
	$gdvsatz = join("\n",@gdv);
	return ($gdvsatz);
}

sub fuell {
	my($str, $len, $char, $wo, @rest) = @_;
	if (!$char) { $char = ' '; } # kein Fuellzeichen -> Leerzeichen
	my $anz = $len - length($str);
	if ( $anz == 0 ) {
		# gar nix machen
	} elsif ($anz < 0) {
		$str = substr($str,0,$len);
	} else {
		my $fuell = $char x $anz;
		if ($wo =~ m/^l/i) {  ## 'links' wuerde auch gehen
			$str = $fuell . $str;
		} elsif ($wo =~ m/^r/i) {  ## 'rechts' wuerde auch gehen
			$str .= $fuell;
		} else {  ## sonst wie rechts
			$str .= $fuell;
		}
	}
	return($str);
}

sub innolog {
	my ($aktion,$datei,@rest) = @_;
	# HOF 20.01.2011; alle anderen Daten selber raussuchen
	# datum zeit session user untermandant sparte gesellschaft nachnamevn vornamevn
	my ($datuzeit, $session, $user, $untermandant, $sparte, $gesellschaft, $nachnamevn, $vornamevn);
	my %query = %main::query;
	#$datuzeit = &logtime();
	($datuzeit, $session, $user, $untermandant, $sparte, $gesellschaft, $nachnamevn, $vornamevn) =
	(&getdatetime(), $query{'session'}, $query{'user'}, $query{'untermandant'}, $query{'modul'},
	 $query{'Gesellschaft'}, $query{'NACHNAMEVN'}, $query{'VORNAMEVN'}
	);
	my $lognam = 'inno.log';
	my $logdir = &PDFwebdir();
	my $logadr = &PDFwebaddress();
	my $logdirnam = $logdir . $lognam;
	my $logwebnam = $logadr . $lognam;
	my $maxsize = 1048576; #1024 * 1024;
	my $zeile;
	$zeile = join("\t",
	$datuzeit, $session, $user, $untermandant, $sparte, $gesellschaft, $nachnamevn, $vornamevn);
	my	($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
		 $atime,$mtime,$ctime,$blksize,$blocks)
			 = stat($logdirnam);
	#my (*INNOLOGDAT);
	my ($mes, $tit, $len);
	my ($from, $to, $cc) = (&innomail('TH'), &innomail('TH'), '');
	my $rights = '666';
	if ($size > $maxsize) {
		my $logtemp = $logdirnam;
		$logtemp =~ s/(\.log)$/-$datuzeit$1/ig;
		if (rename($logdirnam, $logtemp)) {
			my $chlen = chmod (oct("$rights"), $logtemp);
			if ($chlen < 1) { &reportmail($from,$to, '', 
				"innolog: Kann Datei-Attribute nicht aendern", "[$rights][$logtemp]"); }
			#$zeile = join("\t",$zeile,"backup log",$logtemp);

			if (!open(INNOLOGDAT, ">>$logdirnam")) {
				$tit = "innolog: Kann neues Logfile nicht schreiben";
				$mes = "$tit [$logdirnam].";
				#&webwarnung($mes);
				&fehlermail($from, $to, '', $tit, $mes);
				return ('');
			}
			print INNOLOGDAT join("\t",$zeile,"backup log",$logtemp), "\n";
			close(INNOLOGDAT);
			$chlen = chmod (oct("$rights"), $logdirnam);
			if ($chlen < 1) { &reportmail($from,$to, '', 
				"innolog: Kann Datei-Attribute nicht aendern", "[$rights][$logdirnam]"); }
		} else {
			&reportmail(&innomail('th'),&innomail('th'),'',
			"innolog: kann Logfile nicht umbenennen [$lognam]",$logtemp);
			# bei rename fehler trotzdem weiter machen, kein exit/return
		}
	}
	$zeile = join("\t",$zeile,$aktion,$datei);
	if (!open(INNOLOGDAT, ">>$logdirnam")) {
		$tit = "innolog: Kann Logfile nicht schreiben (anhaengen)";
		$mes = "$tit [$logdirnam].";
		#&webwarnung($mes);
		&fehlermail($from, $to, '', $tit, $mes);
		return ('');
	}
	print INNOLOGDAT $zeile, "\n";
	close(INNOLOGDAT);
	return(1);
}

# alte nicht uebernommene RH
sub client{

	my ($action,$protokoll,$soap_str,$ctype,$url,$methode,$set_proxy,$debug,$supress_xml,$umlaute,$tcode) = @_;
		
	my $ua = LWP::UserAgent->new; 
	   $ua->protocols_allowed( [ 'http' , 'https'] );
	   $ua->proxy(['http' , 'https'],$url) if $set_proxy;
	   $ua->agent('Innosystems');
	   $ua->from('rhessler\@innosystems.de');
	   $ua->timeout(180);

	$soap_str=&umlaute($soap_str,$debug,$supress_xml,$umlaute);
	
#	if (!$soap_str){
#		print "FEHLER: Kein String zum uebergeben";
#	}
	
	my $request;
	   $request = HTTP::Request->new($methode , $url);
	   $request->content_type($ctype) if $ctype;
	   $request->content($soap_str) if $soap_str;
	   if ( ($action =~ s/^_$//) || ($action) ) {
		   $request->header(SOAPAction => $action); ## HOF 19.06.2009; ich uebergebe '_' was hier dann rausgeworfen wird (''), damit ich eine leere SOAPaction im Header bekomme
	   }
	   $request->header(SOAPAction => $action) if ($action);
	   $request->protocol($protokoll) if $protokoll;
	
	my $res;
	if($request){
		$res = $ua->request($request);
	}else{
		return ("Fehler bei der Erstellung des Request","0");
	}
#	if ($debug){
#	   &Write_Client(&codesyntax($soap_str), &codesyntax($res->content), $url, $res->content_length, $res->message, $res->is_success, $res->code, $tcode);
#	   print "<b><u>Result: $query{Gesellschaft}<br></u></b>";
#	   print "<b>URL: </b>".$url."<br>";
#	   print "<b>Content: </b><pre>".&codesyntax($res->content)."</pre><br>";
#	   print "<b>Content-Length: </b>".$res->content_length."<br>";
#	   print "<b>Code: </b>".$res->code."<br>";
#	   print "<b>Success: </b>".$res->is_success."<br>";
#	   print "<b>Message: </b>".$res->message."<br>";
#	   print "<b>Status: </b>".$res->status_line."<br>";
#	   print "<b>String: </b>".$res->as_string;
#	}
	return($res->content,$res->is_success,$res->code,$res->message);
}

sub umlaute{

my ($str,$debug,$supress_xml,$umlaute)=@_;

if (!$umlaute){
   $str =~ s/\xE4/ae/g;
   $str =~ s/\xF6/oe/g;
   $str =~ s/\xFC/ue/g;
   $str =~ s/\xC4/Ae/g;
   $str =~ s/\xD6/Oe/g;
   $str =~ s/\xDC/Ue/g;
   $str =~ s/\xDF/ss/g;
}
	if ($debug){
		if (!$supress_xml){
			&print_xml($str);
   		}
   	}
return $str;
}

sub print_xml{

	my ($str)=@_;
	print "<hr width='20%' align='left'>";
	print "XML INPUT FILE:<br>\n";
#	print "<pre>\n";
#	do 
#	{
#		local $/;
#		$str =~ s/\</&lt;/g;
#		$str =~ s/\>/&gt;/g;
#	};
	my $formatiert = &codesyntax($str);
	$formatiert =~ s/\<\/?small\>//g;
	print $formatiert;
#	print "</pre>";


}

sub Write_Client{
	my ($input, $output, $url, $clength, $message, $is_success, $code, $tcode) = @_;

	my $PATH_SSL="/intranet/www/www10001/www/ssl.innosystems.net/";
	my $dateiname = "0".$tcode."_Testberechnung.html";
	my $dat = $PATH_SSL."cgi-bin/vers2002/pdfoutput/".$dateiname;
	open (INPUT, ">".$dat);
	print INPUT "<b>Request<b><br>";
	print INPUT $input."<br><br>";
	print INPUT "URL: ".$url."<br>";
	print INPUT "String L\xE4nge: ".$clength."<br>";
	print INPUT "Nachricht: ".$message."<br>";
	print INPUT "Erfolgreich: ".$is_success."<br><br>";
	print INPUT "<b>Response<b><br>";
	print INPUT $output."\n";
	close (INPUT);
}

# soap-inc.pl, is besser so
sub setElContByID {
	
	## muss elementname uebergeben werden? eigentlich nicht
	## 	mal ehrlich: wenn ich eine ID habe, die eindeutig sein muss, dann muss doch der Elementname egal sein?
	## das Ganze ist XML! also " nicht ' und alles sauber
	## PS: So Leute wie AL sind nicht ganz sauber
	my ($text, $idnam, $idid, $cont, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $attpos, $idpos, $attvalstart, $attvalend, $endeel, $elnam);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## ID finden case-sensitiv
	if ( ($nextpos = index($text, "$idnam=\"$idid\"", $pos)) < 0 ) { 
		return(undef); 
	}
	
	## Element-Tag start
	if ( ($starttag = rindex($text, "<", $nextpos)) < 0 ) { 
		return(undef); 
	}

	## Element-Tag ende
	if ( ($endetag = index($text, ">", $nextpos)) < 0 ) { 
		return(undef); 
	}


	$tempstring = substr($text, $starttag, $endetag - $starttag);
	## gefunden! jetzt Elementname suchen
	if ($tempstring =~ m/<([^ >\t\r\n]+)[ >\t\r\n]/) {
		$elnam = $1;
	} else {
		return(undef);
	}

	## gefunden! jetzt Endetag suchen
	if ( ($endeel = index($text, "</$elnam>", $endetag)) < 0 ) { 
		return(undef); 
	}
	my $endetaglen = length("</$elnam>");

	## Beispiel:
	## 0         1         2         3
	## 0123456789012345678901234567890
	## <e a="ac"></e>
	## nextpos=3; starttag=0; endetag=9; endeel=10;
	substr($text, $endetag + 1, $endeel - ($endetag + 1)) = $cont;
	##            9        + 1, 10      - (9        + 1))
	##            10          , 10      - 10
	##            10          , 0
	return ($text);
}

sub setAttByID {
	
	## muss elementname uebergeben werden? eigentlich nicht
	## 	mal ehrlich: wenn ich eine ID habe, die eindeutig sein muss, dann muss doch der Elementname egal sein?
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $idnam, $idid, $attnam, $attval, $attneu, @rest) = @_;
	my $query = \%main::query;
	#&reportmail(&innomail('TH'),&innomail('TH'),'',"sniver.pm--setAttById","soll setzen $attnam=\"$attval\" bei $idnam=\"$idid\"");
	## attneu soll true sein, wenn das attribut nicht vorhanden ist aber neu geschrieben werden soll
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $attpos, $idpos, $attvalstart, $attvalend);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	if ( ($nextpos = index($text, "$idnam=\"$idid\"", $pos)) < 0 ) { 
		$$query{'sniver-err-setAttByID'} .= "not found: $idnam=\"$idid\";";
		return(undef); 
	}
	
	## Element-Tag start
	if ( ($starttag = rindex($text, "<", $nextpos)) < 0 ) { 
		$$query{'sniver-err-setAttByID'} .= "not found: El-start ($idnam=\"$idid\");";
		return(undef); 
	}

	## Element-Tag ende
	if ( ($endetag = index($text, ">", $nextpos)) < 0 ) { 
		$$query{'sniver-err-setAttByID'} .= "not found: El-end ($idnam=\"$idid\");";
		return(undef); 
	}

	$tempstring = substr($text, $starttag, $endetag - $starttag);
	## gefunden! jetzt anderes Attribut suchen
 	if ($tempstring =~ m/($attnam *=")[^"]*"/) {
		## doch eher anders oder?
		#$attvalstart = index($text, $attnam, $nextpos) + length($attnam) + 2;
		## so:
		#$attvalstart = index($text, $attnam, $starttag) + length($attnam) + 2;
		## nochmal anders wegen Leerzeichen zwischen value und =
		$attvalstart = index($text, $attnam, $starttag) + length($1);
		$attvalend = index($text, '"', $attvalstart);
		substr($text, $attvalstart, $attvalend - $attvalstart) = $attneu;
		return ($text);
	} elsif ($attneu) {
		substr($text, $endetag, 1) = " $attnam=\"$attneu\">";
		return ($text);
	} else {
		## Attribut nicht gefunden, kacke
		$$query{'sniver-err-setAttByID'} .= "not found: Att ($idnam=\"$idid\") - not possible;";
		return (undef);
		#&reportmail(&innomail('TH'),&innomail('TH'),'',"sniver.pm--setAttById-- Fehler","KONNTE NICHT setzen $attnam=\"$attval\" bei $idnam=\"$idid\"");
	}
}

sub setElCont {
	
	## Element Content setzen, Element muss eindeutig sein, keine rekursiven Verschachtelungen (letzteres ergibt sich aus vorherigem)
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $elnam, $cont, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $endeel, $endetaglen, $templen);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;
	my $query = \%main::query;

	$templen = length($text);
	#$main::query{'debug'} = 1;
	webreport("sniver.pm: in setElCont, text-Laenge: $templen ") if ($main::query{'debug'});
	 
	## case-sensitiv
	if ( ($nextpos = index($text, "<$elnam>", $pos)) < 0 ) { 
		if ( ($nextpos = index($text, "<$elnam ", $pos)) < 0 ) { 
			webwarnung("setElCont nicht gefunden '< $elnam'") if ($main::query{'debug'});
			$$query{'sniver-err-setElCont'} .= "nicht gefunden '< $elnam';";
			return(undef); 
		}
	}
	
	## Element-Tag start
	$starttag = $nextpos; 

	webreport("sniver.pm: setElCont: vor Element-Tag ende ") if ($main::query{'debug'});
	## Element-Tag ende
	if ( ($endetag = index($text, ">", $nextpos)) < 0 ) { 
		webwarnung("setElCont nicht gefunden '< $elnam .. >'") if ($main::query{'debug'});
		$$query{'sniver-err-setElCont'} .= "nicht gefunden '< $elnam .. >';";
		return(undef); 
	}

	webreport("sniver.pm: setElCont: vor gefunden (tempstring) ") if ($main::query{'debug'});
	$tempstring = substr($text, $starttag, $endetag - $starttag);
	## gefunden! jetzt Endetag suchen
	webreport("sniver.pm: setElCont: vor endeel ") if ($main::query{'debug'});
	if ( ($endeel = index($text, "</$elnam>", $pos)) < 0 ) { 
		webwarnung("setElCont nicht gefunden '</ $elnam>'") if ($main::query{'debug'});
		$$query{'sniver-err-setElCont'} .= "nicht gefunden '</ $elnam>';";
		return(undef); 
	}
	$endetaglen = length("</$elnam>");

	webreport("setElCont ersetze in text inhalt mit neuer Laenge: ".length($cont)) if ($main::query{'debug'});
	substr($text, $endetag + 1, $endeel - ($endetag + 1)) = $cont;
	#delete $main::query{'debug'};
	return ($text);
}

sub setElAttByID {
	
	## muss elementname uebergeben werden? eigentlich nicht
	## 	mal ehrlich: wenn ich eine ID habe, die eindeutig sein muss, dann muss doch der Elementname egal sein?
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $elnam, $idnam, $idid, $attnam, $attval, @rest) = @_;
	my %query = %main::query;
	print "\n<hr>\n" if( $query{'user'} =~ m/^THOFMANN$/);
	print "\n<p>elnam:$elnam, idnam:$idnam, idid:$idid, attnam:$attnam, attval:$attval</p>" if( $query{'user'} =~ m/^THOFMANN$/);
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $tempstring, $attpos, $idpos, $attvalstart, $attvalend, $temp, $diff);
	my $maxcode = 100;
	$pos = 0;
	
	## case-sensitiv
	if ( ($nextpos = index($text, "<$elnam", $pos)) < 0 ) { 
	print "\n<p>nextpos vor schleife < 0</p>\n";
		return(undef); 
	} else {
		print "\n<p>nextpos vor schleife:$nextpos</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
		$temp = &codesyntax(substr($text,$nextpos,$maxcode));
		print "\n<p>inhalt:$temp</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
	}
	bisgefunden:
	while (!($found) && !($ende)) {
		print "\n<p>in schleife</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
		## nicht gefunden aber zu ende
		$nextpos = index($text, "<$elnam", $pos);
		if ($nextpos < 0) {
			print "\n<p>tempstring nicht gefunden aber zu ende</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
			$ende = 1;
			return (undef);
			last (bisgefunden);
		} else {
			$diff = $nextpos - $pos;
			print "\n<p>nextpos gefunden bei [$nextpos], pos=[$pos], diff=[$diff]</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
			print "\n<p>Tempstring nextpos (das ist davor):[". &codesyntax(substr($text, $pos, $diff))."]</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
		}
		## ">" nicht gefunden, kein vollstaendiges tag
		$endetag = index($text, ">", $nextpos);
		if ($endetag < 0) {
			print "\n<p>'>' nicht gefunden, kein vollstaendiges tag</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
			$ende = 1;
			return (undef);
			last (bisgefunden);
		} else {
			$diff = $endetag - $nextpos;
			print "\n<p>endetag gefunden bei [$endetag], nextpos=[$nextpos], diff=[$diff]</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
			print "\n<p>Tempstring endetag=[$endetag], nextpos=[$nextpos]:[". &codesyntax(substr($text, $nextpos, $diff))."]</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
		}
		$diff = $endetag - $nextpos;
		$tempstring = substr($text, $nextpos, $diff);
		print "\n<p>tempstring  endetag=[$endetag], nextpos=[$nextpos], diff=[$diff]:" . &codesyntax($tempstring) . "</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
		## wenn "<" vorhanden dann fehler
		if (index($tempstring, "<") > 0) {
			print "\n<p>wenn '<' vorhanden dann fehler</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
			$ende = 1;
			return (undef);
			last (bisgefunden);
		}
		## jetzt soweit okay, weitermachen
		## ID suchen
		if ($tempstring =~ m/$idnam="$idid"/) {
			$found = 1;
		} else {
			$pos = $endetag;
		}
	}
	## gefunden! jetzt anderes Attribut suchen
	print "\n<p>ausserhalb schleife tempstring:" . &codesyntax($tempstring) . "</p>\n" if( $query{'user'} =~ m/^THOFMANN$/);
	if ($tempstring =~ m/$attnam="[^"]*"/) {
		$attvalstart = index($text, $attnam, $nextpos) + length($attnam) + 2;
		$attvalend = index($text, '"', $attvalstart);
		substr($text, $attvalstart, $attvalend - $attvalstart) = $attval;
		return ($text);
	} else {
		## Attribut nicht gefunden, kacke
		return (undef);
	}
}

sub getElCont {
	
	## Element Content zurueck geben, Element muss eindeutig sein, keine rekursiven Verschachtelungen (letzteres ergibt sich aus vorherigem)
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $elnam, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $endeel, $endetaglen, $suche, $endsuche);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	$suche = '<' . $elnam;
	if ($text =~ m/$suche/is) { $suche = $&; } else {
		#return("Fehler - getElCont match: '\&lt;$elnam' nicht gefunden (suche[" . &codesyntax($suche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$nextpos = index($text, $suche, $pos);
	if ( $nextpos < 0 ) { 
		return(undef); 
		#return("Fehler - getElCont: '\&lt;$elnam' nicht gefunden bei pos[$pos]-->nextpos[$nextpos] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	
	## Element-Tag start
	$starttag = $nextpos; 

	## Element-Tag ende
	$endsuche = '>';
	if ($text =~ m/$endsuche/is) { $endsuche = $&; } else {
		#return("Fehler - getElCont match Ende: '\&gt;' nicht gefunden (endsuche[" . &codesyntax($endsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetag = index($text, $endsuche, $nextpos);
	if ( $endetag < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&gt;\"  nicht gefunden bei nextpos[$nextpos]-->endetag[$endetag] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}

	$tempstring = substr($text, $starttag, $endetag - $starttag);
	## gefunden! jetzt Endetag suchen
	my $endtagsuche = '</' . $elnam . '>';
	if ($text =~ m/$endtagsuche/is) { $endtagsuche = $&; } else {
		#return("Fehler - getElCont match EndeTag: '\&lt;/$elnam\&gt;' nicht gefunden (endtagsuche[" . &codesyntax($endtagsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endeel = index($text, $endtagsuche, $pos);

	if ( $endeel < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&lt;/$elnam\&gt;\" nicht gefunden bei pos[$pos]-->endeel[$endeel] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetaglen = length($endtagsuche);

	return (substr($text, $endetag + 1, $endeel - ($endetag + 1)));
}

sub getElStart {
	
	## Element Start zurueck geben, Element muss eindeutig sein, keine rekursiven Verschachtelungen (letzteres ergibt sich aus vorherigem)
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $elnam, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $endeel, $endetaglen, $suche, $endsuche);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	$suche = '<' . $elnam;
	if ($text =~ m/$suche/is) { $suche = $&; } else {
		#return("Fehler - getElCont match: '\&lt;$elnam' nicht gefunden (suche[" . &codesyntax($suche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$nextpos = index($text, $suche, $pos);
	if ( $nextpos < 0 ) { 
		return(undef); 
		#return("Fehler - getElCont: '\&lt;$elnam' nicht gefunden bei pos[$pos]-->nextpos[$nextpos] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	
	## Element-Tag start
	$starttag = $nextpos; 
	return($starttag); 

}
sub getElEnd {
	
	## Element Content zurueck geben, Element muss eindeutig sein, keine rekursiven Verschachtelungen (letzteres ergibt sich aus vorherigem)
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $elnam, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $endeel, $endetaglen, $suche, $endsuche);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	$suche = '<' . $elnam;
	if ($text =~ m/$suche/is) { $suche = $&; } else {
		#return("Fehler - getElCont match: '\&lt;$elnam' nicht gefunden (suche[" . &codesyntax($suche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$nextpos = index($text, $suche, $pos);
	if ( $nextpos < 0 ) { 
		return(undef); 
		#return("Fehler - getElCont: '\&lt;$elnam' nicht gefunden bei pos[$pos]-->nextpos[$nextpos] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	
	## Element-Tag start
	$starttag = $nextpos; 

	## Element-Tag ende
	$endsuche = '>';
	if ($text =~ m/$endsuche/is) { $endsuche = $&; } else {
		#return("Fehler - getElCont match Ende: '\&gt;' nicht gefunden (endsuche[" . &codesyntax($endsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetag = index($text, $endsuche, $nextpos);
	if ( $endetag < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&gt;\"  nicht gefunden bei nextpos[$nextpos]-->endetag[$endetag] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}

	$tempstring = substr($text, $starttag, $endetag - $starttag);
	## gefunden! jetzt Endetag suchen
	my $endtagsuche = '</' . $elnam . '>';
	if ($text =~ m/$endtagsuche/is) { $endtagsuche = $&; } else {
		#return("Fehler - getElCont match EndeTag: '\&lt;/$elnam\&gt;' nicht gefunden (endtagsuche[" . &codesyntax($endtagsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endeel = index($text, $endtagsuche, $pos);

	if ( $endeel < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&lt;/$elnam\&gt;\" nicht gefunden bei pos[$pos]-->endeel[$endeel] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetaglen = length($endtagsuche);

	return ($endeel + $endetaglen);
}
sub getElStartEnd {

	#print ">>> $main::query{'xmlchange'} <<<\n";
	#print ">>> $query{'xmlchange'} <<<\n";
	print "\n>>> In getElStartEnd <<<\n"  if( $main::query{'xmlchange'} );
	#exit;
	## Element Content zurueck geben, Element muss eindeutig sein, keine rekursiven Verschachtelungen (letzteres ergibt sich aus vorherigem)
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $elnam, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $endeel, $endetaglen, $suche, $endsuche);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;
	$endetag = 0;
	#reportmail( innomail('TH'), innomail('TH'), '', "sniver.pm: getElStartEnd: Beginn", "Laenge text:[".length($text)."] - Element:[$elnam]");

	## case-sensitiv
	my $isempty = undef;
	$main::query{'isempty'} = undef;
	$suche = '<' . $elnam;
	if ($text =~ m/$suche/is) { $suche = $&; } else {
		#return("Fehler - getElCont match: '\&lt;$elnam' nicht gefunden (suche[" . &codesyntax($suche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$nextpos = index($text, "$suche>", $pos);
	if ( $nextpos < 0 ) { 
		$nextpos = index($text, "$suche ", $pos);
		if ( $nextpos < 0 ) {
			$nextpos = index($text, "$suche/>", $pos);
			if ( $nextpos < 0 ) { 
				return(undef); 
			} else {
				$isempty = 1;
				$endetag = $nextpos + length( "$suche/>" ) -1; # Ende Starttag schon gefunden
				print "\n___getElStartEnd: suche[$suche]'/>' an Position[$nextpos]\n" if( $main::query{'xmlchange'} );
			}
		} else {
			print "\n___getElStartEnd: suche[$suche]' ' an Position[$nextpos]\n" if( $main::query{'xmlchange'} );
		}
		#return("Fehler - getElCont: '\&lt;$elnam' nicht gefunden bei pos[$pos]-->nextpos[$nextpos] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	} else {
		$endetag = $nextpos + length( "$suche>" ) -1; # Ende Starttag schon gefunden
		# '...<ele>'
		#  01234567
		# 3 + 5 -1 = 7
		print "\n___getElStartEnd: suche[$suche]'>' an Position[$nextpos]\n" if( $main::query{'xmlchange'} );
	}
	
	## Element-Tag start
	$starttag = $nextpos; 

	## Element-Tag ende, ausser ich hab das ende schon also eigentlich nur bei '<ele '
	$endsuche = '>';
	if ( !$endetag ) {
		if ($text =~ m/$endsuche/is) { $endsuche = $&; } else {
			#return("Fehler - getElCont match Ende: '\&gt;' nicht gefunden (endsuche[" . &codesyntax($endsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
		}
		$endetag = index($text, $endsuche, $nextpos);
		if ( $endetag < $nextpos ) {
			print "\n___getElStartEnd: ![$endsuche] f. elnam[$elnam] Pos.[$nextpos] NOT, endetag[$endetag]\n" if( $main::query{'xmlchange'} );
		} else {
			print "\n___getElStartEnd: [$endsuche] f. elnam[$elnam] Pos.[$nextpos] at endetag[$endetag]\n" if( $main::query{'xmlchange'} );
		}
	}
	if ( $endetag < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&gt;\"  nicht gefunden bei nextpos[$nextpos]-->endetag[$endetag] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	} else {
		print "___getElStartEnd:  endsuche[$endsuche] an Position[$endetag]\n" if( $main::query{'xmlchange'} );
	}

	$tempstring = substr($text, $starttag, $endetag - $starttag + 1); # +1 weil der index bei 0 beginnt
		print "___getElStartEnd:  tempstring[$tempstring] ab [$starttag] bis [$endetag]\n" if( $main::query{'xmlchange'} );
		# '...<ele>'
		#  01234567
		# 3 + 5 -1 = 7

	## gefunden! jetzt Endetag suchen
	## .. ausser es ist ein empty element, schon mal oben festlegen

	if ( substr( $tempstring, -2 ) eq '/>' ) {
		print "___getElStartEnd: IsEmpty tempstring[$tempstring] ab [$starttag] bis [$endetag]\n" if( $main::query{'xmlchange'} );
		$isempty = 1; $main::query{'isempty'} = 1; 
		#print 'Harter Abbruch bei =~ /\/>$/'." in [$tempstring]"; exit;
		print "getElStartEnd: [/>] endetag[$endetag] = [" . substr( $text, $endetag, 1 ) . "]\n" if( $main::query{'xmlchange'} ); 
#		exit;
		return( $starttag, $endetag + 1 );
	}
	$main::query{'isempty'} = 1 if ( $isempty );
	#die "stirb langsam in getElStartEnd\n" if $main::query{'xmlchange'};
	my $endtagsuche = '</' . $elnam . '>';
	
	if ($text =~ m/$endtagsuche/is) { $endtagsuche = $&; } else {
		#return("Fehler - getElCont match EndeTag: '\&lt;/$elnam\&gt;' nicht gefunden (endtagsuche[" . &codesyntax($endtagsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	if ( !$isempty ) {
		$endeel = index($text, $endtagsuche, $pos);
		print "___getElStartEnd:  endeel =[$endeel] fuer endtagsuche[$endtagsuche] ab pos[$pos] in Text:\n", markPos( substr($text,$pos,100), $endeel ) if( $main::query{'xmlchange'} );
	} else {
		$endeel = $endetag;
		return ( $starttag, $endeel );
	}
	
	if ( $endeel < 0 ) { 
		return( $starttag, undef ); 
		#return("Fehler: getElCont: \"\&lt;/$elnam\&gt;\" nicht gefunden bei pos[$pos]-->endeel[$endeel] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetaglen = length($endtagsuche);

		print "\n___getElStartEnd:  RETURN starttag[$starttag] endeel[$endeel] + endetaglen[$endetaglen] in Text:\n", markPos( substr($text,$pos,100), $endeel ) if( $main::query{'xmlchange'} );
	return ( $starttag, $endeel + $endetaglen );
}

sub markPos {
	my ( $text, $pos, $mark, @rest ) = @_;
	if ( !$mark ) { $mark = '<#>'; }
	if ( $pos < 0 ) {
		substr( $text, 0, 0 ) = "markPos: pos[$pos] < 0 $mark";
	} elsif ( $pos > length( $text ) ) {
		my $x = length($text);
		$text .= "markPos: pos[$pos] > length(text)[$x] $mark";
	} else {
		substr( $text, $pos, 0 ) = $mark;
	}
	#print "\n-----[$text]-----\n";
	return( $text );
}

sub getElContVorsatz {
	
	## Element Content zurueck geben, Element muss eindeutig sein, keine rekursiven Verschachtelungen (letzteres ergibt sich aus vorherigem)
	## Vorsatz vor Tagname 'xyz:' beliebig
	## das Ganze ist XML! also " nicht ' und alles sauber
	## @rest[0] koennte 'debug' enthalten fuer debug-ausgaben
	my ($text, $elnam, @rest) = @_;
	if( $rest[0] =~ m/debug/i ) { reportmail( innomail('TH'), innomail('TH'), '', "sniver.pm: getElContVorsatz", "_____text _____\n$text\n_____ elnam _____\n$elnam\n_____" ); }
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $endeel, $endetaglen, $suche, $endsuche);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	## das geht nicht, Mist!
	$suche = '<(.*?:)?' . $elnam;
	my ($vorsatz, $suchevoll, $elnamvoll) = ('', $suche, $elnam);
	my $match = '[a-z0-9_\.]+:';
	#if ($text =~ m/<([a-z0-9_\.]+:)?$elnam/is) { 
	if ($text =~ m/<($match)?$elnam/is) { 
		$suche = $&; 
		$vorsatz = $1;
		$elnamvoll = $vorsatz . $elnam;
	} else {
		# #return("Fehler - getElContVorsatz match: '\&lt;(.*?:)?$elnam' nicht gefunden (suche[" . &codesyntax($suche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
		#return("Fehler - getElContVorsatz match: '\&lt;($match)?$elnam' nicht gefunden (suche[" . &codesyntax($suche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$nextpos = index($text, $suche, $pos);
	if ( $nextpos < 0 ) { 
		return(undef); 
		#return("Fehler - getElContVorsatz: '\&lt;$vorsatz$elnam' nicht gefunden bei pos[$pos]-->nextpos[$nextpos] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	
	## Element-Tag start
	$starttag = $nextpos; 

	## Element-Tag ende
	$endsuche = '>';
	if ($text =~ m/$endsuche/is) { 
		$endsuche = $&; 
	} else {
		#return("Fehler - getElCont match Ende: '\&gt;' nicht gefunden (endsuche[" . &codesyntax($endsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetag = index($text, $endsuche, $nextpos);
	if ( $endetag < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&gt;\"  nicht gefunden bei nextpos[$nextpos]-->endetag[$endetag] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}

	$tempstring = substr($text, $starttag, $endetag - $starttag);
	## gefunden! jetzt Endetag suchen
	my $endtagsuche = '</' . $elnamvoll . '>';
	if ($text =~ m/$endtagsuche/is) { 
		$endtagsuche = $&; 
	} else {
		#return("Fehler - getElCont match EndeTag: '\&lt;/$elnam\&gt;' nicht gefunden (endtagsuche[" . &codesyntax($endtagsuche) . "]) in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endeel = index($text, $endtagsuche, $pos);

	if ( $endeel < 0 ) { 
		return(undef); 
		#return("Fehler: getElCont: \"\&lt;/$elnam\&gt;\" nicht gefunden bei pos[$pos]-->endeel[$endeel] in text ---[" . &codesyntax($text) . "]---</br>\n"); 
	}
	$endetaglen = length($endtagsuche);

	return (substr($text, $endetag + 1, $endeel - ($endetag + 1)), $elnamvoll);
}

sub responseBodyLeer {
	my ($response, @rest) = @_;
	my $responseOK = "<?xml version='1.0' encoding='UTF-8'?>" . 
	'<isns:Envelope xmlns:isns="http://schemas.xmlsoap.org/soap/envelope/">' . 
	'<isns:Body xmlns:isns="http://schemas.xmlsoap.org/soap/envelope/" /></isns:Envelope>';
	if (
		($response =~ m/<([a-z0-9_\-\.]+:)?body[^>]*\/>/i) 
		#||
		#($response =~ m/<(([a-z0-9_\-\.]+:)?body)( [^>\/]+)?>[ \t\r\n]*<\/\1>/i)
	) {
		return(1);
	} else {
		return('');
	}
}

sub responseIsErrorRhion {
	my ($response, $doreport, @rest) = @_;
	my $StatusIDOK = '01020';	
	my ($StatusID, $tempel) = &getElContVorsatz($response, 'StatusID');
	if ($doreport) {&webreport("StatusID[$StatusID]");}
	if ($StatusID ne $StatusIDOK) {
		if ($doreport) {&webwarnung("StatusID[$StatusID] NE! StatusIDOK[$StatusIDOK]");}
		return(1);
	} else {
		if ($doreport) {&webreport("StatusID[$StatusID] eq StatusIDOK[$StatusIDOK]");}
		return(undef);
	}
}

## alten Stand sichern, jetzt mal neu versuchen mit beliebigem Vorsatz
sub responseBodyFehler {
	## aus der Webservice Response die Fehler versuchen auszulesen, hier momentan Rhion-spezifisch
	my ($response, @rest) = @_;
	my $eh = 'responseBodyFehler';
#	my $axis = undef;
#	if ($response =~ m/(axis2ns[0-9]{1,3}):/) {
#		$axis = $1;
#	} else {
#		$axis = 'axis2nsXXX';
#	}

	## fuer Path von Elementen die Eltern-Elemente per '/' getrennt voran stellen
	my (@el) = (
		'faultcode',
		'faultstring',
		'StatusId',
		'Text',
		'ArtId',
		'MeldungId',
		'Meldung/Text',
		'Quelle',
	);
	my ($i, $t, $r, $teil, $dummy, $el, $elvoll, $elneu);
	for ($i = 0; $i <= $#el; $i++) {
		$teil = $response;
		$el = $el[$i];
		$elneu = '';
#		if ($axis) { $el =~ s/axis2ns.../$axis/g; }
		while ($el =~ m/\//i) {
			#print "<p>$eh : el[$el]</p>\n";
			($dummy, $el) = split(/\//, $el, 2);
			#print "<p>$eh : dummy[$dummy]--el[$el]</p>\n";
			($teil, $elvoll) = &getElContVorsatz($teil, $dummy);
			$elneu .= $elvoll . '/';
		}
		($t, $elvoll) = &getElContVorsatz($teil, $el);
			$elneu .= $elvoll;
		if ($t) { $r .= $elneu . "=$t\n"; }
	}
	if ($r =~ m/^[ \t\r\n]*$/i) { $r = $response; }
	return($r);
}

## alten Stand sichern, jetzt mal neu versuchen mit beliebigem Vorsatz
sub responseBodyFehler0 {
	## aus der Webservice Response die Fehler versuchen auszulesen, hier momentan Rhion-spezifisch
	my ($response, @rest) = @_;
	my $eh = 'responseBodyFehler';
	my $axis = undef;
	if ($response =~ m/(axis2ns[0-9]{1,3}):/) {
		$axis = $1;
	} else {
		$axis = 'axis2nsXXX';
	}
	## fuer Path von Elementen die Eltern-Elemente per '/' getrennt voran stellen
	my (@el) = (
		'faultcode',
		'faultstring',
		'bipro:StatusId',
		'bipro:Text',
		'axis2ns797:ArtId',
		'axis2ns797:MeldungId',
		'axis2ns797:Quelle',
		'bipro:ArtId',
		'bipro:MeldungId',
		'bipro:Meldung/bipro:Text',
		'bipro:Quelle',
	);
	my ($i, $t, $r, $teil, $dummy, $el);
	for ($i = 0; $i <= $#el; $i++) {
		$teil = $response;
		$el = $el[$i];
		if ($axis) { $el =~ s/axis2ns.../$axis/g; }
		while ($el =~ m/\//i) {
			#print "<p>$eh : el[$el]</p>\n";
			($dummy, $el) = split(/\//, $el, 2);
			#print "<p>$eh : dummy[$dummy]--el[$el]</p>\n";
			$teil = &getElCont($teil, $dummy);
		}
		$t = &getElCont($teil, $el);
		if ($t) { $r .= $el . "=$t\n"; }
	}
	return($r);
}

sub getElByID {
	
	## muss elementname uebergeben werden? eigentlich nicht
	## 	mal ehrlich: wenn ich eine ID habe, die eindeutig sein muss, dann muss doch der Elementname egal sein?
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $idnam, $idid, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $attpos, $idpos, $attvalstart, $attvalend, 
		$beginntag, $startendtag, $endeendtag, $elnam, $elganz);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	if ( ($nextpos = index($text, "$idnam=\"$idid\"", $pos)) < 0 ) { 
		$ENV{'soapincerr'} = "idnam[$idnam]=[$idid] nicht gefunden";
		return(undef); 
	}
	
	## Element-Tag start
	if ( ($starttag = rindex($text, "<", $nextpos)) < 0 ) { 
		$ENV{'soapincerr'} = "Beginn '<' vor [$nextpos] in text---[$text]--- nicht gefunden";
		return(undef); 
	}

	## Element-Tag ende
	if ( ($endetag = index($text, ">", $nextpos)) < 0 ) { 
		$ENV{'soapincerr'} = "Ende '>' nach [$nextpos] in text---[$text]--- nicht gefunden";
		return(undef); 
	}

	$beginntag = substr($text, $starttag, $endetag - $starttag);
	#$tempstring = $beginntag;
	## gefunden! 
	## Elementname ermitteln
	if ($beginntag =~ m/^<([a-z0-9_\-\.]+)([^a-z0-9_\-\.])/is) {
		$elnam = $1;
	} else {
		## Elementname nicht gefunden, Mist
		$ENV{'soapincerr'} = "Elementname nicht gefunden in text---[$text]--- ";
		return (undef);
	}
	
	## jetzt Ende-Tag des Elementes suchen
	$startendtag = index($text, "</$elnam>", $endetag);
	if (!($startendtag) || ($startendtag < $endetag)) {
		$ENV{'soapincerr'} = "Ende Element [$elnam] nicht gefunden in text---[$text]--- ";
		return (undef);
	}
	
	$endeendtag = $startendtag + length($elnam) + 2;
	$elganz = substr($text, $starttag, $endeendtag - $starttag + 1);
	
	return ($elganz);
}

sub getElStartTagByID {
	
	## muss elementname uebergeben werden? eigentlich nicht
	## 	mal ehrlich: wenn ich eine ID habe, die eindeutig sein muss, dann muss doch der Elementname egal sein?
	## das Ganze ist XML! also " nicht ' und alles sauber
	my ($text, $idnam, $idid, @rest) = @_;
	my ($aktel, $found, $pos, $nextpos, $ende, $endetag, $starttag, $tempstring, $attpos, $idpos, $attvalstart, $attvalend, 
		$beginntag, $startendtag, $endeendtag, $elnam, $elganz);
	my $maxback = 1000;  ## wieviele Zeichen geh ich maximal zurueck von der Fundstelle
	$pos = 0;

	## case-sensitiv
	if ( ($nextpos = index($text, "$idnam=\"$idid\"", $pos)) < 0 ) { 
		$ENV{'soapincerr'} = "idnam[$idnam]=[$idid] nicht gefunden";
		return(undef); 
	}
	
	## Element-Tag start
	if ( ($starttag = rindex($text, "<", $nextpos)) < 0 ) { 
		$ENV{'soapincerr'} = "Beginn '<' vor [$nextpos] in text---[$text]--- nicht gefunden";
		return(undef); 
	}

	## Element-Tag ende
	if ( ($endetag = index($text, ">", $nextpos)) < 0 ) { 
		$ENV{'soapincerr'} = "Ende '>' nach [$nextpos] in text---[$text]--- nicht gefunden";
		return(undef); 
	}

	$beginntag = substr($text, $starttag, $endetag - $starttag + 1);
	#$tempstring = $beginntag;
	## gefunden! 
	## Elementname ermitteln
	if ($beginntag =~ m/^<([a-z0-9_\-\.]+)([^a-z0-9_\-\.])/is) {
		$elnam = $1;
	} else {
		## Elementname nicht gefunden, Mist
		$ENV{'soapincerr'} = "Elementname nicht gefunden in text---[$text]--- ";
		return (undef);
	}
	
	return ($beginntag);
}

sub wsFehlerseiteAbbruch {
	my ($zusatz, $action, $contenttype, @rest) = @_;

	if ($contenttype ne "0") {
	print "Content-type: text/html\n\n";
	}
	my $wserr = &satz_webservice_fehler('', $action);
	my ($datu, $zeit) = &getdatetimehuman();
	my ($name, $firma) = ('', $main::query{'name'});
	if ($main::query{'name'}) {
		($name, $firma) = split(/ ?\- ?/, $main::query{'name'});
	}
	
	print <<__WS_ERROR__;
<html>
<head>
	<title>Fehler Webservice</title>
	<style type="text/css"><!--
		body { font-family: Arial, sans-serif; }
	-->
	</style>
<head>
<body>
	<h3>Fehler Webservice</h3>
$wserr

<p>Zeitpunkt: $datu, $zeit</p>

<p><b>$firma
<br>$name</b>
<br>$main::query{'adresse'}
<br>$main::query{'plz'} $main::query{'ort'}
<br>
<br>Tel.: $main::query{'tel'}
<br>Fax.: $main::query{'fax'}
</p>

$zusatz

</body>
</html>
	
__WS_ERROR__
	exit;
}

## fuer die Wuerttembergische ist wieder nichts recht, nur Sonderlocken.
sub wsFehlerseiteAbbruchWW {
	#my ($zusatz, $action, $contenttype, @rest) = @_;
	my ($contenttype, @rest) = @_;
	my ($zusatz, $action);
	
	if ($contenttype ne "0") {
	print "Content-type: text/html\n\n";
	}
	#print "<p>contenttype: [$contenttype]</p>\n";
	my $wserr = &satz_webservice_fehler('', $action);
	my ($datu, $zeit) = &getdatetimehuman();
	my ($name, $firma) = ('', $main::query{'name'});
	if ($main::query{'name'}) {
		($name, $firma) = split(/ ?\- ?/, $main::query{'name'});
	}
	
	print <<__WS_ERROR_WW__;
<html>
<head>
	<title>Fehler Webservice</title>
	<style type="text/css"><!--
		body { font-family: Arial, sans-serif; }
	-->
	</style>
<head>
<body>
<p>Die von Ihnen aufgegebene Datentr\&auml;gernummer ist ung\&uuml;ltig bzw. kann nicht zugeordnet werden. 
</p>
<p>Bitte pr\&uuml;fen Sie, ob die Datentr\&auml;gernummer richtig eingegeben wurde. 
</p>
<p>Eventuell wurde die Policierung mit dieser Datentr\&auml;gernummer bereits vorgenommen. 
Bitte wenden Sie sich zur Kl\&auml;rung an Ihren Maklerbetreuer. 
</p>
<p>Vielen Dank.
</p>

<p>Zeitpunkt: $datu, $zeit</p>

</body>
</html>
	
__WS_ERROR_WW__
	exit;
}

sub xberufehtml2 {
	## erwartet wird ein Hash aus Beruf (Name) und zugehoeriger Gefahrgruppe
	## baut HTML mit 2 Teilen: a) select (Beruf->ID = eindeutige Berufs-ID) - b) inputs mit Berufs-ID->Gefahrgruppe
	## kann man gebrauchen wenn ein javascript abfragen will welche Gefahrengruppe ein Beruf ist ueber Werte im HTML
	my %berufegefahr = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	%berufe = &xberufe2keyhash(keys(%berufegefahr));
	@key = sort(keys(%berufe));
	$html = "\t<select name=\"berufehtml\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	for ($i=0; $i<=$#key; $i++) { 
		$html .= "\t\t<option value=\"$key[$i]\">" . $berufe{$key[$i]} . "</option>\n";
		$berufsid{$key[$i]} = $berufe{$key[$i]};
		$tempid = $berufsid{$key[$i]};
		$inputs .= "\t\t<input type=\"hidden\" name=\"$key[$i]\" value=\"" . $berufegefahr{$tempid} . "\">\n";
	}
	$html .= "\t</select>\n";
	$html .= $inputs;
	return($html);
}

sub xberufehtml3 {
	## erwartet wird ein Hash aus Beruf (Name) und zugehoeriger Gefahrgruppe
	## 	baut HTML mit 2 Teilen: a) select (Beruf->ID = eindeutige Berufs-ID) - b) inputs mit Berufs-ID->Gefahrgruppe
	## 	zusaetzlich c) inputs mit Berufs-ID->Berufname
	## kann man gebrauchen wenn ein javascript abfragen will welche Gefahrengruppe ein Beruf ist ueber Werte im HTML
	my %berufegefahr = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	%berufe = &xberufe2keyhash(keys(%berufegefahr));
	@key = sort(keys(%berufe));
	$html = "\t<select name=\"berufehtml\" onchange=\"changevalue\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	for ($i=0; $i<=$#key; $i++) { 
		$html .= "\t\t<option value=\"$key[$i]\">" . $berufe{$key[$i]} . "</option>\n";
		$berufsid{$key[$i]} = $berufe{$key[$i]};
		$tempid = $berufsid{$key[$i]};
		$inputs .= "\t\t<input type=\"hidden\" name=\"$key[$i]\" value=\"" . $berufegefahr{$tempid} . "\">\n";
		$inputs .= "\t\t<input type=\"hidden\" name=\"x_$key[$i]\" value=\"" . $berufe{$key[$i]} . "\">\n";
	}
	$html .= "\t</select>\n";
	$html .= $inputs;
	return($html);
}

sub xberufehtml4 {
	## erwartet werden zwei Hashref: id->beruf; id->gefahr
	## 	baut
	## 	a) select (Beruf->ID) 
	## 	b) inputs mit Berufs-ID->Gefahrgruppe
	## 	c) inputs mit Berufs-ID->Berufname
	## kann man gebrauchen wenn ein javascript abfragen will welche Gefahrengruppe ein Beruf ist ueber Werte im HTML
	my ($idberuf,$idgefahr,@rest) = @_;
	my ($b, $k, @key, $i, $html, $inputs, %berufe, %berufsid, $tempid);
	# Berufe nach Name sortieren
	my @ids = &hashsortvalkeyarray($idberuf);
	$html = "\t<select name=\"berufehtml\" onchange=\"changevalue\">\n\t\t<option value=\"\">bitte ausw\xE4hlen</option>\n";
	xberufehtml4zeilen:
	for ($i=0; $i<=$#ids; $i++) { 
		if ($ids[$i] =~ m/^[ \t]*$/i) { next xberufehtml4zeilen; }
		$html .= "\t\t<option value=\"$ids[$i]\">" . $$idberuf{$ids[$i]} . "</option>\n";
		$inputs .= "\t\t<input type=\"hidden\" name=\"g_$ids[$i]\" id=\"g_$ids[$i]\" value=\"" . $$idgefahr{$ids[$i]} . "\">\n";
		$inputs .= "\t\t<input type=\"hidden\" name=\"b_$ids[$i]\" id=\"b_$ids[$i]\" value=\"" . $$idberuf{$ids[$i]} . "\">\n";
	}
	$html .= "\t</select>\n";
	return($html,$inputs);
}

sub xberufe2key {
	my @berufe = @_;
	my ($b, $k, @key, $i);
	for ($i=0; $i<=$#berufe; $i++) { push(@key, &xmakeid($berufe[$i])); }
	return(@key);
}

sub xberufe2keyhash {
	my @berufe = @_;
	my ($b, $k, %key, $i);
	for ($i=0; $i<=$#berufe; $i++) { $b = &xmakeid($berufe[$i]); $key{$b} = $berufe[$i]; }
	return(%key);
}

sub xmakeid {
	my ($str, @rest) = @_;
	my $id = (split(/[\r\n]/, $str))[0];
	$id =~ s/^[ \t]+//g;
	$id =~ s/[ \t]+$//g;

	$id =~ s/\xE4/ae/g;
	$id =~ s/\xF6/oe/g;
	$id =~ s/\xFC/ue/g;
	$id =~ s/\xC4/Ae/g;
	$id =~ s/\xD6/Oe/g;
	$id =~ s/\xDC/Ue/g;
	$id =~ s/\xDF/ss/g;

	$id =~ s/[^a-z0-9]/_/ig;
	$id =~ s/__+/_/ig;
	
	return($id);
}

## HOF 09.06.2011; fuer die umwandlung des strings unten in lesbares perl hab ich ein script kundenftp-change.pl
## Inhalt der Variable einfach unter kundenftp.pl speichern, es schaltet bei Aufruf hin und zurueck, sollte ein Programmierer eigentlich damit klar kommen
sub kundenftp {

	## HOF 08.12.2009; zusaetzlich FTP
	## 	KB: KFZ KRAVAG; alle XML und PDF des user DMUD55 nach FTP; inno:sg456sy@degenia.de
	## grosser Mist: af-k will noch:
	## 1. Wir muessen nur dann etwas hochstellen wenn die KUNDEN_ID nicht leer ist und
	## 2. wir muessen wenn wir was hochstellen noch einen Link aufrufen.
	## https://www.a-fk.de/MSC3/triggerinnosystems?prefix=FK&id=XXXXXXX&file1=hallo.pdf&file2=nocheins.xml&file3=..
	## https://www.a-fk.de/MSC3/triggerinnosystems?prefix=FK&id=__VN_ID__&file1=__DATEINAME__
	## Test eigener FTP
	## http://www.th-o.de/cgi-bin/nachricht.pl?from=t*th-o.de&to=toohoo*gmail.com&subject=test-nachricht&zauberwort=bitte&vn_id=__VN_ID__&file1=__DATEINAME__
	## HOF 30.07.2010; Achtung, geht nicht mit doppelten EMail Adressen!

## Achtung! #############################################
# Variablen sind maskiert
# bei Ausdruck der Variable werden \n umgesetzt
# 	aber in der Variablen muessten sie eigentlich erhalten sein
# 	das ist wichtig fuer die Verwendung durch eval
# 	funktioniert nicht, '\n' schreiben als '\x5Cn'
# mal testen an einer vertragsmail
# Variable als _sub in sniver.pm einbauen

my $kundenftp = <<__KUNDENFTP__;
__KUNDENFTP__

$kundenftp = <<__KUNDENFTP_NEU__;
	if (
	      ( (\$query{'bcm'} ne '') && (index(\$too,\$query{'bcm'}) >= 0) ) ||
	      ( (\$query{'bcm'} eq '') && (index(\$too,\$query{'mail'}) >= 0) )
	) {
		#\$zeit = &getdatetime(); ## wird anscheinend ausserhalb festgelegt
		\$pfad = &PDFwebdir();
		(\$datnam, \$content) = &anhangraus(\$anhang{\$aktanh});
		if (!(\$datnam)) { 
			\$datnam = \$query{'session'} . '_' . \$aktanh;
			\$datnam = \$zeit . '-' . \$datnam; 
			if (\$datnam =~ m/xml/i) { \$datnam .= '.xml'; }
			elsif (\$datnam =~ m/pdf/i) { \$datnam .= '.pdf'; }
			elsif (\$datnam =~ m/txt/i) { \$datnam .= '.txt'; }
		} else {
		    if (\$datnam !~ m/PDF\$/i) {
			\$datnam = \$query{'session'}  . '_' . \$datnam;
			\$datnam = \$zeit . '-' . \$datnam;
		    }
		}
		if (\$aktanh =~ m/XML/i) {
			\$content =~ s/(\x5C?>)/\$1\x5Cn<!-- \$dateiname -->/is;
			if (\$dateiname2 ne '') {
				\$content =~ s/(\x5C?>)/\$1\x5Cn<!-- \$dateiname2 -->/is;
			}
		}
		my (\$zwei,\$endung) = ('','');
		\$datnam =~ m/(-2)?\x5C.(...)\$/i; \$zwei = \$1; \$endung = \$2;
		my \$fzdatnam = fz_datnam(\$endung,\$zeit,\$zwei);
		## Finanzzirkel: Gesellschafts-XML bei (alter) Schnittstelle ueberschreibt Inno-XML
		\$fzdatnam =~ m/^(.*?)\x5C.(...)\$/i;
		my ( \$fznam, \$fzext ) = ( \$1, \$2 );
		if ( ( uc(\$fzext) eq 'XML' ) and ( uc(\$aktanh) ne 'XML' ) ) { \$fzdatnam = "\$fznam-gesellschaft.\$fzext"; }
	    reportmail(innomail('TH'),innomail('TH'),'',"kundenftp--fz_datnam", "fzdatnam[\$fzdatnam] zeit[\$zeit]") if (\$query{'user'} =~ m/THOFMANNx/i);
	    my \$fzdat = \$fznam; \$fzdat =~ s/(-2|-gesellschaft)\$//ig;

			    ## redmine 5851: dadurch falsche Dateinamen im XML
			    if ( (\$query{'user'} =~ m/^(FZGC31|THOFMANN)\$/i) and (uc(\$aktanh) eq 'XML') ) {
			    	\$content =~ s/<anhang nr="(\x5Cd+)">.*?(-2|-gesellschaft)?\x5C.([^<]{3})</<anhang nr="\$1">\$fzdat\$2\x5C.\$3</ig;
			    }
		&writefile(\$pfad . \$datnam, \$content, '666');
	    ## bei manchen usern nur hochstellen, wenn Variable belegt
	    \$remkundftp = '';
	    eachuser:
	    foreach \$isuser (keys(\%ftpserver)) {
		if (\$query{'user'} =~ m/\$isuser/) {
			\$remkundftp .= "-\$isuser";
			(\$server, \$benutzer, \$pass, \$verz, \$var, \$act, \$isscp, \$scpkeyfile, \$scpport) = split(/\x5Ct/, \$ftpserver{\$isuser});
			if (\$var) {
			    if (\$var eq 'VN_ID') {
				my \@temp = split(/XYZ/,\$query{'info'});
				#if (\$query{'user'} =~ m/THOFMANN/i) { \@temp = ('XXX'); }
				\$varcont = \$temp[0];
				#if ( !\$varcont && \$query{'VN_ID'} ) { \$varcont = \$query{'VN_ID'}; } # Notloesung, falls VN_ID nicht in info
				\$kundenftpvars{'VN_ID'} = \$varcont;
			    } ## sonst wird \$varcont nicht belegt -> nichts uebertragen
			} else {
				\$varcont = 1;
			}
			if (\$varcont) {
			    ## Conopera moechte andere Dateinamen: 
			    # DatumUhrzeit_Sessionnummer_Betreuer_Sparte_Name_Vorname.GDV/XML
			    ## wann ist es Conopera? mach einen Match
			    my \$conodatnam = '';
			    if (\$query{'user'} =~ m/^(CNP[SR]\x5Cd+)\$/i) { # |THOFMANN
			    	\$conodatnam = \$zeit . "_\$query{'session'}" . "_\$query{'user'}" . 
			    	    "_\$query{'modul'}" . "_\$query{'Nachname'}" . 
			    	    "_\$query{'Vorname'}";
			    	if (\$datnam =~ m/\x5C.xml\$/i) { \$conodatnam .= '.xml'; }
			    	elsif (\$datnam =~ m/\x5C.gdv\$/i) { \$conodatnam .= '.gdv'; }
			    	elsif (\$datnam =~ m/\x5C.csv\$/i) { \$conodatnam .= '.csv'; }
			    	elsif (\$datnam =~ m/\x5C.txt\$/i) { \$conodatnam .= '.txt'; }
			    	elsif (\$datnam =~ m/\x5C.html?\$/i) { \$conodatnam .= '.htm'; }
			    	elsif (\$datnam =~ m/\x5C.pdf\$/i) { \$conodatnam = ''; }
			    	else                          { \$conodatnam .= '.dat'; }
			    } elsif (\$query{'user'} =~ m/^(FZGC31|THOFMANN)\$/i) { # |THOFMANN
			    	\$conodatnam = \$fzdatnam;
			    }
			    ##   \$server, \$login, \$passwd, \$datei, \$remotedir, \$localdir, \$remotefile
			    &ftp(\$server, \$benutzer, \$pass, \$datnam, \$verz, \$pfad, \$conodatnam, \$isscp, \$scpkeyfile, \$scpport);
			    ## Bei PDF das neue 2. PDF auch uebertragen *ARGH*
			    if ((\$datnam =~ m/\x5C.PDF\$/i) && (\$dateiname2 ne '')) {
			    	my \$conodatnam2 = \$datnam;
					if (\$query{'user'} =~ m/^(FZGC31|THOFMANN)\$/i) {
						\$conodatnam2 = \$fzdatnam;
					}
			    	\$conodatnam2 =~ s/(\x5C.PDF)\$/-2\$1/i;
		#my \$fzdatnam = fz_datnam(\$endung,\$zeit,\$zwei);
	    reportmail(innomail('TH'),innomail('TH'),'',"kundenftp--fz_datnam--dateiname2", "conodatnam2[\$conodatnam2]") if (\$query{'user'} =~ m/THOFMANNx/i);
			    	#\$quelle = \$PATH."/".\$dateiname;
			      ## geht nicht, ausREMen, bay hat es rausgenommen
			      #if (-e "\$PATH\x5C/\$dateiname2") {
			    	&ftp(\$server, \$benutzer, \$pass, \$dateiname2, \$verz, \$PATH, \$conodatnam2, \$isscp, \$scpkeyfile, \$scpport);
			      #}
			    }
			    ## wenn Zusatzaktion, dann hier
			    if (\$act) {
			    	## hier noch Variablen in URL austauschen durch evtl. vorhandenes
			    	print "<p>kundenftp: act: [\$act]</p>\x5Cn" if \$query{user} =~ /THOFMANN/i || isinnoip();
			    	\@urlvars = \$act =~ m/\x5C[([^\x5C]]+)\x5C]/ig;
			    	\$kundenftpvars{'DATEINAME'} = \$datnam;
			    	my (\$temp, \$temp2);
			    	foreach \$temp (\@urlvars) {
			    	    if (\$kundenftpvars{\$temp}) {
			    	    	\$temp2 = \$kundenftpvars{\$temp};
			    	    	\$act =~ s/\x5C[\$temp\x5C]/\$temp2/ig;
			    	    }
			    	    if (\$query{\$temp}) {
			    	    	\$temp2 = \$query{\$temp};
			    	    	\$act =~ s/\x5C[\$temp\x5C]/\$temp2/ig;
			    	    }
			    	}
			    	print "<p>kundenftp: act NACH foreach: [\$act]</p>\x5Cn" if \$query{user} =~ /THOFMANN/i || isinnoip();

#    require \$PATH_SSL."cgi-bin/vers2002/rhincs.pl";
    ## action protokoll xml content-type URL method proxy debug
    my (\$cont, \$issuccess, \$status, \$message) = &client('','', '', '', \$act, 'GET', '', '');

			    	print "<p>kundenftp: act NACH client: (cont, issuccess, status, message)--(\$cont, \$issuccess, \$status, \$message)</p>\x5Cn" if \$query{user} =~ /THOFMANN/i || isinnoip();

			    }
			} else { ## if (\$varcont)
				#&reportmail(&innomail('TH'),&innomail('TH'),'',"kundenftp--else-varcont--\$varcont", "k.T.");
				&reportmail(&innomail('TH'),&innomail('TH'),'',"kundenftp--else-varcont-isuser-\$isuser",
				 '\$server, \$benutzer, \$pass, \$verz, \$var, \$act, \$varcont, \$query{info}'.
				 "\x5Cn\$server, \$benutzer, \$pass, \$verz, \$var, \$act, \$varcont, \$query{'info'}");
			}
			last eachuser;
		}
	    }
	    #&reportmail(&innomail('TH'),&innomail('TH'),'',"kundenftp--user-\$remkundftp", 'k.T.');
		## besser hinterher loeschen?
		
	}

## extra Bloecke drunter, die koennen beim Einlesen erfasst und weiterverarbeitet werden, z.B. Ausfuehren
if (0) { # sollte niemals ausgefuehrt werden
## <KUNDENFTP_RUN_ON_READ>
	## fuer Konzept und Marketing, bei deren Tarifen soll die Vermittlerzuweisung (Gesellschaft) die bcm Mail erhalten wegen der Anhaenge
	## 31.03.2010 HOF; Das ist falsch, Vermittlerzuweisung ist gar nicht Untermandant(mail) sondern Gesellschaft(modulmail2)
	## 31.03.2010 HOF; KB: erst mal nur Conopera, also die anderen raus: 5701|5702|5703|
	## 08.04.2010 HOF; DR: auch fuer User SDVA86 (SDV AG), nach Ruecksprache DR wieder auf Vermittlerzuweisung
	## 08.08.2012 HOF; DR: raus fuer SDVA86: || (\$query{'user'} =~ m/(SDVA86)/i)
	if (\$query{'gesnr'} =~ m/^(5811)\$/i) {
		my \$temp = \$query{'modulmail2'};
		if (\$temp !~ m/^[ \x5Ct]*\$/i) {\$to{\$temp} = 'bcm';}
	}
	my (\$var,\$act,\$isscp,\$scpkeyfile,\$scpport);
## </KUNDENFTP_RUN_ON_READ>

## <KUNDENFTP_RUN_ON_READ_TEST>
	&reportmail(&innomail('TH'),&innomail('TH'),'','KUNDENFTP__RUN_ON_READ_TEST','[k.T.]');
## </KUNDENFTP_RUN_ON_READ_TEST>
}

__KUNDENFTP_NEU__
	return ($kundenftp);
}

sub getcsvkunden {
	return (' thofmann dkm AATM86 '); # es ist nur ein match case insensitive
}

sub getanhangkunden {
	# Kunden, die im Untermandant extra XML und GDV bekommen, Mantis 2898
	# Leerzeichen zwischem jedem Kunde und am Anfang und am Ende
	return (' AKSG48 SPSG08 CNPR06 '); # thofmann 
}

sub kundenftpimmer {
# Kunden fuer die immer kundenftp ausgefuehrt wird, also auch bei $FEHLER Webservice.
# 02.02.2012 HOF; alle Conopera, Mantis 3284
return ('ASIW48|CNPR0[1-9]|CNPR[1-9][0-9]|CNPS51');
}

sub mailempf {
	my ($empf,$wohin,$subj,$nosend) = @_;
	my ($key,$text);
	if (!($empf)) {$empf = \%main::to;}
	if (!($wohin)) {$wohin = 'thofmann@innosystems.de';}
	$subj='mailempf: '.$subj;
	#$text = "$subj: $wohin\n";
	foreach $key(keys(%$empf)) {
		$text .= "$key: $$empf{$key}\n";
	}
	if(!$nosend) {reportmail($wohin,$wohin,'',$subj,$text);}
	return($text);
}

sub uebermittelteMailadressen {
	# uebergeben werden sollte der Hash %to aus den vertragsmail
	# als Hash und nicht als HashRef, damit er nicht verändert werden kann
	# diese Adressen raus: kopie@innosystems.net entwicklung)@innosystems.net
	my %to = @_;
		my ($alladdress,$tempadd,$too);
		alladresses:
		foreach $too (keys(%to)) {
			if ($too =~ m/^"[^"]+" +<(([a-z0-9_\.\-]+)\@([a-z0-9_\-]+\.)+[a-z]{2,6})>$/i) {
				$tempadd = $1;
			} elsif ($too =~ m/^([a-z0-9_\.\-]+)\@([a-z0-9_\-]+\.)+[a-z]{2,6}$/i) {
				$tempadd = $&;
			}
			if ($tempadd =~ m/(kopie|entwicklung)\@innosystems\.net/i) {next alladresses;}
			$tempadd = $to{$too} . ",$tempadd";
			if ($alladdress) {$alladdress.='/';}
			$alladdress .= $tempadd;
		}
		return($alladdress);
}

sub kundenMailempfUntermandant {
# Kunden, bei denen beim Untermandant die Liste der Empfänger abgedruckt wird.
# 22.03.2013 HOF, Mantis 4040
return('AKSG48|THOFMANN');
}

sub get_vermittlernr2 {

	my($q,$ges_vermittler,@rest)=@_;
	my %query = %$q;
	my $queryanz = keys(%query);
	#reportmail(innomail('TH'),innomail('TH'),'',"ideal_ws: queryanz","queryanz[$queryanz]");

	my $modul_id             = $main::modul_id;
#	my $dbh                  = $main::dbh;
	my $untermandant_USER_ID = $main::untermandant_USER_ID;
#	my $admin                = $main::admin;
	my $USER_ID              = $main::USER_ID;
	my $vernr_orig           = $query{'Vermittlernummer'};

	if ($query{modul_id} && !$modul_id) { $modul_id = $query{modul_id}; }


	# Die Spalten richtig machen
	my$spalte =""; my$spalte2=""; my($sth);

	if ($modul_id == 12 || $modul_id ==13 || $modul_id ==14 || $modul_id ==15 || $modul_id ==16  || $modul_id ==18 || $modul_id ==25 || $modul_id ==26 || $modul_id ==27 || $modul_id==38 || $modul_id==39 || $modul_id==40 )
        { $spalte ="_kv"; }

	elsif ($modul_id == 9 || $modul_id == 33) { $spalte ="_rs"; }
	elsif ($query{'modul'} =~ m/RES/i) { $spalte ="_rs"; }
    else { $spalte =""; }

	if (!$spalte) { $spalte2="_sach"; } # fuer print_sach, show_sach, submit_sach
	else { $spalte2=$spalte; }



    # Es muss aus der gesellschaftsdatenbank die ID zur Gesellschaft ermittelt werden.
    # Hierzu dienen die letzten drei Ziffern und hierbei diejenige mit der geringsten id.
    # Mit der ermittelten id wird in std_person_gesellschaftmaklerzuordnung die Vermittlernummer zur
    # Gesellschaft ausgelesen.
    $ges_vermittler=substr($ges_vermittler,length($ges_vermittler)-3,3);
	# NOT LIKE '5%'
#	$sth = &sqlexec("select id from gesellschaft where RIGHT(gesellschaft,3)='$ges_vermittler'",$dbh);
#    my($tabges_id) = &sqlfetch($sth);
    my($tabges_id) = do_sql("select id as tabges_id from gesellschaft where RIGHT(gesellschaft,3)='$ges_vermittler'","tabges_id");


	my $db = open_db( '', 'pkshop' );

	# Untermandanten
	my($vermittlernummer_unterm);
	if ( ($query{programm} eq "untermandanten" || $query{programm} eq "hpr") ) {

#		$sth = &sqlexec("SELECT vermittlernummer$spalte FROM std_person_gesellschaftmaklerzuordnung WHERE gesellschaft_id='$tabges_id' AND person_id='$untermandant_USER_ID'",$admin);
#		($vermittlernummer_unterm) = &sqlfetch($sth);
		($vermittlernummer_unterm) = do_sql("SELECT vermittlernummer$spalte FROM std_person_gesellschaftmaklerzuordnung WHERE gesellschaft_id='$tabges_id' AND person_id='$untermandant_USER_ID'","vermittlernummer$spalte", "", "", "", "", $db, 1 );

	} 

	# Jetzt fuer alle
#	$sth = &sqlexec("SELECT vermittlernummer$spalte,submit$spalte2,print$spalte2,show$spalte2 FROM std_person_gesellschaftmaklerzuordnung WHERE gesellschaft_id='$tabges_id' AND person_id='$USER_ID'",$admin);
#    my($vermittlernummer,$submit,$print,$show) = &sqlfetch($sth);
    my($vermittlernummer,$submit,$print,$show) = do_sql("SELECT vermittlernummer$spalte,submit$spalte2,print$spalte2,show$spalte2 FROM std_person_gesellschaftmaklerzuordnung WHERE gesellschaft_id='$tabges_id' AND person_id='$USER_ID'","vermittlernummer$spalte&submit$spalte2&print$spalte2&show$spalte2","","","","", $db, 1);
    my $vernr_sic = $vermittlernummer;

	$db->disconnect;

	# War vbeim Untermandanten nichts zu holen an Vermittlernummern? Dann muessen wir die vom verskunden nehmenb!
	if ( ($query{programm} eq "untermandanten" || $query{programm} eq "hpr") && $vermittlernummer_unterm) { 
		$vermittlernummer=$vermittlernummer_unterm;
	}

#	reportmail(innomail('TH'),innomail('TH'),'',"ideal_ws: Vermittlernummer",
#	  '$vernr_sic,$vermittlernummer_unterm,$submit,$print,$show,$vernr_orig'."--".
#	"\n$vernr_sic,$vermittlernummer_unterm,$submit,$print,$show,$vernr_orig"
#	);

	return ($vernr_sic,$vermittlernummer_unterm,$submit,$print,$show);



}

sub vermittlersplit {

	my ($vermganz,$q,@rest) = @_; #$$query{'name'};
	$vermganz =~ s/^ +//i;
	$vermganz =~ s/ +$//i;
	$vermganz = &sonder2ent($vermganz);
	my ($nname, $vname, $firma, $xx) = ($vermganz, '', '', '');
	my $query;
	if (!$q) {
		$query = \%main::query;
	} else {
		$query = $q;
	}

	my %xx = (
		6, "(firma) KG Vorname Nachname",
		7, "(firma) GmbH Vorname Nachname",
		8, "(firma) (AG|GbR) Vorname Nachname",
		1, "Vorname Nachname - (firma)",
		2, "(firma) - Vorname Nachname",
		3, "(firma) Vorname Nachname [raus weil nicht pruefbar]",
		13, "- Nachname, Vorname [Vorname2]",
		12, "- Vorname [Vorname2] Nachname",
		9, "(firma) KG",
		10, "(firma) GmbH",
		11, "(firma) (AG|GbR)",
		5, "Nachname, Vorname",
		4, "Vorname Nachname",
	);

	## was ist mit "- Thomas K. Hofmann"
	## was ist mit "(firma) (GmbH|KG|AG|GbR) .."? Achtung! es gibt auch "GmbH &amp; Co. KG", also die zuerst
	## was ist mit "Vorname Mittelname Nachname"?
	## was ist mit "Nachname, Vorname Mittelname"?
	## was ist mit "Vorname1-Vorname2 Nachname"?
	## was ist mit "Nachname, Vorname1-Vorname2"?

	## Firma mit Name ------------------------------------------------------------
	## HOF 14.09.2009, ACHTUNG! Semikolon ist gefählich, weil wir jetzt auch Entities drin haben koennen z.B. wegen '&'=='&amp;'
	## 	15.09.2009 Punkt auch gefährlich
	## entweder "(firma) KG Vorname Nachname" oder ...
	## -6-
	if ($vermganz =~ m/^(.*? KG) ([^ ]+( +[^ ]+)?) +(.*?)$/i) {
		($firma, $vname, $nname, $xx) = ($1, $2, $4, 6);
	}
	## ... oder "(firma) GmbH Vorname Nachname"? 
	## Achtung! "Assekuranzservice AG Rendite 3000 GmbH", also GmbH vorher, und 5+6 auch ohne Name
	## -7-
	elsif ($vermganz =~ m/^(.*? GmbH) ([^ ]+( +[^ ]+)?) +(.*?)$/i) {
		($firma, $vname, $nname, $xx) = ($1, $2, $4, 7);
		## schlimmer als ich dachte ... Valentinstag 2014
		$vname =~ s/^- +//;
	}
	## ... oder "(firma) (AG|GbR) Vorname Nachname"? Achtung! es gibt auch "GmbH &amp; Co. KG", also die zuerst
	## Achtung! "Assekuranzservice AG Rendite 3000 GmbH", also GmbH vorher, und 5+6 auch ohne Name
	## -8-
	elsif ($vermganz =~ m/^(.*?[ \.]+(AG|GbR)) ([^ ]+(( u\.| und)? +[^ ]+)?) +(.*?)$/i) {
		($firma, $vname, $nname, $xx) = ($1, $3, $6, 8);
	}

	## Firma - Name -------------------------------------------------------------------
	## ... oder "Vorname Nachname - (firma)" oder ...
	#elsif ($vermganz =~ m/^([^\-]+) +([^ \-]+) +(-|[,;\.]) (.*?)$/i) {
	## -1-
	elsif ($vermganz =~ m/^ *([^ ]+) +([^ ]+)( +-| ?[,]) (.*?)$/i) {
		($vname, $nname, $firma, $xx) = ($1, $2, $4, 1);
	}
	## ... oder "(firma) - Vorname Nachname" oder ...
	#elsif ($vermganz =~ m/^(.*?)(- +|[,;\.] )([^\-]+) +([^ \-]+)$/i) {
	## -2-
	elsif ($vermganz =~ m/^(.*?)( +-| ?[,]) +([^ ]+) +([^ ]+)$/i) {
		($firma, $vname, $nname, $xx) = ($1, $3, $4, 2);
	}
	## das raus, weil oben schon abgefangen sein sollte
	## ... oder "(firma) Vorname Nachname" oder ...
#	elsif ($vermganz =~ m/^(.*?) +([^ ]+) +([^ ]+)$/i) {
#		($firma, $vname, $nname, $xx) = ($1, $2, $3, 3);
#	}

	## Firma leer - Name -------------------------------------------------------------------
	## ... oder "(firma leer) - Nachname, Vorname [Vorname2]" oder ...
	## -13-
	elsif ($vermganz =~ m/^( *-| ?[,]) +([^ ]+), +([^ ]+)( +[^ ]+)?$/i) {
		($firma, $nname, $vname, $xx) = ('', $2, "$3$4", 13);
	}
	## ... oder "(firma leer) - Vorname [Vorname2] Nachname" oder ...
	## -12-
	elsif ($vermganz =~ m/^( *-| ?[,]) +([^ ]+)( +[^ ]+)? +([^ ]+)$/i) {
		($firma, $vname, $nname, $xx) = ('', "$2$3", $4, 12);
	}

	## Firma ohne Name ------------------------------------------------------------
	## Achtung! gefählich, weil das Name vorher ausblendet, besser hinten
	## ... oder "(firma) KG" oder ...
	## -9-
	elsif ($vermganz =~ m/^(.*? KG)$/i) {
		($firma, $vname, $nname, $xx) = ($1, '', '', 9);
	}
	## ... oder "(firma) GmbH" oder ...
	## -10-
	elsif ($vermganz =~ m/^(.*? GmbH)$/i) {
		($firma, $vname, $nname, $xx) = ($1, '', '', 10);
	}
	## ... oder "(firma) (AG|GbR)" Achtung! es gibt auch "GmbH &amp; Co. KG", also die zuerst
	## Achtung! "Assekuranzservice AG Rendite 3000 GmbH", also GmbH vorher, und 5+6 auch ohne Name
	## -11-
	elsif ($vermganz =~ m/^(.*? (AG|GbR))$/i) {
		($firma, $vname, $nname, $xx) = ($1, '', '', 11);
	}

	## nur Name ------------------------------------------------------
	## ... oder "Nachname, Vorname" oder ...
	## -5-
	elsif ($vermganz =~ m/^ *([^, ]+), +([^ ]+( +[^ ]+)?)$/i) {
		($firma, $vname, $nname, $xx) = ('', $2, $1, 5);
	}
	## ... oder "Vorname Nachname" oder ...
	## HOF 17.09.2009, max. zwei Vornamen mit Leerz.
	## -4-
	elsif ($vermganz =~ m/^ *([^ ]+( +[^ ]+)?) +([^ ]+)$/i) {
		($firma, $vname, $nname, $xx) = ('', $1, $3, 4);
	}
	## auf 30 abschneiden, sonst meckert deren WS
#	&reportmail(&errmailth(),&errmailth(),'',
#		"rhion-inc: Typ Vermittler $xx", 
#		"vermganz[$vermganz]\n vname[$vname]\n nname[$nname]\n firma[$firma]\n$xx{$xx}");
	scalar2queryx('vermittlersplit-typ',"Typ: $xx: $xx{$xx}",$query);
	scalar2queryx('vermittlersplit',"firma($firma), vname($vname), nname($nname), xx($xx)",$query);
	return ($firma, $vname, $nname, $xx);
}

sub filenameclear {
	my ($fn,@rest) = @_;
	$fn = utf82ascii( $fn );
	$fn = ascii2uml( $fn );
	$fn =~ s/ +/_/g;
	$fn =~ s/[^a-z0-9\.\-_~]/_/ig;
	return($fn);
}

sub runde2stufen {

	my ( $wert, $stufe, @rest ) = @_;
	my $wertneu = $wert;

	$wertneu =  int( ($wert + ($stufe - 0.01)) / $stufe ) * $stufe;	
	#print "wert[$wert] stufe[$stufe] wertneu[$wertneu]\n";
	
	return( $wertneu );
}

sub fz_datnam {
	# extra Dateinamen fuer Finanzzirkel user FZGC31
	my $endung = shift;
	my $zeit   = shift;
	my $zwei   = shift; # fuer $dateiname2 == zweites PDF mit Beratungsdokumentation
	if ( $zwei ) { $zwei = '-2'; }
	my %query		= %main::query;
	my $dateiname	= $main::dateiname;
	my $dateiname2	= $main::dateiname2;
	#my $zeit 		= $main::zeit;
	if ( !$endung ) { $endung = 'pdf'; }
	# bisher:
	# FZGC31-20140210173205_464474210173036_1562086-antrag.pdf
	# Lizenzschlüssel-Timestamp-Session-Vorgangsnummer-antrag.pdf
	# neu:
	# Lizenzschlüssel-InternNr-VertragsID-Timestamp-Session-Vorgangsnummer-antrag.pdf
	# $zeit wird in den vertragsmails belegt, Striche entfernen
	my $zeitbereinigt = $zeit;
	$zeitbereinigt =~ s/[^0-9]//ig;
	my $vertragid = $query{'VERTRAG_ID'}; 
	   $vertragid = '0' if ($vertragid eq '');
	my $internnr  = $query{'internnr'}; 
	   $internnr  = '0' if ($internnr eq '');
	my $datnam  = "$query{'user'}-$internnr-$vertragid-$zeitbereinigt-$query{'session'}-$query{'vorgangsnummer'}-antrag$zwei.$endung"; 
	return ($datnam);
}

sub get_STS_manager {
	my ( $ges, $test, @rest ) = @_;
	my $query = \%main::query;
	$$query{'get_STS_START'} = 'gestartet';
	my $stsrequest = <<__STS_MANAGER_REQUEST__;
<request>
    <client>
        <user>sniver</user>
        <pass>gka8t4lp6d5c</pass>
    </client>
    <getToken>
        <!-- you can require one or multiple companys -->
        <company>
            <!-- define a company with name, gesnr or pid -->
            <!-- optional  min. one element must occour -->
            <name>$ges</name>
            <!-- optional -->
            <pid></pid>
            <!-- optional -->
            <gesnr></gesnr>
            <!-- when you want a token from the testsystem set 1 at debug -->
            <debug>$test</debug>
        </company>
    </getToken>
</request>
__STS_MANAGER_REQUEST__

	my $url = 'https://sts.innosystems.biz/getToken';
#	my ( $stsresponse, $success, $code, $message, $error ) = interface("", $url, "", $stsrequest, "utf8", '', 'text/xml; charset="UTF-8"'); # 'debug' hinter utf8 und vor text/xml
#	                                                                  ( $action, $url, $proxy, $xml , $encoding, $debug, $charset , $cl_set, $credential, $authorization, $timeout, $ssl_opts, $digest )
#	                                                            client('setOrder', '', $xml, 'text/xml; charset="UTF-8"', $url, "POST", 0, 0, 1)
	my ( $stsresponse, $success, $code, $message, $error ) = client   ('', '', $stsrequest, 'text/xml; charset="UTF-8"', $url, 'POST', 0, 0, 1 ); # $error wird nicht belegt
#	                                                                  ($action,$protokoll,$soap_str,$ctype,$url,$methode,$set_proxy,$debug,$supress_xml,$umlaute,$tcode)
	my @stskeys = ( 'token', 'status', 'name', 'pid', 'gesnr' );
	my %stsresponse;
	my @stswerte = map {
		if ($stsresponse =~ m/<$_>(.*?)<\/$_>/s) {
			$stsresponse{$_} = $1;
			$$query{'get_STS_'.$_} = $1 if ($1);
			$1;
		} else {
			'';
		}
	} ( @stskeys );
	if ( $$query{'get_STS_status'} =~ m/error/s ) {
		$$query{'get_STS_response'} = $stsresponse;
	}
	if ( $error || $stsresponse =~ m/error/s || $code != 200 ) {
		return undef;
	}
	#$$query{'get_STS_response'} = $stsresponse if ($$query{'user'} =~ m/THOFMANN/i);
	return ( $stswerte[0] );
}

sub berufeGothaerDat {
	return 'berufe-gothaer.dat';
}

sub getBerufeGothaer {
	# extra Berufeliste aus Doku (Word) von Gothaer heraus kopiert und als CSV gespeichert
	# Format: Berufsschluessel;laufende Nr.;Berufsbezeichnung
	my ($datnam, $berufnam, $berufid, @rest) = @_;
	my $sicdatnam = $datnam;
	# Vars: $berufnam, $berufid sind uebergebene hashref, return faellt weg, nur undef/1
	if (!$datnam) { return(undef); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	if ($datnam =~ m|\/|) {
		($aktdir, $datnam) = pfadunddat($datnam);
		if ($aktdir !~ m|\/$|) { $aktdir .= '/'; }
	}
	my $berufedat = "$aktdir$datnam";
	my $line;
	my $errmail = innomail('TH');
	
	if ( !(open(BERUFGOTHAER, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getBerufeGothaer: $mess";
		my $mailtext = "$subj [$berufedat].";
		fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (undef); # 
	} else {
		my @lines = <BERUFGOTHAER>;
		close(BERUFGOTHAER);
		my ($key,$nr,$nam);
		berufgothaerzeile:
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/gefahr(en)?gruppe|bezeichnung/i) { next berufgothaerzeile; }
			#				Berufsschluessel;laufende Nr.;Berufsbezeichnung
			($key,$nr,$nam) = split( /;/, $line, 3 );
			if ( $key ne '' and $nr and $nam ) {
				$$berufid{$nam} = "$key:$nr";
				$$berufnam{"$key:$nr"} = $nam;
			}
		}
	}
	
	return(1);
}

sub berufeGothaerDat3 {
	return 'berufe-gothaer3.dat';
}

sub getBerufeGothaer3 {
	# extra Berufeliste aus Doku (Word) von Gothaer heraus kopiert und als CSV gespeichert
	# Format: Berufsschluessel;laufende Nr.;Berufsbezeichnung;Gefahrgruppe(5/6/7 == A/B/C)
	my ($datnam, $berufnam, $berufid, $berufgef, @rest) = @_;
	my $sicdatnam = $datnam;
	# Vars: $berufnam, $berufid, $berufgef sind uebergebene hashref, return faellt weg, nur undef/1
	if (!$datnam) { return(undef); }
	my $PATH_SSL = $main::PATH_SSL;
	if (!$PATH_SSL) { $PATH_SSL = &PATH_SSL(); }
	my $aktdir = $PATH_SSL . "cgi-bin/out/";
	if ($datnam =~ m|\/|) {
		($aktdir, $datnam) = pfadunddat($datnam);
		if ($aktdir !~ m|\/$|) { $aktdir .= '/'; }
	}
	my $berufedat = "$aktdir$datnam";
	my $line;
	my $errmail = innomail('TH');
	
	if ( !(open(BERUFGOTHAER, $berufedat)) ) { 
		my $mess = "Kann die Berufe nicht einlesen";
		my $subj = "getBerufeGothaer: $mess";
		my $mailtext = "$subj [$berufedat].";
		fehlermail($errmail, $errmail, '', $subj, $mailtext);
		return (undef); # 
	} else {
		my @lines = <BERUFGOTHAER>;
		close(BERUFGOTHAER);
		my ($key,$nr,$nam,$gef);
		berufgothaerzeile3:
		foreach $line (@lines) {
			$line =~ s/[\r\n]+$//g;
			if ($line =~ m/gefahr(en)?gruppe|bezeichnung/i) { next berufgothaerzeile3; }
			#				Berufsschluessel;laufende Nr.;Berufsbezeichnung;GefG
			($key,$nr,$nam,$gef) = split( /;/, $line, 4 );
			if ( $key ne '' and $nr and $nam ) {
				$$berufid{$nam} = "$key:$nr";
				$$berufnam{"$key:$nr"} = $nam;
				$gef =~ tr/567/ABC/;
				$$berufgef{"$key:$nr"} = $gef;
			}
		}
	}
	
	return(1);
}


sub BAKfromQuery {
	my ($query,@rest) = @_;

	my $BAK = 1; # noch eintragen aus Berechnung, ist so im query nicht vorhanden
	# KB: es wird bei uns mit BAK 1 berechnet.
	# HOF 11.04.2012; Frau Rasten ueber die Berechnung Bauartklasse BAK
	# R1) wenn AussenwaendeBeton=ja,	HarteBedachung=ja, 	Fertighaus=nein	                                  = BAK I   1 
	# R2) wenn AussenwaendeBeton=ja,	HarteBedachung=nein,	Fertighaus=nein	                                  = BAK IV  4 
	# R3) wenn AussenwaendeBeton=nein,	HarteBedachung=ja, 	Fertighaus=nein,	AussenwaendeFachwerk=ja   = BAK II  2 
	# R4) wenn AussenwaendeBeton=nein,	HarteBedachung=ja, 	Fertighaus=nein,	AussenwaendeFachwerk=nein = BAK III 3 
	# R5) wenn AussenwaendeBeton=nein,	HarteBedachung=nein,	Fertighaus=nein,	AussenwaendeFachwerk=ja   = BAK IV  4 
	# R6) wenn AussenwaendeBeton=nein,	HarteBedachung=nein,	Fertighaus=nein,	AussenwaendeFachwerk=nein = BAK V   5 
	# R7) wenn Fertighaus=ja,       	FertighausFHG1=ja  	                     	                          = FHG I   6 
	# R8) wenn Fertighaus=ja,       	FertighausFHG1=nein,	FertighausFHG2=ja	                          = FHG II  7 
	# R9) wenn Fertighaus=ja,       	FertighausFHG1=nein,	FertighausFHG2=nein 	                          = FHG III 8 
	# BAK aendern wenn nicht alle 3 mit Ja beantwortet sind (R1)
	if ($$query{'Gebaeudeart'} !~ m/^ja$/i) {
		# geringste moegliche BAK==2 bei NEIN(masive Aussenwaende/harte Bedachung), die anderen Fragen haben wir nicht
		# geht auch nicht, er will 4, weil hier beide Fragen als nein gewertet werden
		$BAK = 4; 
	}
	if ($$query{'Fertighaus'} !~ m/^nein$/i) {
		# geringste moegliche BAK==6 bei Fertighaus, die anderen Fragen haben wir nicht
		# geht nicht, da meckert er, er will FHG III = 8
		# 24.09.2012; lt. Frau Sprycha ist:  
		#   Ein Gebäude mit massiven Außenwänden und harter Dachung: ja; Ein Fertighaus: ja = FHG I - versicherbar = BAK 6
		if ($$query{'Gebaeudeart'} =~ m/^ja$/i) {
			$BAK = 6; 
		} else {
			$BAK = 8; 
		}
	}
#	reportmail(innomail('th'), innomail('th3'),'',"ideal_ws: id_BAK: $BAK [28]",
#	  "BAK[$BAK] Fertighaus[$$query{'Fertighaus'}] Gebaeudeart[$$query{'Gebaeudeart'}]");

	return ($BAK);
}

sub innoip {
	my $self = shift;
	return '80.147.12.42';  ## von PC TH heute am 09.04.2015
}

sub isinnoip {
	my $self = shift;
	return $ENV{REMOTE_ADDR} eq innoip() ? 1 : '';
}

#-- dummy Rueckgabe
1;

#!D:/xampp/perl/bin/perl -w
#!/usr/bin/perl
#######################################################
## takefile.pl
## uebernommen von faq.pl
## Startseite von takefile ausgeben.
##
## Was muss die Startseite enthalten?
## - Titel
## - evtl. Daten zur Übergabe wie
##   * aufrufende URL
##   * übergebenen Inhalt
##   * wurde ein Dateiname übergeben?
## - file speichern
##
## Parameter: evtl. übergebenen Inhalt
##
#######################################################
    
##-- Einleitung ---------------------------------------
#$scriptname = $ENV{ 'PATH_TRANSLATED' };
## geht nicht, daher diese Variable
$scriptname = $ENV{ 'SCRIPT_FILENAME' };
$slash = "\\";
$aktdir = holpfad0($scriptname);

#print "Content-type: text/html\n\n";
#print "<html>\n<head>\n<title>Test</title>\n</head>\n<body>\n";
#print "<p>scriptname=[$scriptname]</p>\n";
#print "<p>PATH_TRANSLATED=[$ENV{ 'PATH_TRANSLATED' }]</p>\n";

push (@INC, $aktdir);
require "thpl.pl";
require "cgi-lib.pl";
chdir ($aktdir);

require "webtools.pl";

## packe ich bei webtools mit rein
#require "globals.pl";
%globals = getglobals();

## nur global festlegen
#%opt = ();

print PrintHeader();
$head = UbmCgiHead("takefile - uebergebenes File annehmen");  ##  - Thomas Hofmann; Jun 2016
print $head;

$aktkat = 1;
$input="";
@input=();
%input=();
my $hashtags = 'off';  ## or simply '' but NOT 'on'
my $hashcloud = 'off';  ## or simply '' but NOT 'on'
## wurde was uebergeben?
if (ReadParse(*input)) {
	if ($input{'kat'}) {
		$aktkat = $input{'kat'};
	}
}


#print "<hr><pre>\n";
&printHash(%globals);
#print "</pre><hr>\n";

print "</html>\n";
exit(0);

##-- ENDE Hauptprogramm -------------------------------


##-- SUBs ---------------------------------------------
sub holpfad0 {
## Uebergabe: vollstaendiges Verzeichnis/Dateiname
## Rueckgabe: Verzeichnis ohne Dateiname bzw. letztes Unterverzeichnis
## globale Variablen: nurpfad, nurdat, slash

        local (@par)=@_;
        local ($vpfad);

        $vpfad=$par[0];
        #print ">$vpfad<\n";
        $vpfad =~ m/^(.+)([\\\/])(.*)$/;
        if (defined($1)) {
                $nurpfad = $1;
                $slash   = $2;
                $nurdat  = $3;
        } else {
                $nurpfad = '';
                $nurdat = $vpfad;
        }
        #print "LEER\n" if ($nurpfad eq '') || print ">$nurpfad<\n";
        #print ">$nurdat<\n";
        return ($nurpfad);
}


##-- ENDE Alles ---------------------------------------

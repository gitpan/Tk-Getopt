# -*- perl -*-
print "1..10\n";

use Tk::Getopt;

@ARGV = qw(--arr 1 --arr 2 --arr 3
	   --hsh foo=bar --hsh bla=blubber
	   --help --file foo --foo --nobar --num=5 -- file);

%getopt = 
  (
   'help'   => \$HELP,
   'file:s' => \$FILE,
   'foo!'   => \$FOO,
   'bar!'   => \$BAR,
   'num:i'  => \$NO,
   'arr=s@' => \@ARR,
   'hsh=s%' => \%HSH,
);

%getopt2 = 
  (
   'help'   => \$HELP2,
   'file:s' => \$FILE2,
   'foo!'   => \$FOO2,
   'bar!'   => \$BAR2,
   'num:i'  => \$NO2,
   'arr=s@' => \@ARR2,
   'hsh=s%' => \%HSH2,
);

$opt = new Tk::Getopt(-getopt => \%getopt);

if (!$opt->get_options) {
    print "not ";
}
print "ok 1\n";

print "not " unless $HELP && $FOO && !$BAR && $FILE eq 'foo' && $NO == 5;
print "ok 2\n";

print "not " unless $ARR[0] == 1 && $ARR[1] == 2 && $ARR[2] == 3;
print "ok 3\n";

print "not " unless $HSH{"foo"} eq "bar" && $HSH{"bla"} eq "blubber";
print "ok 4\n";

print "not " unless "@ARGV" eq "file";
print "ok 5\n";

my $tstfile = "getopt.tst";
unlink $tstfile;
$opt->save_options($tstfile);
print "not " if !-f $tstfile;
print "ok 6\n";

@ARGV = ();
$opt2 = new Tk::Getopt(-getopt => \%getopt2);
$r = $opt2->load_options($tstfile);
print "not " if !$r;
print "ok 7\n";

print "not " unless ($HELP2 && $FOO2 && !$BAR2 &&
		     $FILE eq $FILE2 && $NO == $NO2);
print "ok 8\n";

print "not " unless ($ARR[0] == $ARR2[0] && $ARR[1] == $ARR2[1] &&
		     $ARR[2] == $ARR2[2]);
print "ok 9\n";

print "not " unless ($HSH{"foo"} eq $HSH2{"foo"} &&
		     $HSH{"bla"} eq $HSH2{"bla"});
print "ok 10\n";


unlink $tstfile;

#!/usr/bin/perl -w
# -*- perl -*-

#
# $Id: modern.t,v 1.1 2005/04/04 11:46:55 eserte Exp $
# Author: Slaven Rezic
#

use strict;

BEGIN {
    if (!eval q{
	use Test::More;
	use File::Temp qw(tempfile);
	1;
    }) {
	print "1..0 # skip: no Test::More module\n";
	exit;
    }
}

plan tests => 1;

use Tk;
use Tk::Getopt;

if (!defined $ENV{BATCH}) { $ENV{BATCH} = 1 }

my $batch_mode = !!$ENV{BATCH};

my $mw = tkinit;
my $l1 = $mw->Label->pack;
my $l2 = $mw->Label->pack;

my @opttable =
  ("Section1",
   ['opt1', '=s', undef],
   "Section2",
   ['opt2', '=s', undef],
  );

my(undef, $optfilename) = tempfile(UNLINK => 1);
my $options = {};
my $opt = Tk::Getopt->new(-opttable => \@opttable,
			  -options => $options,
			  -filename => $optfilename,
			 );

if ($batch_mode) {
    $mw->after(1000, sub {
		   $mw->destroy;
	       });
}

my $w = $opt->option_editor($mw,
			    -statusbar => 1,
			    -popover => 'cursor',
			    -buttons => ['oksave','cancel'],
			    '-wait' => 1,
			   );

if (Tk::Exists($mw)) {
    $l1->configure(-text => $options->{"opt1"});
    $l2->configure(-text => $options->{"opt2"});

    MainLoop;
}

pass("Ok");

__END__

#!/usr/bin/env perl
use warnings;
use strict;
use utf8::all;
use IO::File;
use XML::Twig;

my $twig = XML::Twig->new(
  use_tidy => 0,
  pretty_print => 'indented',
  twig_handlers => {

    body => sub {
      $_->subs_text(
	qr/([\x{2800}-\x{28FF}]+)/,
	'&elt( span => { class => "brl6dotsb" }, $1)'
       );

      return 1
    }, # sub
  }, # twig_handlers
    
 );
if( "$ARGV[0]" ){
  $twig->parsefile( "$ARGV[0]" );
} else {
  print "Error: Please give a file name for input.\n";
  exit 1;
} # if
$twig->print;

__DATA__

=encoding utf8

=head1 NAME

html_set_class4unicodebrl.pl

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

This script finds text in Unicode braille and puts it in span elements with class set to unicodebrl.

Give the HTML file as input parameter and redirect the output to another file.

=head1 AUTHOR

Lars Bjørndal

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2023 by Lars Bjørndal.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

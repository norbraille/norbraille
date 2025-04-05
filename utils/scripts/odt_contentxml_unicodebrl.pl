#!/bin/perl
use warnings;
use strict;
use utf8;
use open qw( :std :utf8 );

use List::Util qw(first);
use XML::Twig;
use App::Brl2Brl qw(parse_dis Conv);

my %style_map = ();
my @block_font_stack = ();
my $twig = XML::Twig->new (
  use_tidy => 0,
  twig_handlers => {
    "style:style" => sub {
      my @ch = $_->children( "style:text-properties" );
      for my $prop ( @ch ){
	if( defined( my $font = $prop->{'att'}{'style:font-name'} )) {
	  $style_map{$_->{'att'}->{'style:name'}} = $font =~ /\b block \b/x;
	} # if
      } # for
      return 1;
    }, # sub
    "text:tab" => sub {
      $_->replace_with( XML::Twig::Elt->new( '#PCDATA' => " " ));
    }, # sub

    "text:s" => sub {
      my $spcs = $_->att( 'text:c' ) // 1;
      my $space_text = unicodify_block_font(" "x$spcs, \@block_font_stack);
      $_->replace_with( XML::Twig::Elt->new( '#PCDATA' => $space_text ));
    }, # sub

    "_all_" => sub {
      pop @block_font_stack;

      return 1
    }, # sub

  }, # twig_handlers

  start_tag_handlers => {
    "_all_" => sub {
      push @block_font_stack, $style_map{$_->att( "text:style-name" )//''};
      return 1;
    }, # sub
  }, # start_tag_handlers

  char_handler => sub {
    my( $text ) = @_;
    return unicodify_block_font($text, \@block_font_stack);
  }, # sub
 );
if( $ARGV[0] ){
  $twig->parsefile( "$ARGV[0]" );
} else {
  print "Error: Please give an input file as parameter.\n";
  exit 1;
} # if
$twig->print;

sub unicodify_block_font {
  my( $text, $block_font_stack ) = @_;
  my $is_block = first { defined } reverse @$block_font_stack;
  if( $is_block ){
    my $table_path = '/usr/share/liblouis/tables';
    my $from_table = "$table_path/wordcx.dis";
    my $to_table = "$table_path/unicode\.dis";
    my %from_str = parse_dis( $from_table );
    my %to_str = parse_dis( $to_table );
    $text = lc( $text ); # Convert to lowercase if uppercase has been used.
    $text = Conv( \%from_str, \%to_str, $text );
    $text =~ s/ /\x{2800}\x{200B}/g;
  } # if
  return $text
} # sub unicodify_block_font

__DATA__

=encoding utf8

=head1 NAME

odt_contentxml_unicodebrl.pl

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

This script reads a content.xml file from within an ODT file It converts text set to BLOCK font into Unicode braille.

Use the file name as parameter for the input and redirect output to another file.

=head1 AUTHOR

Lars Bjørndal


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2023-2024 by Lars Bjørndal.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut

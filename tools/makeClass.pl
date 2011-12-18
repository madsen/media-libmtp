#! /usr/bin/perl
#---------------------------------------------------------------------
# $Id$
# Copyright 2011 Christopher J. Madsen
#
#
#---------------------------------------------------------------------

use strict;
use warnings;
use 5.010;

use autodie ':io';
use Text::Wrap qw(wrap);

open(my $in, '<', '../../Media-LibMTP-API/lib/Media/LibMTP/API.xs');

my %typemap = (
  Utf8String => 'Str',
  'AV *'     => 'ArrayRef',
  'SV *'     => 'Str',
);

my @attrs;
my %types;
my $type;
my $class;
my $code;

while (<$in>) {
  if (/^MODULE/) {
    if (@attrs) {
      say "Writing $class.pm";
      open(my $out, '>', "$class.pm");
      print $out <<"END PROLOGUE";
#---------------------------------------------------------------------
package Media::LibMTP::$class;
#
# Copyright 2011 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl\@cjmweb.net>
# Created: 17 Dec 2011
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Wrap $class object from libmtp
#---------------------------------------------------------------------

use Moose;

our \$VERSION = '0.01';
# This file is part of {{\$dist}} {{\$dist_version}} ({{\$date}})

with 'Media::LibMTP::Role::APIObject';

use namespace::autoclean;
use MooseX::Types::Moose qw(ArrayRef Str);
use Media::LibMTP::Types ':all';

#=====================================================================
sub _API_class { 'Media::LibMTP::API::$class' }

END PROLOGUE

      @attrs = sort @attrs;
      print $out ("sub _API_attributes\n{\n", wrap('  qw(', '     ', "@attrs);"),
                  "\n}\n" . <<"END EPILOGUE");

#---------------------------------------------------------------------
has _device => (
  is       => 'rw',
  isa      => LibMTP,
  weak_ref => 1,
);

$code#=====================================================================
1;

__END__
END EPILOGUE
      @attrs = ();
      $code = '';
    }

    if (/PREFIX/) {
      undef $class;
    } elsif (/PACKAGE = Media::LibMTP::API::(?!AllowedValues|Error|MTPDevice|\w+List$)(\w+)/) {
      $class = $1;
      #say "\n\n# $class";
    } else {
      undef $class;
    }
  } elsif (not $class) {
  } elsif ($type and /^(?!(?:child|next|new|prev|sibling|DESTROY)\()(\w+)\(self/) {
    my $attr = $1;
    push @attrs, $attr;
    if ($typemap{$type}) {$type = $typemap{$type} }
    else                 { ++$types{$type} }

    $code .= <<"";
has $attr => (
  is   => 'rw',
  isa  => $type,
);\n

  } elsif (/^\w/) {
    chomp($type = $_);
  }
}

say "\n\n# Types used:";

say for sort keys %types;

# Local Variables:
# compile-command: "perl makeClass.pl"
# End:

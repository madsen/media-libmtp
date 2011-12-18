#---------------------------------------------------------------------
package Media::LibMTP::Role::APIObject;
#
# Copyright 2011 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 16 Dec 2011
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: A Moose copy of a libmtp data structure
#---------------------------------------------------------------------

use Moose::Role;

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

use namespace::autoclean;

use Scalar::Util 'blessed';

#=====================================================================

requires qw(_API_class _API_attributes);

# Construct this object from an _API_class object:
around BUILDARGS => sub {
  my $orig  = shift;
  my $class = shift;

  no warnings 'uninitialized';

  if (@_ == 1 and ref $_[0] eq 'HASH') {
    my $param = shift;

    if (my $o = delete $param->{_api}) {
      confess "_api is not a " . $class->_API_class
          unless  $o->isa($class->_API_class);

      $param->{$_} = $o->$_ for @{ $class->_API_attributes };
    } # end if _api

    return $param;
  } # end if single hashref

  $class->$orig(@_);
}; # end around BUILDARGS

#---------------------------------------------------------------------
sub _api
{
  my $self = shift;

  my $o = $self->_API_class->new;

  for my $attr (@{ $self->_API_attributes }) {
    my $value = $self->attr;
    $o->$attr( $value ) if defined $value;
  } # end for each $attr in _API_attributes

  $o;
} # end _api

#=====================================================================
# Package Return Value:

1;

__END__

#---------------------------------------------------------------------
package Media::LibMTP::Error;
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
# ABSTRACT: Error class for Media::LibMTP
#---------------------------------------------------------------------

use 5.010001;                   # revised smart matching
use Moose;
extends 'Throwable::Error';

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

use namespace::autoclean;
use MooseX::Types::Moose qw(ArrayRef);

has error_stack => (
  is       => 'ro',
  isa      => ArrayRef,
  required => 1,
);

has '+message' => (
  lazy    => 1,
  default => sub { join("\n", map { $_->[1] } @{ shift->error_stack })},
);

#=====================================================================
# Package Return Value:

__PACKAGE__->meta->make_immutable;
1;

__END__

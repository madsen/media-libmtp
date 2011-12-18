#---------------------------------------------------------------------
package Media::LibMTP::Album;
#
# Copyright 2011 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
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
# ABSTRACT: Wrap Album object from libmtp
#---------------------------------------------------------------------

use Moose;

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

with 'Media::LibMTP::Role::APIObject';

use namespace::autoclean;
use MooseX::Types::Moose qw(ArrayRef Str);
use Media::LibMTP::Types ':all';

#=====================================================================
sub _API_class { 'Media::LibMTP::API::Album' }

sub _API_attributes
{
  qw(album_id artist composer genre name no_tracks parent_id storage_id
     tracks);
}

#---------------------------------------------------------------------
has _device => (
  is       => 'rw',
  isa      => LibMTP,
  weak_ref => 1,
);

has album_id => (
  is   => 'rw',
  isa  => uint32_t,
);

has parent_id => (
  is   => 'rw',
  isa  => uint32_t,
);

has storage_id => (
  is   => 'rw',
  isa  => uint32_t,
);

has name => (
  is   => 'rw',
  isa  => Str,
);

has artist => (
  is   => 'rw',
  isa  => Str,
);

has composer => (
  is   => 'rw',
  isa  => Str,
);

has genre => (
  is   => 'rw',
  isa  => Str,
);

has tracks => (
  is   => 'rw',
  isa  => ArrayRef,
);

has no_tracks => (
  is   => 'rw',
  isa  => uint32_t,
);

#=====================================================================
1;

__END__

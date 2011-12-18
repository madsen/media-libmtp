#---------------------------------------------------------------------
package Media::LibMTP::Track;
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
# ABSTRACT: Wrap Track object from libmtp
#---------------------------------------------------------------------

use Moose;

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

with 'Media::LibMTP::Role::APIObject';

use namespace::autoclean;
use MooseX::Types::Moose qw(ArrayRef Str);
use Media::LibMTP::Types ':all';

#=====================================================================
sub _API_class { 'Media::LibMTP::API::Track' }

sub _API_attributes
{
  qw(album artist bitrate bitratetype composer date duration filename
     filesize filetype genre item_id modificationdate nochannels parent_id
     rating samplerate storage_id title tracknumber usecount wavecodec);
}

#---------------------------------------------------------------------
has _device => (
  is       => 'rw',
  isa      => LibMTP,
  weak_ref => 1,
);

has item_id => (
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

has title => (
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

has album => (
  is   => 'rw',
  isa  => Str,
);

has date => (
  is   => 'rw',
  isa  => Str,
);

has filename => (
  is   => 'rw',
  isa  => Str,
);

has tracknumber => (
  is   => 'rw',
  isa  => uint16_t,
);

has duration => (
  is   => 'rw',
  isa  => uint32_t,
);

has samplerate => (
  is   => 'rw',
  isa  => uint32_t,
);

has nochannels => (
  is   => 'rw',
  isa  => uint16_t,
);

has wavecodec => (
  is   => 'rw',
  isa  => uint32_t,
);

has bitrate => (
  is   => 'rw',
  isa  => uint32_t,
);

has bitratetype => (
  is   => 'rw',
  isa  => uint16_t,
);

has rating => (
  is   => 'rw',
  isa  => uint16_t,
);

has usecount => (
  is   => 'rw',
  isa  => uint32_t,
);

has filesize => (
  is   => 'rw',
  isa  => uint64_t,
);

has modificationdate => (
  is   => 'rw',
  isa  => time_t,
);

has filetype => (
  is   => 'rw',
  isa  => LIBMTP_filetype_t,
);

#=====================================================================
1;

__END__

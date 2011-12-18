#---------------------------------------------------------------------
package Media::LibMTP::DeviceStorage;
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
# ABSTRACT: Wrap DeviceStorage object from libmtp
#---------------------------------------------------------------------

use Moose;

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

with 'Media::LibMTP::Role::APIObject';

use namespace::autoclean;
use MooseX::Types::Moose qw(ArrayRef Str);
use Media::LibMTP::Types ':all';

#=====================================================================
sub _API_class { 'Media::LibMTP::API::DeviceStorage' }

sub _API_attributes
{
  qw(AccessCapability FilesystemType FreeSpaceInBytes FreeSpaceInObjects
     MaxCapacity StorageDescription StorageType VolumeIdentifier id);
}

#---------------------------------------------------------------------
has _device => (
  is       => 'ro',
  isa      => LibMTP,
  weak_ref => 1,
);

has id => (
  is   => 'ro',
  isa  => uint32_t,
);

has StorageType => (
  is   => 'ro',
  isa  => uint16_t,
);

has FilesystemType => (
  is   => 'ro',
  isa  => uint16_t,
);

has AccessCapability => (
  is   => 'ro',
  isa  => uint16_t,
);

has MaxCapacity => (
  is   => 'ro',
  isa  => uint64_t,
);

has FreeSpaceInBytes => (
  is   => 'ro',
  isa  => uint64_t,
);

has FreeSpaceInObjects => (
  is   => 'ro',
  isa  => uint64_t,
);

has StorageDescription => (
  is   => 'ro',
  isa  => Str,
);

has VolumeIdentifier => (
  is   => 'ro',
  isa  => Str,
);

#=====================================================================
1;

__END__

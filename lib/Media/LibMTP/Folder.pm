#---------------------------------------------------------------------
package Media::LibMTP::Folder;
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
# ABSTRACT: Wrap Folder object from libmtp
#---------------------------------------------------------------------

use Moose;

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

with 'Media::LibMTP::Role::APIObject';

use namespace::autoclean;
use MooseX::Types::Moose qw(ArrayRef Str);
use Media::LibMTP::Types ':all';

#=====================================================================
sub _API_class { 'Media::LibMTP::API::Folder' }

sub _API_attributes
{
  qw(folder_id name parent_id storage_id);
}

#---------------------------------------------------------------------
has _device => (
  is       => 'rw',
  isa      => LibMTP,
  weak_ref => 1,
);

has folder_id => (
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

#=====================================================================
1;

__END__

#---------------------------------------------------------------------
package Media::LibMTP;
#
# Copyright 2011 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 2 Dec 2011
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: Access MTP devices from Perl
#---------------------------------------------------------------------

use 5.010001;                   # revised smart matching
use Moose;

our $VERSION = '0.01';
# This file is part of {{$dist}} {{$dist_version}} ({{$date}})

use namespace::autoclean;
use Media::LibMTP::API qw(Detect_Raw_Devices
  LIBMTP_ERROR_CONNECTING LIBMTP_ERROR_GENERAL
);
use Media::LibMTP::Error ();

use Media::LibMTP::Types ':all';

#=====================================================================

has _device => (
  is       => 'ro',
  isa      => APIDevice,
  required => 1,
  handles => {
    clear_error_stack => 'Clear_Errorstack',
  },
);

has _files => (
  is       => 'rw',
  isa      => APIFile,
  lazy     => 1,
  clearer  => '_clear_files',
  default  => sub { shift->_device->Get_Filelisting },
);

has _folders => (
  is       => 'rw',
  isa      => APIFolder,
  lazy     => 1,
  clearer  => '_clear_folders',
  default  => sub { shift->_device->Get_Folder_List },
);

has _tracks => (
  is       => 'rw',
  isa      => APITrack,
  lazy     => 1,
  clearer  => '_clear_tracks',
  default  => sub { shift->_device->Get_Tracklisting },
);

#=====================================================================
sub connect
{
  my ($class, %criteria) = @_;

  my $timeout  = delete $criteria{timeout} // 30;
  my $interval = delete $criteria{interval} // 3;

  my $list;
  my $err = Detect_Raw_Devices($list);

  Media::LibMTP::Error->throw({
    error_stack => [[ $err, "Detect_Raw_Devices failed with code $err" ]],
  }) if $err;

  my $i = 0;
 DEVICE:
  while (my $raw = $list->device($i++)) {
    keys %criteria;             # reset iterator
    while (my ($field, $match) = each %criteria) {
      next DEVICE unless $raw->$field ~~ $match;
    } # end while my ($field, $match

    my $limit = $timeout + time;
    my $dev;
    while (1) {
      $dev = $raw->Open_Raw_Device_Uncached;
      return $class->new(_device => $dev) if $dev;
      Media::LibMTP::Error->throw({
        error_stack => [[ LIBMTP_ERROR_CONNECTING,
          sprintf("Timed out trying to open device VID=%04x/PID=%04x (%s) ",
                  $raw->vendor_id, $raw->product_id, $raw->product // 'Unknown')
        ]],
      }) if time >= $limit;
      sleep $interval;
    } # end while trying to open device
  } # end while raw device $i

  return undef;                 # No matching device
} # end connect

#---------------------------------------------------------------------
sub error_stack
{
  my $self = shift;

  my @stack;

  my $err = my $errList = $self->_device->Get_Errorstack;

  while ($err) {
    push @stack, [ $err->errornumber, $err->error_text ];
    $err = $err->next;
  }

  return @stack;
} # end error_stack

#---------------------------------------------------------------------
sub _throw_device_error
{
  my $self = shift;

  my @stack = $self->error_stack;
  $self->clear_error_stack;

  Media::LibMTP::Error->throw({
    error_stack => \@stack,
  });
} # end _throw_device_error
#---------------------------------------------------------------------

sub get_folder
{
  my ($self, $path, %param) = @_;

  my $folder = $self->_folders;

  delete $param{current} if $path =~ s!^/!!; # absolute path

  my @names = split m!/!, $path;

  Media::LibMTP::Error->throw({
    error_stack => [[ LIBMTP_ERROR_GENERAL, "MTP does not have a root folder" ]],
  }) unless @names;

  if (defined $param{current}) {
    my $parent = $folder->Find_Folder($param{current});
    Media::LibMTP::Error->throw({
      error_stack => [[ LIBMTP_ERROR_GENERAL, "No folder id $param{current}" ]],
    }) unless $parent;
    $folder = $parent->child;
  } # end if not starting at root

  require Media::LibMTP::Folder;

  while (1) {
    while ($folder->name ne $names[0]) {
      $folder = $folder->sibling or return undef;
    }
    shift @names;

    return Media::LibMTP::Folder->new({ _api => $folder, _device => $self })
        unless @names;

    $folder = $folder->child or return undef;
  } # end forever
} # end get_folder
#---------------------------------------------------------------------

sub get_storage
{
  my $self = shift;

  my $result = $self->_device->Get_Storage(@_);

  $self->_throw_device_error unless $result == 0 or $result == 1;

  require Media::LibMTP::DeviceStorage;

  my @storage;
  for (my $s = $self->_device->storage; $s; $s = $s->next) {
    push @storage, $result
        ? Media::LibMTP::DeviceStorage->new(id => $s->id, _device => $self)
        : Media::LibMTP::DeviceStorage->new({ _api => $s, _device => $self})
  } # end for $s in storage

  return @storage;
} # end get_storage

#=====================================================================
# Package Return Value:

__PACKAGE__->meta->make_immutable;
1;

__END__

=head1 SYNOPSIS

  use Media::LibMTP;

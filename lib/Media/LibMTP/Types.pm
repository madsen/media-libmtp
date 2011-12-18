#---------------------------------------------------------------------
package Media::LibMTP::Types;
#
# Copyright 2011 Christopher J. Madsen
#
# Author: Christopher J. Madsen <perl@cjmweb.net>
# Created: 03 Dec 2011
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either the
# GNU General Public License or the Artistic License for more details.
#
# ABSTRACT: type library for Media::LibMTP
#---------------------------------------------------------------------

our $VERSION = '0.01';

use List::Util qw(max min);
use Media::LibMTP::API ();

use MooseX::Types -declare => [qw(
  APIAlbum APIDevice APIError APIFile APIFileSampleData APIFolder
  APIPlaylist APIRawDevice LibMTP
  LIBMTP_datatype_t LIBMTP_error_number_t LIBMTP_filetype_t
  time_t uint8_t uint16_t uint32_t uint64_t
)];
use MooseX::Types::Moose qw(ArrayRef Int Str);

sub constant_range
{
  my ($class, $category) = @_;

  my ($min, $max) = do {
    my @constants = map { Media::LibMTP::API::constant($_) }
        @{ $Media::LibMTP::API::EXPORT_TAGS{$category} };

    (min(@constants), max(@constants));
  };

  subtype $class,
  as Int,
  where { $_ >= $min and $_ <= $max };
} # end constant_range

class_type APIAlbum,          { class => 'Media::LibMTP::API::Album' };
class_type APIDevice,         { class => 'Media::LibMTP::API::Device' };
class_type APIError,          { class => 'Media::LibMTP::API::Error' };
class_type APIFile,           { class => 'Media::LibMTP::API::File' };
class_type APIFileSampleData, { class => 'Media::LibMTP::API::FileSampleData' };
class_type APIFolder,         { class => 'Media::LibMTP::API::Folder' };
class_type APIPlaylist,       { class => 'Media::LibMTP::API::Playlist' };
class_type APIRawDevice,      { class => 'Media::LibMTP::API::RawDevice' };
class_type LibMTP,            { class => 'Media::LibMTP' };

constant_range(LIBMTP_datatype_t,     'datatypes');
constant_range(LIBMTP_error_number_t, 'errors');
constant_range(LIBMTP_filetype_t,     'filetypes');

subtype time_t as Int;

subtype uint8_t,  as Int, where { $_ >= 0 and $_ <= 0xFF };
subtype uint16_t, as Int, where { $_ >= 0 and $_ <= 0xFFFF };
subtype uint32_t, as Int, where { $_ >= 0 and $_ <= 0xFFFFFFFF };
subtype uint64_t, as Int, where { $_ >= 0 and $_ < 2**64 };

1;

__END__

=head1 DESCRIPTION

These are the custom types used by L<Media::LibMTP>.

=head1 TYPES

=head1 SEE ALSO

L<MooseX::Types>, L<MooseX::Types::Moose>.

=for Pod::Loom-omit
CONFIGURATION AND ENVIRONMENT
INCOMPATIBILITIES
BUGS AND LIMITATIONS

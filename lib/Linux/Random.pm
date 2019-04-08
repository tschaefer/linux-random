package Linux::Random;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT_OK = qw(
  rnd_get_entropy_count
  rnd_clear_pool
  rnd_zap_entropy_count
  rnd_add_to_entropy_count
  rnd_add_entropy
  rnd_get_random
);

our $VERSION = '0.01';

use Fcntl;
use Carp qw(croak);
use Readonly;
use English;
use MIME::Base64 qw(encode_base64 decode_base64);

Readonly my %RNDREQUEST => (
    RNDGETENTCNT   => 0x80045200,
    RNDCLEARPOOL   => 0x5206,
    RNDADDTOENTCNT => 0x40045201,
    RNDADDENTROPY  => 0x40085203,
);

Readonly my $RNDDEVICE => '/dev/urandom';

sub _rnd_ioctl_request {
    my ( $request, $mode, $params ) = @_;

    $params ||= '0000';

    sysopen my $fh, $RNDDEVICE, $mode
      or croak( sprintf "%s: %s", $RNDDEVICE, $! );

    my $rc = ioctl $fh, $request, $params;
    croak( sprintf "ioctl: %s", $! ) if ( $rc < 0 );

    close $fh
      or croak( sprintf "%s: %s", $RNDDEVICE, $! );

    return $mode eq O_RDONLY ? $params : undef;
}

sub _rnd_has_permission {
    croak('Permission denied') if ( $UID != 0 );

    return;
}

sub rnd_get_entropy_count {
    my $entropy = _rnd_ioctl_request( $RNDREQUEST{'RNDGETENTCNT'}, O_RDONLY );

    return unpack 'i', $entropy;
}

sub rnd_clear_pool {
    _rnd_has_permission();

    return _rnd_ioctl_request( $RNDREQUEST{'RNDCLEARPOOL'}, O_WRONLY );
}

sub rnd_zap_entropy_count {
    return rnd_clear_pool();
}

sub rnd_add_to_entropy_count {
    my $count = shift;

    _rnd_has_permission();

    return _rnd_ioctl_request( $RNDREQUEST{'RNDADDTOENTCNT'},
        O_WRONLY, pack 'i', $count );
}

sub rnd_add_entropy {
    my $seed = shift;

    _rnd_has_permission();

    $seed = decode_base64($seed)
      if ( $seed =~ s/^\s*-----BEGIN RANDOM DATA-----\s*//
        && $seed =~ s/-----END RANDOM DATA-----\s*$// );

    my $bytes = length $seed;
    my $bits  = $bytes * 8;

    my $pool = pack "iia*", $bits, $bytes, $seed;

    return _rnd_ioctl_request( $RNDREQUEST{'RNDADDTOENTCNT'}, O_WRONLY, $pool );
}

sub rnd_get_random {
    my ( $bytes, $device, $format ) = @_;

    $device ||= $RNDDEVICE;
    $format ||= 'binary';

    my %rnd = (
        '/dev/random'  => 1,
        '/dev/urandom' => 1,
    );
    croak( sprintf "%s: no such device", $device ) if ( !$rnd{$device} );

    my %out = (
        'binary' => 1,
        'base64' => 1,
    );
    croak( sprintf "%s: no such format", $format ) if ( !$out{$format} );

    sysopen my $fh, $device, O_RDONLY
      or croak( sprintf "%s: %s", $device, $! );

    my $random;
    sysread $fh, $random, $bytes;

    close $fh
      or croak( sprintf "%s: %s", $device, $! );

    return $format eq 'binary'
      ? $random
      : sprintf "-----BEGIN RANDOM DATA-----\n%s-----END RANDOM DATA-----",
      encode_base64($random);
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Linux::Random - Seed entropy and harvest random bytes.

=head1 DESCRIPTION

Linux::Random provides funtionality (via ioctl) to interact with the Linux
kernel random pools. For further information see man 4 random.

=head1 METHODS

=head2 rnd_get_entropy_count

Retrieve the entropy count of the input pool.

=head2 rnd_add_to_entropy_count $bits

Increment or decrement the entropy count of the input pool.

=head2 rnd_add_entropy $seed

Add some additional entropy to the input pool, incrementing the entropy count.

=head2 rnd_zap_entropy_count, rnd_clear_pool

Zero the entropy count of all pools and add some system data (such as wall
clock) to the pools.

=head2 rnd_get_random $bytes, $device, $format

Retrieve random bytes from device (default: urandom) in binary (default) or
base64 encoded format.

    use Linux::Random qw( rnd_get_random );

    rnd_get_random(256, '/dev/random', 'base64');

=head1 AUTHORS

Tobias Schäfer L<github@blackox.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2019 by Tobias Schäfer.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.

=cut

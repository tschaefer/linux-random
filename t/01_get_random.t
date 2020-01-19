use Test::More;

use Linux::Random qw(rnd_get_random);

foreach my $bytes ( 64, 128, 256, 512, 1024, 2048 ) {
    my $rnd = rnd_get_random( $bytes, '/dev/urandom', 'binary' );

    is( length $rnd, $bytes, "got $bytes binary bytes from urandom" );
}

foreach my $bytes ( 64, 128, 256, 512, 1024, 2048 ) {
    my $rnd = rnd_get_random( $bytes, '/dev/random', 'binary' );

    is( length $rnd, $bytes, "got $bytes binary bytes from random" );
}

foreach my $bytes ( 64, 128, 256, 512, 1024, 2048 ) {
    my $rnd = rnd_get_random( $bytes, '/dev/urandom', 'binary' );
    $rnd = decode_base64($seed)
      if ( $rnd =~ s/^\s*-----BEGIN RANDOM DATA-----\s*//
        && $rnd =~ s/-----END RANDOM DATA-----\s*$// );

    is( length $rnd, $bytes, "got $bytes base64 bytes from urandom" );
}

foreach my $bytes ( 64, 128, 256, 512, 1024, 2048 ) {
    my $rnd = rnd_get_random( $bytes, '/dev/random', 'binary' );
    $rnd = decode_base64($seed)
      if ( $rnd =~ s/^\s*-----BEGIN RANDOM DATA-----\s*//
        && $rnd =~ s/-----END RANDOM DATA-----\s*$// );

    is( length $rnd, $bytes, "got $bytes base64 bytes from random" );
}

done_testing();

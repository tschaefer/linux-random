use Test::More;

use Linux::Random qw(
  rnd_add_entropy
  rnd_get_random
  rnd_get_entropy_count
  );

plan skip_all => 'root permission required' if ($< ne 0);

my $rnd = rnd_get_random( 128, '/dev/random', 'binary' );

foreach my $bytes (8, 16, 32, 64) {
    my $pre_cnt = rnd_get_entropy_count();
    rnd_add_entropy(substr $rnd, 0, $bytes);
    my $post_cnt = rnd_get_entropy_count();

    ok($post_cnt > $pre_cnt, "add $bytes bytes of entropy");
}

done_testing();

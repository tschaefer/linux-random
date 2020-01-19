use Test::More;

use Linux::Random qw(
  rnd_add_to_entropy_count
  rnd_get_entropy_count
  );

plan skip_all => 'root permission required' if ($< ne 0);

foreach my $bits (8, 16, 32, 64) {
    my $pre_cnt = rnd_get_entropy_count();
    rnd_add_to_entropy_count($bits);
    my $post_cnt = rnd_get_entropy_count();

    ok($post_cnt > $pre_cnt, "add $bits bits to entropy count");
}

done_testing();

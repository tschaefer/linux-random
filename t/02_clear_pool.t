use Test::More;

use Linux::Random qw(
  rnd_clear_pool
  rnd_zap_entropy_count
  rnd_get_entropy_count
  );

plan skip_all => 'root permission required' if ($< ne 0);

rnd_clear_pool();
my $cnt = rnd_get_entropy_count();
is($cnt, 0, "clear pool");

rnd_zap_entropy_count();
my $cnt = rnd_get_entropy_count();
is($cnt, 0, "zap entropy count");

done_testing();

use Test::More;
use Test::Pod;
use Test::Pod::Coverage;

require_ok('Linux::Random');

pod_file_ok('lib/Linux/Random.pm');
pod_file_ok('bin/rnd');

pod_coverage_ok('Linux::Random');

require Linux::Random;

ok( defined &Linux::Random::rnd_get_entropy_count,
    'defined rnd_get_entropy_count' );
ok( defined &Linux::Random::rnd_clear_pool, 'defined rnd_clear_pool' );
ok( defined &Linux::Random::rnd_zap_entropy_count,
    'defined rnd_zap_entropy_count' );
ok( defined &Linux::Random::rnd_add_to_entropy_count,
    'defined rnd_add_to_entropy_count' );
ok( defined &Linux::Random::rnd_add_entropy, 'defined rnd_add_entropy' );
ok( defined &Linux::Random::rnd_get_random,  'defined rnd_get_random' );

done_testing();

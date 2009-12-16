
sub githubmeta  { warn 'You need Module::Install::GithubMeta installed' }
sub extra_tests { warn 'You need Module::Install::ExtraTests installed' }

use inc::Module::Install;

githubmeta;

name     'MooseX-MarkAsMethods';
all_from 'lib/MooseX/MarkAsMethods.pm';
author   q{Chris Weyl <cweyl@alumni.drew.edu>};
license  'lgpl';

requires 'namespace::autoclean';
requires 'B::Hooks::EndOfScope';
requires 'Moose' >= '0.90';

# cleaning?
requires 'namespace::clean';

test_requires 'Test::More';
test_requires 'Test::Moose';
test_requires 'Perl6::Junction';

extra_tests;
auto_install;
auto_provides;

WriteAll;


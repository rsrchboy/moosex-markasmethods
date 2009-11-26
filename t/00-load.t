#!/usr/bin/env perl

use Test::More tests => 1;

BEGIN {
    use_ok( 'MooseX::MarkAsMethods' );
}

diag( "Testing MooseX::MarkAsMethods $MooseX::MarkAsMethods::VERSION, Perl $], $^X" );

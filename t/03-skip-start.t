use strict;
use warnings;

use Test::More tests => 4;

use Devel::StackTrace;

sub foo
{
    bar();
}

sub bar
{
    my $i = 0;
    return (
        Devel::StackTrace->new,
        Devel::StackTrace->new(find_start_frame => sub { $i++ }),
    );
}

my @frames = map { [$_->frames] } foo();
is(scalar @{ $frames[0] }, 3);
is(scalar @{ $frames[1] }, 2);

shift @{ $frames[0] };
for my $i (0 .. $#{ $frames[0] })
{
    is($frames[0]->[$i]->as_string, $frames[1]->[$i]->as_string);
}

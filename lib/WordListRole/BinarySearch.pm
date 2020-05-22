package WordListRole::BinarySearch;

# AUTHORITY
# DATE
# DIST
# VERSION

use strict 'subs', 'vars';
use warnings;
use Role::Tiny;

sub word_exists {
    no strict 'refs'; # this is required because Role::Tiny forces full stricture

    require File::SortedSeek;

    my ($self, $word) = @_;

    my $origpkg = $self->[3];

    my $dyn = ${"$origpkg\::DYNAMIC"};
    die "Can't binary search on a dynamic wordlist" if $dyn;

    my $fh = \*{"$origpkg\::DATA"};
    my $sort = ${"$origpkg\::SORT"} || "";

    my $tell;
    if ($sort && $sort =~ /num/) {
        $tell = File::SortedSeek::numeric($fh, $word);
    } elsif (!$sort) {
        $tell = File::SortedSeek::alphabetic($fh, $word);
    } else {
        die "Wordlist is not ascibetically/numerically sort (sort=$sort)";
    }

    chomp(my $line = <$fh>);
    defined($line) && $line eq $word;
}

1;
# ABSTRACT: Provide word_exists() that uses binary search

=head1 SYNOPSIS

 use Role::Tiny;
 use WordList::EN::Enable;
 my $wl = WordList::EN::Enable->new;
 Role::Tiny->apply_roles_to_object($wl, "WordListRole::BinarySearch");


=head1 DESCRIPTION

This role provides an alternative C<word_exists()> method that performs binary
searching instead of the default linear. The list must be sorted numerically
(C<$SORT> is C<num> or C<numeric>) or alphabetically (C<$SORT> is empty).


=head1 PROVIDED METHODS

=head2 word_exists


=head1 SEE ALSO

L<File::SortedSeek>

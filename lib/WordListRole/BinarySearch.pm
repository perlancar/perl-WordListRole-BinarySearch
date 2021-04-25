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

    require File::SortedSeek::PERLANCAR;

    my ($self, $word) = @_;

    my $class = $self->{orig_class} // ref($self);

    my $dyn = ${"$class\::DYNAMIC"};
    die "Can't binary search on a dynamic wordlist" if $dyn;

    my $fh = \*{"$class\::DATA"};
    my $sort = ${"$class\::SORT"} || "";

    my $tell;
    if ($sort && $sort =~ /num/) {
        $tell = File::SortedSeek::PERLANCAR::numeric   ($fh, $word, undef, $self->{fh_orig_pos});
    } elsif (!$sort) {
        $tell = File::SortedSeek::PERLANCAR::alphabetic($fh, $word, undef, $self->{fh_orig_pos});
    } else {
        die "Wordlist is not ascibetically/numerically sort (sort=$sort)";
    }

    return 0 unless File::SortedSeek::PERLANCAR::was_exact();
    return 0 unless defined $tell;
    1;
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

package TPM::Meeting;

use strict;
use warnings;

use Carp;
use XML::Twig;
use Date::Parse;
use POSIX 'strftime';
use English '-no_match_vars';

sub new {
    my ($class) = shift;
    return bless { _loaded => 0 }, $class;
}

sub load_file {
    my ( $self, $file_name ) = @_;
    croak 'already loaded' if $self->{__loaded};

    my $t = XML::Twig->new(
        twig_roots => {
            'meeting/details/title'    => sub { $self->_stash_title(@_); },
            'meeting/details/venue'    => sub { $self->_stash_venue(@_); },
            'meeting/details/datetime' => sub { $self->_stash_datetime(@_); },
            'meeting/details/leader'   => sub { $self->_stash_leader(@_); },
            'meeting/description' => sub { $self->_stash_description(@_); },
        },
        pretty_print => 'indented',
    );
    $t->safe_parsefile($file_name) or croak "failed to parse $file_name";

    $self->{__loaded} = 1;

    return;
}

sub title {
    my $self = shift;
    $self->_loaded_or_croak;
    return $self->{_title};
}

sub venue {
    my $self = shift;
    $self->_loaded_or_croak;
    return $self->{_venue};
}

sub timestamp {
    my $self = shift;
    $self->_loaded_or_croak;
    return $self->{_timestamp};
}

sub date {
    my $self = shift;
    $self->_loaded_or_croak;
    return $self->{_date};
}

sub content {
    my $self = shift;
    $self->_loaded_or_croak;
    return $self->{_content};
}

sub _loaded_or_croak {
    my $self = shift;
    croak 'not loaded' if not $self->{__loaded};
    return;
}

sub _stash_title {
    my ( $self, $twig, $elt ) = @_;
    $self->{_title} = $elt->text;
    return;
}

sub _stash_venue {
    my ( $self, $twig, $elt ) = @_;
    $self->{_venue} = $elt->text;
    return;
}

sub _stash_datetime {
    my ( $self, $twig, $elt ) = @_;
    my $text      = $self->{__date_time} = $elt->text;
    my $timestamp = $self->{_timestamp}  = str2time($text);
    $self->{_date} = strftime( '%a %e %b %Y %R %Z', localtime $timestamp );
    return;
}

sub _stash_leader {
    my ( $self, $twig, $elt ) = @_;
    $self->{_leader} = $elt->text;
    return;
}

sub _stash_description {
    my ( $self, $twig, $elt ) = @_;
    $self->{_content} = $elt->sprint;

    # TODO find a better way to peel off outer tags.
    $self->{_content} =~ s{</?description>}{}gxsm;
    return;
}

1;

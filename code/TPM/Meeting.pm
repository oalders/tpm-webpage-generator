package TPM::Meeting;

use strict;
use warnings;

use Carp;
use XML::Twig;
use Date::Parse;
use POSIX 'strftime';

sub new {
    my ($class) = shift;
    return bless { _loaded => 0 }, $class;
}

sub load_file {
    my ( $self, $file_name ) = @_;
    croak "already loaded" if $self->{__loaded};

    my $t = XML::Twig->new(
        twig_roots => {
            'meeting/details/title'    => sub { $self->_stash_title(@_); },
            'meeting/details/venue'    => sub { $self->_stash_venue(@_); },
            'meeting/details/datetime' => sub { $self->_stash_datetime(@_); },
            'meeting/details/leader'   => sub { $self->_stash_leader(@_); },
            'meeting/description'      => sub { $self->_stash_description(@_); },
        },
        pretty_print => 'indented',
    );
    eval { $t->parsefile($file_name); };
    croak $@ if $@;

    $self->{__loaded} = 1;

    return;
}

sub title {
    my $self = shift;
    $self->_loaded_or_croak;
    return $self->{_title};
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
    croak "not loaded" unless $self->{__loaded};
}

sub _stash_title {
    my ( $self, $twig, $elt ) = @_;
    $self->{_title} = $elt->text;
}

sub _stash_venue {
    my ( $self, $twig, $elt ) = @_;
    $self->{_venue} = $elt->sprint;
}

sub _stash_datetime {
    my ( $self, $twig, $elt ) = @_;
    my $text      = $self->{__date_time} = $elt->text;
    my $timestamp = $self->{_timestamp}  = str2time($text);
    $self->{_date} = strftime( '%a %e %b %Y %R %Z', localtime $timestamp );
}

sub _stash_leader {
    my ( $self, $twig, $elt ) = @_;
    $self->{_leader} = $elt->text;
}

sub _stash_description {
    my ( $self, $twig, $elt ) = @_;
    $self->{_content} = $elt->sprint;
}

1;

package TPM::Meeting;

# Use a blessed hash as my object, but prefix keys with _ so that doing
# $o->{foo} will give me undef back in case there are any old hash style
# accesses floating around.

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
            'meeting/details/topic' =>
                sub { $self->_stash_text( @_, 'topic' ); },
            'meeting/details/venue' =>
                sub { $self->_stash_text( @_, 'venue' ); },
            'meeting/details/leader' =>
                sub { $self->_stash_text( @_, 'leader' ); },
            'meeting/details/datetime' => sub { $self->_stash_datetime(@_); },
            'meeting/details/synopsis' =>
                sub { $self->_stash_xhtml( @_, 'synopsis' ); },
            'meeting/talk' => sub { $self->_add_talk(@_); },
        },
        pretty_print => 'indented',
    );
    $t->safe_parsefile($file_name)
        or croak "failed to parse and process $file_name ($EVAL_ERROR)";

    $self->{__loaded} = 1;

    return;
}

# Set up the attribute accessors at compile time

BEGIN {
    my @ATTRIBUTES = qw/ topic venue timestamp date synopsis talks /;

    for my $attr (@ATTRIBUTES) {
        ## no critic 'TestingAndDebugging::ProhibitNoStrict'
        no strict 'refs';
        *{ __PACKAGE__ . q{::} . $attr } = sub {
            my $self = shift;
            $self->_loaded_or_croak;
            return $self->{"_$attr"};
        };
    }
}

sub _loaded_or_croak {
    my $self = shift;
    croak 'not loaded' if not $self->{__loaded};
    return;
}

# General purpose stash routine called as a twig root handler to stash
# attributes which are simple copies of the element's text content.
sub _stash_text {
    my ( $self, $twig, $elt, $attr ) = @_;
    $self->{"_$attr"} = $elt->text;
    return;
}

sub _stash_datetime {
    my ( $self, $twig, $elt ) = @_;
    my $text       = $elt->text;
    my $epoch_secs = str2time($text);
    defined $epoch_secs or croak "failed to parse date time '$text'";
    $self->{_timestamp} = $epoch_secs;
    $self->{_date} = strftime( '%a %e %b %Y %R %Z', localtime $epoch_secs );
    return;
}

sub _stash_xhtml {
    my ( $self, $twig, $elt, $attr ) = @_;
	$self->{"_$attr"} = $elt->inner_xml;
    return;
}

sub _add_talk {
    my ( $self, $twig, $elt ) = @_;
    my $talk = {
        speaker => scalar $elt->first_child('speaker')->text,
        title   => scalar $elt->first_child('title')->text,
    };
    my $description = $elt->first_child('description');
	$description and $talk->{'description'} = $description->inner_xml;
    push @{ $self->{_talks} }, $talk;
    return;
}

1;

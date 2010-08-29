package TPM::WebSite::Meeting;

use common::sense;    # This seems better than blind strict & warnings.
use Carp;
use XML::Twig;
use Date::Parse;
use POSIX 'strftime';
use English '-no_match_vars';
use Path::Class;

# Set up the attribute accessors at compile time

BEGIN {
    my @ATTRIBUTES = qw/ venue timestamp date short_date synopsis talks /;

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

=head1 NAME

TPM::WebSite::Meeting - Encapsulate the information about a TPM Meeting.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use TPM::WebSite::Meeting;

    my $foo = TPM::WebSite::Meeting->new();
    ...

=head1 SUBROUTINES/METHODS

=head2 new

Construct a new object.

=cut

sub new {
    my ($class) = shift;
    return bless { _loaded => 0 }, $class;
}

=head2 load_file($file_name)

=cut

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

=head2 topic

Returns the topic of the meeting.

=cut

# If there is a single talk then the topic probably isn't set.
sub topic {
    my ($self) = @_;

    my $t = $self->{_topic};
    if ( defined $t and length $t ) {
        return $t;
    }
    if ( @{ $self->talks } ) {
        $t = $self->talks->[0]{title};
        if ( defined $t and length $t ) {
            return $t;
        }
    }
    return '(no topic set)';
}

=head2 filename

Returns the suggested file name for the meeting.

=cut

sub filename {
    my ($self) = @_;
    $self->_loaded_or_croak;

    ( my $filename = $self->topic ) =~ s/\W+/_/smxg;
    $filename .= '.html';

    my @localtime = localtime $self->timestamp;
    my $year      = strftime( '%Y', @localtime );
    my $month     = strftime( '%m', @localtime );
    my $day       = strftime( '%d', @localtime );

    # XXX As we are running on Linux the file function will generate
    # a legitimate URL fragment.
    return file( $year, $month, $day, $filename );
}

=head2 date

Returns a string representation of the C<$meeting->timestamp()> containing
date and time.

=head2 short_date

Returns a string representation of the C<$meeting->timestamp()> containing
date only.

=head2 synopsis

Returns the brief synopsis of the meeting (HTML).

=head2 talks

Returns a ref to a list of talks.

=head2 timestamp

Returns the seconds since epoch timestamp of the meeting.

=head2 venue

Returns the meeting's venue (HTML?).

=cut

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
    $self->{_short_date} = strftime( '%e %b %Y', localtime $epoch_secs );
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

=head1 AUTHOR

Mike Stok, C<< <mike at stok.ca> >>

=head1 BUGS

There are plenty, but it's good enough. For me. Use
http://github.com/mikestok/tpm-webpage-generator/issues
to report issues.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TPM::WebSite::Meeting

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Mike Stok.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of TPM::WebSite::Meeting

package TPM::WebSite::Builder;

use common::sense;
use Moose;
use Path::Class;
use File::Basename;
use Readonly;
use English '-no_match_vars';
use Template;
use Carp;
use File::Find::Rule;
use POSIX 'strftime';
use TPM::WebSite::Meeting;
use File::Path;

=pod

=head1 NAME

TPM::WebSite::Builder - driver module to build TPM web pages.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This is the driver module which transforms XML meeting descriptions into
web pages for the Toronto Perl Mongers web site.

Perhaps a little code snippet.

    use TPM::WebSite::Builder;

    my $builder = TPM::WebSite::Builder->new(
        root_dir => '..',
        run_timestamp => time,
    );
    $builer->run();

=head1 SUBROUTINES/METHODS

=head2 new

This is provided by Moose.  The attributes which can be set in this are:

=over 4

=item root_dir

The root directory for the input and output trees.

=item run_timestamp

The seconds since Unix epoch used to mark the time the script was run.

=back

=cut

has root_dir => ( is => 'ro' );
has run_timestamp => ( is => 'ro', isa => 'Int' );

=head2 run

This causes the input XML files to be read, and the HTML files for the website
to be generated.  If errors are detected then the method dies.

=cut

sub run {
    my $self = shift;

    my $root          = $self->root_dir();
    my $run_timestamp = $self->run_timestamp();

    my $sections = $self->_get_sections( dir( $root, 'sections' ) );
    my $meetings
        = $self->_group_meetings_by_year( $self->_get_meetings( dir( $root, 'meetings' ) ) );
    my $upcoming_or_recent
        = $self->_find_upcoming_or_recent( $meetings, $run_timestamp );
    my $output_dir = dir( $root, 'to.pm.org' );
    my $template = Template->new(
        {   RELATIVE => 1,
            INCLUDE_PATH =>
                [ dir( $root, 'templates' )->stringify ],
            OUTPUT_PATH => $output_dir->stringify,
        }
    );

    my $generated_timestamp = scalar localtime $run_timestamp;

    # generate the index page
    $template->process(
        'index.tt',
        {   sections           => $sections,
            years_meetings     => $meetings,
            upcoming_or_recent => $upcoming_or_recent,
            generated_at       => $generated_timestamp,
        },
        'index.html'
    ) || croak $template->error();

    $self->_generate_meetings( $template, $meetings, $generated_timestamp,
        $output_dir );

    return;
}

sub _generate_meetings {
    my ( $self, $template_processor, $years_meetings, $generated_at, $root_dir )
        = @_;

    for my $year ( @{$years_meetings} ) {
        for my $meeting ( @{ $year->{meetings} } ) {
            my $dir = dir( $root_dir, $meeting->filename->dir );
            File::Path::make_path( $dir->stringify );
            $template_processor->process(
                'meeting.tt',
                {   meeting      => $meeting,
                    generated_at => $generated_at,
                },
                $meeting->filename->stringify
            ) || croak $template_processor->error;
        }
    }

    return;
}

# in:
#   directory under which sections live in separate html files
# out:
#   sorted list of sections { name => ..., content => ... }
#
# File names determine the section names, the files are assumed to
# contain valid HTML.
sub _get_sections {
    my ($self, $sections_dir) = @_;
    Readonly my $SECTION_SUFFIX => '.html';

    return [
        map {
            {   name    => basename( $_, $SECTION_SUFFIX ),
                content => scalar file($_)->slurp,
            }
            }
            sort
            grep {/\Q$SECTION_SUFFIX\E\z/smox} dir($sections_dir)->children
    ];
}

# in:
#  directory for root of tree
# out:
#  ref to list of TPM::WebSite::Meeting objects
sub _get_meetings {
    my ($self, $meetings_dir) = @_;
    my @meetings;

    for my $file ( find( file => name => '*.xml', in => $meetings_dir ) ) {
        my $meeting = TPM::WebSite::Meeting->new;
        $meeting->load_file($file);
        push @meetings, $meeting;
    }

    return \@meetings;
}

# in:
#   ref to unordered list of meetings
# out:
#   ref to list of hashes { year => yyyy, meetings => [ ... ] }
sub _group_meetings_by_year {
    my ($self, $unordered_list) = @_;
    my @list
        = sort { $a->timestamp <=> $b->timestamp || $a->topic cmp $b->topic }
        @{$unordered_list};

    my @year_groups;
    for my $meeting (@list) {
        my $year = strftime( '%Y', localtime $meeting->timestamp );

        if (   @year_groups == 0
            || $year != $year_groups[-1]{year} )
        {
            push @year_groups, { year => $year, meetings => [] };
        }

        push @{ $year_groups[-1]{meetings} }, $meeting;
    }

    return \@year_groups;
}

# in:
#   return value from group_meetings_by_year
#   timestamp for "now"
# out:
#   ref to a meeting or undef
#
# Hugely expensive O(n) lookup, but in 50 years there are only going to be
# 600 meetings and I'll likely be dead.
#
# Go throuugh all the meetings in cronological order remembering the
# last one seen.  If the timestamp of the meeting is in the future then
# quit looping.  (Future relative to the timestamp passed in.)
#
# If there are no meetings undef will be returned.
# If there are no meetings in the future then the last meeting will be returned.
# If there meetings in the future then the closest meeting is returned.

sub _find_upcoming_or_recent {
    my ( $self, $years, $timestamp ) = @_;
    my $return;

YEAR_LOOP:
    for my $year ( @{$years} ) {
    MEETING_LOOP:

        for my $meeting ( @{ $year->{meetings} } ) {
            $return = $meeting;
            last YEAR_LOOP if $meeting->timestamp > $timestamp;
        }
    }

    return $return;
}

=head1 AUTHOR

Mike Stok, C<< <mike at stok.ca> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-tpm::website at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=TPM::WebSite>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc TPM::WebSite::Builder

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2010 Mike Stok.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1;    # End of TPM::WebSite::Builder

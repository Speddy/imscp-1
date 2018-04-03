=head1 NAME

 iMSCP::Packages::AbstractCollection - Abstract collection implementation for i-MSCP packages

=cut

# i-MSCP - internet Multi Server Control Panel
# Copyright (C) 2010-2018 Laurent Declercq <l.declercq@nuxwin.com>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA

package iMSCP::Packages::Collection;

use strict;
use warnings;
use Carp qw/ croak /;
use File::Basename qw/ dirname /;
use iMSCP::Debug qw/ debug /;
use iMSCP::Dir;
use iMSCP::Getopt;
use iMSCP::Dialog::InputValidation qw/ isOneOfStringsInList /;
use Carp qw/ confess croak /;
use parent 'iMSCP::Packages::Abstract';

=head1 DESCRIPTION

 This class provides an abstract collection implementation for the i-MSCP packages.

=head1 PUBLIC METHODS

=over 4

=item registerSetupListeners( )

 See iMSCP::Packages::Abstract::registerSetupListeners()

=cut

sub registerSetupListeners
{
    my ( $self ) = @_;

    $self->{'eventManager'}->registerOne( 'beforeSetupDialog', sub { push @{ $_[0] }, sub { $self->showDialog( @_ ) }; } );
}

=item showDialog( \%dialog )

 Show dialog

 Param iMSCP::Dialog \%dialog
 Return int 0 (NEXT), 30 (BACK) or 50 (ESC)

=cut

sub showDialog
{
    my ( $self, $dialog ) = @_;

    my $packageName = $self->getPackageName();
    my $ucPackageName = uc $packageName;

    @{ $self->{'SELECTED_PACKAGES'} } = split(
        ',', ::setupGetQuestion( "${ucPackageName}_PACKAGES", iMSCP::Getopt->preseed ? join( ',', @{ $self->{'AVAILABLE_PACKAGES'} } ) : '' )
    );

    my %choices;
    @choices{@{ $self->{'AVAILABLE_PACKAGES'} }} = @{ $self->{'AVAILABLE_PACKAGES'} };

    if ( isOneOfStringsInList( iMSCP::Getopt->reconfigure, [ lc $packageName, 'all', 'forced' ] )
        || !@{ $self->{'SELECTED_PACKAGES'} } || grep { !exists $choices{$_} && $_ ne 'no' } @{ $self->{'SELECTED_PACKAGES'} }
    ) {
        ( my $rs, $self->{'SELECTED_PACKAGES'} ) = $dialog->checkbox(
            <<"EOF", \%choices, [ grep { exists $choices{$_} && $_ ne 'no' } @{ $self->{'SELECTED_PACKAGES'} } ] );

Please select the $packageName packages you want to install:
\\Z \\Zn
EOF
        return $rs unless $rs < 30;
    }

    @{ $self->{'SELECTED_PACKAGES'} } = grep ( $_ ne 'no', @{ $self->{'SELECTED_PACKAGES'} } );

    ::setupSetQuestion( "${ucPackageName}_PACKAGES", @{ $self->{'SELECTED_PACKAGES'} } ? join ',', @{ $self->{'SELECTED_PACKAGES'} } : 'no' );

    for ( $self->getCollection() ) {
        next unless $_->can( 'showDialog' );

        debug( sprintf( 'Executing showDialog action on %s', $fpackage ));
        my $rs = $_->showDialog();
        return $rs if $rs;
    }

    0;
}

=item preinstall( )

 See iMSCP::Packages::Abstract::preinstall()

=cut

sub preinstall
{
    my ( $self ) = @_;

    my @distroPackages = ();
    #    for my $package ( @{ $self->{'AVAILABLE_PACKAGES'} } ) {
    #        next if grep ( $package eq $_, @{ $self->{'SELECTED_PACKAGES'} });
    #        $package = "iMSCP::Packages::Webmail::${package}::${package}";
    #        eval "require $package" or die( $@ );
    #
    #        if ( my $subref = $package->can( 'uninstall' ) ) {
    #            debug( sprintf( 'Executing uninstall action on %s', $package ));
    #            $subref->( $package->getInstance( eventManager => $self->{'eventManager'} ));
    #        }
    #
    #        ( my $subref = $package->can( 'getDistroPackages' ) ) or next;
    #        debug( sprintf( 'Executing getDistroPackages action on %s', $package ));
    #        push @distroPackages, $subref->( $package->getInstance( eventManager => $self->{'eventManager'} ));
    #    }
    #
    #    $self->_removePackages( @distroPackages );

    @distroPackages = ();
    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing preinstall action on %s', $fpackage ));
        $_->preinstall();

        debug( sprintf( 'Executing getDistroPackages action on %s', $fpackage ));
        push @distroPackages, $_->getDistroPackages();
    }

    $self->_installPackages( @distroPackages );
}

=item install( )

 See iMSCP::Packages::Abstract::install()

=cut

sub install
{
    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing install action on %s', $fpackage ));
        $_->install();
    }
}

=item postinstall( )

 See iMSCP::Packages::Abstract::postinstall()

=cut

sub postinstall
{
    my ( $self ) = @_;

    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing postinstall action on %s', $fpackage ));
        $_->postinstall();
    }
}

=item preuninstall( )

 See iMSCP::Packages::Abstract::preuninstall()

=cut

sub preuninstall
{
    my ( $self ) = @_;

    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing install action on %s', $fpackage ));
        $_->preuninstall();
    }
}

=item uninstall( )

 See iMSCP::Packages::Abstract::uninstall()

=cut

sub uninstall
{
    my ( $self ) = @_;

    my @distroPackages = ();
    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing uninstall action on %s', ref $_ ));
        $_->uninstall();

        debug( sprintf( 'Executing getDistroPackages action on %s', $fpackage ));
        push @distroPackages, $_->getDistroPackages();
    }

    $self->_removePackages( @distroPackages );
}

=item postuninstall( )

 See iMSCP::Packages::Abstract::postuninstall()

=cut

sub postuninstall
{
    my ( $self ) = @_;

    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing postuninstall action on %s', $fpackage ));
        $_->postuninstall();
    }
}

=item setBackendPermissions( )

 See iMSCP::Packages::Abstract::setBackendPermissions()

=cut

sub setBackendPermissions
{
    my ( $self ) = @_;

    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing setBackendPermissions action on %s', $fpackage ));
        $_->setBackendPermissions();
    }
}

=item setFrontendPermissions( )

 See iMSCP::Packages::Abstract::setFrontendPermissions()

=cut

sub setFrontendPermissions
{
    my ( $self ) = @_;

    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing setFrontendPermissions action on %s', $fpackage ));
        $_->setFrontendPermissions();
    }
}

=item dpkgPostInvokeTasks()

 See iMSCP::Packages::Abstract::dpkgPostInvokeTasks()

=cut

sub dpkgPostInvokeTasks
{
    my ( $self ) = @_;

    for ( $self->getCollection() ) {
        debug( sprintf( 'Executing dpkgPostInvokeTasks action on %s', $fpackage ));
        $_->dpkgPostInvokeTasks();
    }
}

=item getCollection()

 Get list of selected package instances from this collection, sorted in descending order of priority

 Return list of package instances

=cut

sub getCollection
{
    my ( $self ) = @_;

    CORE::state @collection = sort { $b->getPackagePriority() <=> $a->getPackagePriority() } map {
        my $package = "iMSCP::Packages::@{ [ $self->getPackageName() ] }::$_::$_";
        eval "require $package; 1" or die( $@ );
        $package->getInstance();
    } $self->{'SELECTED_PACKAGES'};

    @collection;
}

=item AUTOLOAD()

 Implements autoloading for undefined methods

 The default implementation will raise an error for any method that is not known
 to be called by the iMSCP::Modules::Abstract class.

 Return void, die on failure

=cut

sub AUTOLOAD
{
    ( my $method = our $AUTOLOAD ) =~ s/.*:://;

    $method =~ /^
        (?:pre|post)?
        (?:add|disable|restore|delete)
        (?:Domain|CustomDNS|FtpUser|Htaccess|Htgroup|Htpasswd|IpAddr|Mail|SSLcertificate|Subdomain|User)
        $/x or die( sprintf( 'Unknown %s method', $AUTOLOAD ));

    # Define the method
    no strict 'refs';
    *{ $AUTOLOAD } = sub {
        my ( $self ) = @_;

        for ( $self->getCollection() ) {
            debug( sprintf( 'Executing %s action on %s', $method, $fpackage ));
            $_->$method();
        }
    };

    # Erase the stack frame by calling the method
    goto &{ $AUTOLOAD };
}

=back

=head1 PRIVATE METHODS

=over 4

=item _init( )

 See iMSCP::Packages::Abstract::_init()

=cut

sub _init
{
    my ( $self ) = @_;

    ref $self ne __PACKAGE__ or croak( sprintf( 'The %s class is an abstract class which cannot be instantiated', __PACKAGE__ ));

    if ( iMSCP::Getopt->context() eq 'installer' ) {
        @{ $self->{'AVAILABLE_PACKAGES'} } = iMSCP::Dir->new( dirname => dirname( __FILE__ ) . '/' . $self->getPackageName())->getDirs();
    }

    @{ $self->{'SELECTED_PACKAGES'} } = grep $_ ne 'no', split( ',', $::imscpConfig{'WEBSTATS_PACKAGES'} );
    $self->SUPER::_init();
}

=item _loadConfig( [ $filename = lc( $self->getPackageName() . 'data ) ] )

 See iMSCP::Packages::Abstract::_loadConfig()

=cut

sub _loadConfig
{
    my ( $self, $filename ) = @_;

    # Nothing to do here (collection)
}

=back

=head1 AUTHOR

 Laurent Declercq <l.declercq@nuxwin.com>

=cut

1;
__END__

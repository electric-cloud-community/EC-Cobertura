# -------------------------------------------------------------------------
# Package
#    Common.pm
#
# Dependencies
#    none
#
# Purpose
#    a bunch of common functions for the Electric Commander plugin development
#
# Date
#    10/07/2011
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

package Common;

use strict;
use File::Copy;
use ElectricCommander;

#constructor
sub new {
    my $class = shift;
    #attributes
    my $self = {};
    bless $self, $class;
    return $self;
}


########################################################################
# createCommandLine - creates the command line for the invocation
# of the program to be executed.
#
# Arguments:
#   -arr: array containing the command name and the arguments entered by
#         the user in the UI
#
# Returns:
#   -the command line to be executed by the plugin
#
########################################################################
sub createCommandLine {
    my $self = shift;
    my ($arr) = shift;
    my $command = @$arr[0];
    shift(@$arr);
    foreach my $elem (@$arr) {
        $command .= " $elem";
    }
    return $command;
}

########################################################################
# trim - deletes blank spaces before and after the entered value in
# the argument
#
# Arguments:
#   -untrimmedString: string that will be trimmed
#
# Returns:
#   trimmed string
#
########################################################################
sub trim{
    my $self = shift;
    my $untrimmedString = shift;
    $untrimmedString =~ s/^\s+//xsm;
    $untrimmedString =~ s/\s+$//xsm;
    return $untrimmedString;
}

########################################################################
# setProperties - set a group of properties into the Electric Commander
#
# Arguments:
#   -propHash: hash containing the ID and the value of the properties
#              to be written into the Electric Commander
#
# Returns:
#   -nothing
#
########################################################################
sub setProperties {
    my $self = shift;
    my $propHash = shift;
    # get an EC object
    my $ec = ElectricCommander->new;
    $ec->abortOnError(0);

    foreach my $key (keys % $propHash) {
        my $val = $propHash->{$key};
        $ec->setProperty("/myCall/$key", $val);
    }
    return;
}

########################################################################
# IsEmptyOrNull - validate null or empty values
#
# Arguments:
#   -values: variable you want to validate
#
#
# Returns:
#   -0 / 1 
#
########################################################################
sub IsEmptyOrNull {
    my $self = shift;
    my $value = shift;
    if($value && $value ne ''){
        return 0;
    }
    return 1;
}

########################################################################
# printVersion - prints the plugin version
#
# Arguments:
#   -pluginName: Name of the currect plugin name
#
#
# Returns:
#   -nothing
#
########################################################################
sub printVersion {
    my $self = shift;
    my $pluginName = shift;
    my $ec = ElectricCommander->new;
    $ec->abortOnError(0);
    my $xpath = $ec->getPlugin($pluginName);
    my $version = $xpath->findvalue('//pluginVersion')->value;
    return "Using plugin $pluginName version $version\n";
}

########################################################################
# copyFiles - copy a list of file to the specified directory
#
# Arguments:
#   files:   an array containing the folders you want to copy
#   destiny: the folder where you want to copy the files to.
#
#
# Returns:
#   -nothing
#
########################################################################
sub copyFiles {
    my $self = shift;
    my $files = shift;
    my $destiny = shift;
    foreach my $i (@$files) {
        copy($i, "$destiny");
    }
}

1;

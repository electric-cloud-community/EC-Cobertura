# -------------------------------------------------------------------------
# Package
#    TestRunner.pm
#
# Dependencies
#    TestRunner.pm Module
#
# Purpose
#    Creates command line that runs the application for test
#
# Date
#    10/24/2011
#
# Engineer
#    Carlos Rojas
#
# Copyright (c) 2011 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------

package TestRunner;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use utf8;
use strict;
use warnings;
use lib "$ENV{COMMANDER_PLUGINS}/@PLUGIN_NAME@/agent/lib";
use Common;

# -------------------------------------------------------------------------
# constructor
# -------------------------------------------------------------------------
sub new {
    my $class = shift;
    #attributes
    my $self = {
        CoberturaPath  => shift,
        JavaPath       => shift,
        ClassPath      => shift,
        Destination    => shift,
        Datafile       => shift,
        TestCmd        => shift
    };
    bless $self, $class;
    return $self;
}

# -------------------------------------------------------------------------
# Sets
# -------------------------------------------------------------------------
sub setCoberturaPath {
    my $self = shift;
    my $value  = shift;
    $self->{CoberturaPath} = $value if defined($value);
    return $self->{CoberturaPath};
}

sub setJavaPath {
    my $self = shift;
    my $value  = shift;
    $self->{JavaPath} = $value if defined($value);
    return $self->{JavaPath};
}

sub setClassPath {
    my $self = shift;
    my $value  = shift;
    $self->{ClassPath} = $value if defined($value);
    return $self->{ClassPath};
}

sub setDestination{
    my $self = shift;
    my $value  = shift;
    $self->{Destination} = $value if defined($value);
    return $self->{Destination};
}

sub setDatafile{
    my $self = shift;
    my $value  = shift;
    $self->{Datafile} = $value if defined($value);
    return $self->{Datafile};
}

sub setTestCmd{
    my $self = shift;
    my $value  = shift;
    $self->{TestCmd} = $value if defined($value);
    return $self->{TestCmd};
}

sub GetCommandline{
    my $self = shift;
    my $classpath = "-cp ";
    my $separator = ";";
    if($^O eq "linux")
    {
        $separator = ":";
    }
    #instance the common module
    my @cmd = ();
    #instance the common module
    my $utility = Common->new();
    #java path
    if(!$utility->IsEmptyOrNull($self->{BaseDir})){
        push(@cmd, qq{"$self->{JavaPath}"});
    }else{
        push(@cmd, "java");
    }
    #cobertura path
    if(!$utility->IsEmptyOrNull($self->{CoberturaPath})){
        $classpath .= qq{"$self->{CoberturaPath}/cobertura.jar"};
    }
    #Destination
    if(!$utility->IsEmptyOrNull($self->{Destination})){
        $classpath .= qq{$separator"$self->{Destination}"};
    }
    #Classes
    if(!$utility->IsEmptyOrNull($self->{ClassPath})){
        $classpath .= qq{$separator$self->{ClassPath}};
    }
    push(@cmd, $classpath);
    #Datafile
    if(!$utility->IsEmptyOrNull($self->{Datafile})){
        push(@cmd,qq{-Dnet.sourceforge.cobertura.datafile="$self->{Datafile}"});
    }
    #TestCommand
    if(!$utility->IsEmptyOrNull($self->{TestCmd})){
        push(@cmd, $self->{TestCmd});
    }

    return $utility->createCommandLine(\@cmd);
    
}

1;

# -------------------------------------------------------------------------
# Package
#    Instrument.pm
#
# Dependencies
#    Common.pm Module
#
# Purpose
#    Creates the cobertura-instrument command line
#    cobertura-instrument.bat [--basedir dir] [--datafile file] [--destination dir] [--ignore regex] classes [...]
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

package Instrument;

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
        BaseDir        => shift,
        Datafile       => shift,
        Destination    => shift,
        Classes        => shift,
        Additional     => shift
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

sub setBaseDir{
    my $self = shift;
    my $value  = shift;
    $self->{BaseDir} = $value if defined($value);
    return $self->{BaseDir};
}

sub setDatafile{
    my $self = shift;
    my $value  = shift;
    $self->{Datafile} = $value if defined($value);
    return $self->{Datafile};
}

sub setDestination{
    my $self = shift;
    my $value  = shift;
    $self->{Destination} = $value if defined($value);
    return $self->{Destination};
}

sub setClasses{
    my $self = shift;
    my $value  = shift;
    $self->{Classes} = $value if defined($value);
    return $self->{Classes};
}

sub setAdditional{
    my $self = shift;
    my $value  = shift;
    $self->{Additional} = $value if defined($value);
    return $self->{Additional};
}

sub GetCommandline{
    my $self = shift;
    #instance the common module
    my @cmd = ();
    my $extension = ".bat";
    if($^O eq "linux")
    {
        $extension = ".sh";
    }
    my $executable = $self->{CoberturaPath};
    if($executable && $executable ne ""){
        $executable .= "/cobertura-instrument$extension";
    }else{
        $executable .= "cobertura-instrument$extension";
    }
    push(@cmd, $executable);
    #instance the common module
    my $utility = Common->new();
    
    #Additional commands
    if(!$utility->IsEmptyOrNull($self->{Additional})){
        foreach my $command (split(' +', $self->{Additional})) {
             push(@cmd, "$command");
        }
    }
    
    #base dir
    if(!$utility->IsEmptyOrNull($self->{BaseDir})){
        push(@cmd,qq{--basedir "$self->{BaseDir}"});
    }
    
    #Datafile
    if(!$utility->IsEmptyOrNull($self->{Datafile})){
        push(@cmd,qq{--datafile "$self->{Datafile}"});
    }
    
    #Destination
    if(!$utility->IsEmptyOrNull($self->{Destination})){
        push(@cmd,qq{--destination "$self->{Destination}"});
    }
    
    #Classes
    if(!$utility->IsEmptyOrNull($self->{Classes})){
        push(@cmd,qq{"$self->{Classes}"});
    }
    
    return $utility->createCommandLine(\@cmd);
    
}

1;

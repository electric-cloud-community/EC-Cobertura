# -------------------------------------------------------------------------
# Package
#    Reporting.pm
#
# Dependencies
#    Reporting.pm Module
#
# Purpose
#    Creates the cobertura-report command line in order to create report
#    cobertura-report.bat [--datafile file] [--destination dir] [--format (html|xml)] [--encoding encoding] source code directory [...] [--basedir dir file underneath basedir ...]
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

package Reporting;

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
        Format         => shift,
        CodeDirectory  => shift,
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

sub setBaseDir {
    my $self = shift;
    my $value  = shift;
    $self->{BaseDir} = $value if defined($value);
    return $self->{BaseDir};
}

sub setDatafile {
    my $self = shift;
    my $value  = shift;
    $self->{Datafile} = $value if defined($value);
    return $self->{Datafile};
}

sub setDestination {
    my $self = shift;
    my $value  = shift;
    $self->{Destination} = $value if defined($value);
    return $self->{Destination};
}

sub setFormat {
    my $self = shift;
    my $value  = shift;
    $self->{Format} = $value if defined($value);
    return $self->{Format};
}

sub setCodeDirectory {
    my $self = shift;
    my $value  = shift;
    $self->{CodeDirectory} = $value if defined($value);
    return $self->{CodeDirectory};
}

sub setAdditional{
    my $self = shift;
    my $value  = shift;
    $self->{Additional} = $value if defined($value);
    return $self->{Additional};
}

sub GetCommandline{
    my $self = shift;
    my @cmd = ();
    my $extension = ".bat";
    if($^O eq "linux")
    {
        $extension = ".sh";
    }
    my $executable = $self->{CoberturaPath};
    if($executable && $executable ne ""){
        $executable .= "/cobertura-report$extension";
    }else{
        $executable .= "cobertura-report$extension";
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
    
    #Datafile
    if(!$utility->IsEmptyOrNull($self->{Datafile})){
        push(@cmd,qq{--datafile "$self->{Datafile}"});
    }
    
    #Destination
    if(!$utility->IsEmptyOrNull($self->{Destination})){
        push(@cmd,qq{--destination "$self->{Destination}"});
    }
    
    #Format
    if(!$utility->IsEmptyOrNull($self->{Format})){
        push(@cmd,qq{--format $self->{Format}});
    }
    
    #CodeDirectory
    if(!$utility->IsEmptyOrNull($self->{CodeDirectory})){
        push(@cmd,qq{"$self->{CodeDirectory}"});
    }
    
    #base dir
    if(!$utility->IsEmptyOrNull($self->{BaseDir})){
        push(@cmd,qq{--basedir "$self->{BaseDir}"});
    }
    
    return $utility->createCommandLine(\@cmd);
    
}

1;

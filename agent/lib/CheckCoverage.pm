# -------------------------------------------------------------------------
# Package
#    CheckCoverage.pm
#
# Dependencies
#    Common.pm Module
#
# Purpose
#    Creates the cobertura-check command line
#    cobertura-check.bat [--datafile file] [--branch 0..100] [--line 0..100] [--totalbranch 0..100] [--totalline 0..100] [--regex regex:branchrate:linerate]
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

package CheckCoverage;

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
        Branch         => shift,
        Datafile       => shift,
        Line           => shift,
        PackageBranch  => shift,
        PackageLine    => shift,
        TotalBranch    => shift,
        TotalLine      => shift,
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

sub setBranch {
    my $self = shift;
    my $value  = shift;
    $self->{Branch} = $value if defined($value);
    return $self->{Branch};
}

sub setDatafile {
    my $self = shift;
    my $value  = shift;
    $self->{Datafile} = $value if defined($value);
    return $self->{Datafile};
}

sub setLine {
    my $self = shift;
    my $value  = shift;
    $self->{Line} = $value if defined($value);
    return $self->{Line};
}

sub setPackageBranch {
    my $self = shift;
    my $value  = shift;
    $self->{PackageBranch} = $value if defined($value);
    return $self->{PackageBranch};
}

sub setPackageLine {
    my $self = shift;
    my $value  = shift;
    $self->{PackageLine} = $value if defined($value);
    return $self->{PackageLine};
}

sub setTotalBranch {
    my $self = shift;
    my $value  = shift;
    $self->{TotalBranch} = $value if defined($value);
    return $self->{TotalBranch};
}

sub setTotalLine {
    my $self = shift;
    my $value  = shift;
    $self->{TotalLine} = $value if defined($value);
    return $self->{TotalLine};
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
        $executable .= "/cobertura-check$extension";
    }else{
        $executable .= "cobertura-check$extension";
    }
    push(@cmd, $executable);
    #instance the common module
    my $utility = Common->new();
    
    #Datafile
    if(!$utility->IsEmptyOrNull($self->{Datafile})){
        push(@cmd,qq{--datafile "$self->{Datafile}"});
    }
    
    #Additional commands
    if(!$utility->IsEmptyOrNull($self->{Additional})){
        foreach my $command (split(' +', $self->{Additional})) {
             push(@cmd, "$command");
        }
    }
    
    #Line
    if(!$utility->IsEmptyOrNull($self->{Line})){
        push(@cmd,qq{--line $self->{Line}});
    }
    
    #PackageBranch
    if(!$utility->IsEmptyOrNull($self->{PackageBranch})){
        push(@cmd,qq{--packagebranch $self->{PackageBranch}});
    }
    
    #PackageLine
    if(!$utility->IsEmptyOrNull($self->{PackageLine})){
        push(@cmd,qq{--packageline $self->{PackageLine}});
    }
    
    #TotalBranch
    if(!$utility->IsEmptyOrNull($self->{TotalBranch})){
        push(@cmd,qq{--totalbranch $self->{TotalBranch}});
    }
    
    #TotalLine
    if(!$utility->IsEmptyOrNull($self->{TotalLine})){
        push(@cmd,qq{--totalline $self->{TotalLine}});
    }
    
    return $utility->createCommandLine(\@cmd);
    
}

1;

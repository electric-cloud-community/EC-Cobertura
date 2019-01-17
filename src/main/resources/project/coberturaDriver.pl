# -------------------------------------------------------------------------
# Package
#    coberturaDriver.pl
#
# Dependencies
#    Common.pm
#    Instrument.pm
#    TestRunner.pm
#    CheckCoverage.pm
#    Reporting.pm
#
# Purpose
#    Perl script to create a mysql command line
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
package coberturaDriver;

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------

use Cwd;
use lib "$ENV{COMMANDER_PLUGINS}/@PLUGIN_NAME@/agent/lib";
use strict;
use Common;
use Reporting;
use Instrument;
use TestRunner;
use CheckCoverage;
use ElectricCommander;

sub main{
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    my %props;
    
    # -------------------------------------------------------------------------
    # general parameters
    # -------------------------------------------------------------------------
    my $CoberturaPath = ($ec->getProperty( "CoberturaPath" ))->findvalue('//value')->string_value;
    my $BaseDir       = ($ec->getProperty( "BaseDir" ))->findvalue('//value')->string_value;
    my $Datafile      = ($ec->getProperty( "Datafile" ))->findvalue('//value')->string_value;
    my $Destination   = ($ec->getProperty( "Destination" ))->findvalue('//value')->string_value;
    my $WorkingDir    = ($ec->getProperty( "WorkingDir" ))->findvalue('//value')->string_value;
    my $Classes       = ($ec->getProperty( "Classes" ))->findvalue('//value')->string_value;
    
    
    # -------------------------------------------------------------------------
    # Test parameters
    # -------------------------------------------------------------------------
    my $ClassPath     = ($ec->getProperty( "ClassPath" ))->findvalue('//value')->string_value;
    my $JavaPath      = ($ec->getProperty( "JavaPath" ))->findvalue('//value')->string_value;
    my $TestCmd       = ($ec->getProperty( "TestCmd" ))->findvalue('//value')->string_value;
    
    # -------------------------------------------------------------------------
    # coverage parameters
    # -------------------------------------------------------------------------
    my $Branch        = ($ec->getProperty( "Branch" ))->findvalue('//value')->string_value;
    my $Line          = ($ec->getProperty( "Line" ))->findvalue('//value')->string_value;
    my $PackageBranch = ($ec->getProperty( "PackageBranch" ))->findvalue('//value')->string_value;
    my $PackageLine   = ($ec->getProperty( "PackageLine" ))->findvalue('//value')->string_value;
    my $TotalBranch   = ($ec->getProperty( "TotalBranch" ))->findvalue('//value')->string_value;
    my $TotalLine     = ($ec->getProperty( "TotalLine" ))->findvalue('//value')->string_value;
    
    # -------------------------------------------------------------------------
    # Reporting parameters
    # -------------------------------------------------------------------------
    my $ReportFolder  = ($ec->getProperty( "ReportFolder" ))->findvalue('//value')->string_value;
    my $Format        = ($ec->getProperty( "Format" ))->findvalue('//value')->string_value;
    my $SourceDir     = ($ec->getProperty( "SourceDir" ))->findvalue('//value')->string_value;
    
    # -------------------------------------------------------------------------
    # Additional parameters
    # -------------------------------------------------------------------------
    my $InstrumentCommands = ($ec->getProperty( "InstrumentCommands" ))->findvalue('//value')->string_value;
    my $ReportCommands     = ($ec->getProperty( "ReportCommands" ))->findvalue('//value')->string_value;
    my $CheckCommands      = ($ec->getProperty( "CheckCommands" ))->findvalue('//value')->string_value;
    
    #instance the common module
    my $utility = Common->new();
    #print the current plugin version
    print $utility->printVersion("EC-Cobertura");
    
    if($utility->IsEmptyOrNull($Destination)){
        $Destination = cwd;
        $Datafile = $Destination . "/" . $Datafile; 
    }
    if($utility->IsEmptyOrNull($ReportFolder)){
        $ReportFolder = cwd;
    }
    
    
    
    #Instances 
    my $instrument    = Instrument->new($CoberturaPath, $BaseDir, $Datafile, $Destination, $Classes, $InstrumentCommands);
    my $testRunner    = TestRunner->new($CoberturaPath, $JavaPath, $ClassPath, $Destination, $Datafile, $TestCmd);
    my $checkCoverage = CheckCoverage->new($CoberturaPath, $Branch, $Datafile, $Line, $PackageBranch, $PackageLine, $TotalBranch, $TotalLine, $CheckCommands);
    my $reportCommand = Reporting->new($CoberturaPath, $BaseDir, $Datafile, $ReportFolder, $Format, $SourceDir, $CheckCommands);
    
    #take the command lines from the objects
    $props{'InstrumentCommand'} = $instrument->GetCommandline();
    $props{'TestCommand'}       = $testRunner->GetCommandline();
    $props{'CheckCommand'}      = $checkCoverage->GetCommandline();
    $props{'ReportCommand'}     = $reportCommand->GetCommandline();
    
    $props{'WorkingDir'} = $WorkingDir;
    $utility->setProperties(\%props);
    #report registration
    registerReports($Format);
    
    
}

sub registerReports {
    my $format = shift;
    my $fileName = "index.html";
    if($format && $format ne "html"){
       $fileName = "coverage.xml";
    }
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);
    $ec->setProperty("/myJob/artifactsDirectory", '');   
    $ec->setProperty("/myJob/report-urls/@PLUGIN_KEY@ Report","jobSteps/$[jobStepId]/" . $fileName);
}

main();

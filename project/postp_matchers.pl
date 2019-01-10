push (@::gMatchers,
  {
   id =>        "reportTime",
   pattern =>          q{Report time: (.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "Report time: $1";
                              
              setProperty("summary", $description . "\n");
    
   },
  },
  {
   id =>        "instrumentTime",
   pattern =>          q{Instrument time: (.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "Instrument time: $1";
                              
              setProperty("summary", $description . "\n");                     
    
   },
  },
  {
   id =>        "projectCheckFailure",
   pattern =>          q{.*failed check.(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');

              $description .= "Check failure: $1";
              setProperty("outcome", "error" );                
              setProperty("summary", $description . "\n");    
    
   },
  },
  {
   id =>        "filesInstrumented",
   pattern =>          q{Instrumenting (\d+) file(s*)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "Files instrumented: $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
  {
   id =>        "errorDesc",
   pattern =>          q{Error:(.+)},
   action =>           q{
    
              my $description = ((defined $::gProperties{"summary"}) ? 
                    $::gProperties{"summary"} : '');
                    
              $description .= "An error occured: $1";
                              
              setProperty("summary", $description . "\n");    
    
   },
  },
  #write error
  {
    id =>      "writing-error",
    pattern =>       q{Error writing file (.*)},
    action =>        q{&addSimpleError("writing-error", "Error writing file: $1");updateSummary();},
  },
  #read error
  {
    id =>      "reading-error",
    pattern =>      q{Error reading file (.*)},
    action =>       q{&addSimpleError("reading-error", "Error reading file: $1");updateSummary();},
  },
);

sub addSimpleError {
    my ($name, $customError) = @_;
    if(!defined $::gProperties{$name}){
        setProperty($name, $customError);
    }
}

sub updateSummary() {
    my $summary = (defined $::gProperties{"writing-error"}) ? $::gProperties{"writing-error"} . "\n" : "";
    $summary .= (defined $::gProperties{"reading-error"}) ? $::gProperties{"reading-error"} . "\n" : "";
   
    setProperty("summary", $summary);
}

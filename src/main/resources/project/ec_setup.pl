my %runCobertura = (
    label       => "Cobertura - Code Analysis",
    procedure   => "runCobertura",
    description => "Runs Cobertura Code Analysis",
    category    => "Code Analysis"
);

$batch->deleteProperty("/server/ec_customEditors/pickerStep/Cobertura - Code Analysis");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Cobertura - Code Coverage");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Cobertura - runCobertura");

@::createStepPickerSteps = (\%runCobertura);

[CmdletBinding()]
param ([Parameter(ValueFromRemainingArguments)] [string[]] $Passthrough)
&cheezc ./src/main.che --out ./bin --name pathtracer1 --time @Passthrough
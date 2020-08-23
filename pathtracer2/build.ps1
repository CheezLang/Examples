[CmdletBinding()]
param ([Parameter(ValueFromRemainingArguments)] [string[]] $Passthrough)
&cheezc ./src/main.che --out ./bin --name pathtracer2 --time @Passthrough
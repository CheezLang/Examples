[CmdletBinding()]
param ([Parameter(ValueFromRemainingArguments)] [string[]] $Passthrough)
&cheezc ./src/main.che --out ./bin --name smallpaint --time @Passthrough --error-source --opt
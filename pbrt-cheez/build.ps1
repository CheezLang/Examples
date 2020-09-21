[CmdletBinding()]
param ([Parameter(ValueFromRemainingArguments)] [string[]] $Passthrough)
Copy-Item "../libraries/GLFW/glfw/lib/glfw3.dll" "./bin"
&cheezc ./src/main.che --out ./bin --name pbrt-cheez --time --error-source @Passthrough
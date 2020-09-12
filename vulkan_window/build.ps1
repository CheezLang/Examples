[CmdletBinding()]
param ([Parameter(ValueFromRemainingArguments)] [string[]] $Passthrough)
Copy-Item "../libraries/GLFW/glfw/lib/glfw3.dll" "./bin"
&cheezc ./src/main.che --out ./bin --name vulkan_window --time --error-source --modules ../libraries/vulkan/vulkan ../libraries/GLFW/glfw ../libraries/imgui/src @Passthrough
. ./config.ps1
Push-Location "./$example/bin"
# &"./$example.exe" -out image.bpm -scene ../scenes/scene.scn -log
&"./$example.exe" ../assets/meshes
# &"./$example.exe"
Pop-Location
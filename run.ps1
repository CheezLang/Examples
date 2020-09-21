. ./config.ps1
Push-Location "./$example/bin"
&"./$example.exe" -out image.bpm -scene ../scenes/scene.scn
# &"./$example.exe"
Pop-Location
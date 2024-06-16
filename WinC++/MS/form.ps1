$Label1_Click = {
}
$Button1_Click = {
}
Add-Type -AssemblyName System.Windows.Forms
. (Join-Path $PSScriptRoot 'form.designer.ps1')
$Form1.ShowDialog()
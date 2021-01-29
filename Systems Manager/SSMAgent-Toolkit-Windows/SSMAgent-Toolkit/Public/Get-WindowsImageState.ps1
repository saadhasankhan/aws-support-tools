<#
  .Synopsis
    Check the Windows Image state registry value.
  .Description
    This is a public function used to check the Windows Image state registry value configured under registry path "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State".
  .Example
    Get-WindowsImageState
  .INPUTS
    N/A
  .OUTPUTS                                                                            
    New-PSObjectResponse -Check "$check" -Status "$value" -Note "$note"
#>
Function Get-WindowsImageState {
  $check = "Windows sysprep image state complete"
  Write-Log -Message "New check....."
  Write-Log -Message "$check"
  
  $Key = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup\State" #https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-states

  Write-Log -Message "Checking Windows image state in this registry location $Key."
  Write-Log -Message "For more information check - https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-states"
  $ImageState = (Get-Item -Path $Key).GetValue("ImageState")
  If ($ImageState -eq "IMAGE_STATE_COMPLETE") {
    $value = "Pass"
    $note = "Image state is $ImageState. This is the desired state"
    Write-Log -Message "Windows image state value is IMAGE_STATE_COMPLETE. This is the desired state."
  }
  else {
    $value = "Fail"
    $note = "The state of windows Image is " + $ImageState
    Write-Log -Message "$note. The state of windows Image must be IMAGE_STATE_COMPLETE" -LogLevel "ERROR"
  }
  return New-PSObjectResponse -Check "$check" -Status "$value" -Note "$note"
}
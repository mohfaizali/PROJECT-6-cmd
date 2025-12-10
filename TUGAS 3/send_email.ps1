param(
    [string]$smtpUser,
    [string]$smtpPass,
    [string]$to,
    [string]$subject,
    [string]$body
)

$smtpServer = "smtp.gmail.com"
$smtpPort = 587

try {
    $msg = New-Object System.Net.Mail.MailMessage($smtpUser,$to,$subject,$body)
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer,$smtpPort)
    $smtp.EnableSsl = $true
    $smtp.Credentials = New-Object System.Net.NetworkCredential($smtpUser,$smtpPass)
    $smtp.Send($msg)
    Write-Output "Email berhasil dikirim ke $to"
} catch {
    Write-Output "Gagal mengirim email: $_"
}
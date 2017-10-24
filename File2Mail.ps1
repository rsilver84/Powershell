#Script para capturar novos arquivos salvos em uma pasta e enviar para caixa de e-mail do destinatário 
$Folder = 'Local da pasta origem, arquivos a ser enviado'
$DestFolder = 'Local da pasta de destino, arquivos enviados'

$EmailList = @( 'e-mail do destinatário')

$From       = 'email do remetente'
$Subject    = 'Assunto do e-mail'
$SMTPServer = 'servidor smtp'
$secpasswd = ConvertTo-SecureString "Senha" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential($From, $secpasswd)

#  Get new files
$NewFiles = $Folder | Get-ChildItem -File -Recurse
echo $NewFiles.FullName
#  If there are an new files...
If ( $NewFiles )
    {
    #  Add the file count and file names to the body of the email
    $Body = 'Corpo do e-mail'
    $NewFiles | ForEach 
    { 
		$Subject = $_.Name 
		#  Send the email with attachments
		Send-MailMessage -From $From -To $EmailList -Subject $Subject -Body $Body -BodyAsHTML -Attachments $_.FullName -SmtpServer $SMTPServer -Credential $mycreds

		#  Move the emailed files to the destination folder
		$_.FullName | Move-Item -Destination $DestFolder -Force
		}
    }
# para rodar o script no agendador = powershell.exe -noprofile -executionpolicy bypass -file c:\XML2MAIL.ps1


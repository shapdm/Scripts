Write-Host
Write-Host "Список доступных действий" -BackgroundColor White -ForegroundColor Red
Write-Host

Write-Host "1. Создать блокирующее правило" -ForegroundColor Green
Write-Host "2. Удалить блокирующее правило" -ForegroundColor Green
Write-Host "3. Завершить" -ForegroundColor Green
Write-Host

$choice = Read-Host "Выберете пункт из списка"

Switch($choice){
  1{New-NetFirewallRule -Action Block -Profile Any -DisplayName "block traffic" -RemoteAddress Internet -Direction Outbound}
  2{Remove-NetFirewallRule -DisplayName "block traffic"}
  3{Write-Host "Завершить"; exit}
    default {Write-Host "Некорректный ввод, попробуйте снова" -ForegroundColor Red}
}
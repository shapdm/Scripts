Set-ExecutionPolicy -ExecutionPolicy unrestricted

Write-Host
Write-Host "Список доступных действий" -ForegroundColor Green
Write-Host

Write-Host "1. Изменить дату для записи" -ForegroundColor Green
Write-Host "2. Изменить дату на актуальную" -ForegroundColor Green
Write-Host "3. Закрыть программу" -ForegroundColor Green
Write-Host

$choice = Read-Host "Выберете пункт из списка"

Switch($choice){
  1{
    stop-service w32time
    $date = read-host "Введите дату и время в формате ДД.ММ.ГГГГ ЧЧ:ММ" 
    Set-Date $date
  }
  2{restart-service w32time}
  3{Write-Host "Завершаем процессы, закрываем программу"; exit}
    default {Write-Host "Некорректный ввод, попробуйте снова" -ForegroundColor Red}
}

Write-Host "Проверьте результат и нажмите на любую клавишу!"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
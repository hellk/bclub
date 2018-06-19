SendMode Input
#UseHook
#NoEnv
#SingleInstance force
#IfWinActive GTA:SA:MP
#include SAMP.ahk


buildscr = 3 ;версия для сравнения, если меньше чем в verlen.ini - обновляем
downlurl := "https://github.com/hellk/bclub/blob/master/updt.exe?raw=true"
downllen := "https://github.com/hellk/bclub/raw/master/verlen.ini"

#Utf8ToAnsi1(ByRef Utf8String, CodePage = 1251)
{
    If (NumGet(Utf8String) & 0xFFFFFF) = 0xBFBBEF
        BOM = 3
    Else
        BOM = 0

    UniSize := DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "Int", 0, "Int", 0)
    VarSetCapacity(UniBuf, UniSize * 2)
    DllCall("MultiByteToWideChar", "UInt", 65001, "UInt", 0
                    , "UInt", &Utf8String + BOM, "Int", -1
                    , "UInt", &UniBuf, "Int", UniSize)

    AnsiSize := DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Int", 0, "Int", 0
                    , "Int", 0, "Int", 0)
    VarSetCapacity(AnsiString, AnsiSize)
    DllCall("WideCharToMultiByte", "UInt", CodePage, "UInt", 0
                    , "UInt", &UniBuf, "Int", -1
                    , "Str", AnsiString, "Int", AnsiSize
                    , "Int", 0, "Int", 0)
    Return AnsiString
}
WM_HELP(){
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    msgbox, , Список изменений версии %vupd%, %updupd%
    return
}

OnMessage(0x53, "WM_HELP")
Gui +OwnDialogs

SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nПроверяем наличие обновлений.
URLDownloadToFile, %downllen%, %a_temp%/verlen.ini
IniRead, buildupd, %a_temp%/verlen.ini, UPD, build
if buildupd =
{
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОшибка. Нет связи с сервером.
    sleep, 2000
}
if buildupd > % buildscr
{
    IniRead, vupd, %a_temp%/verlen.ini, UPD, v
    SplashTextOn, , 60,Автообновление, Запуск скрипта. Ожидайте..`nОбнаружено обновление до версии %vupd%!
    sleep, 2000
    IniRead, desupd, %a_temp%/verlen.ini, UPD, des
    desupd := Utf8ToAnsi(desupd)
    IniRead, updupd, %a_temp%/verlen.ini, UPD, upd
    updupd := Utf8ToAnsi(updupd)
    SplashTextoff
    msgbox, 16384, Обновление скрипта до версии %vupd%, %desupd%
    IfMsgBox OK
    {
        msgbox, 1, Обновление скрипта до версии %vupd%, Хотите ли Вы обновиться?
        IfMsgBox OK
        {
            put2 := % A_ScriptFullPath
            RegWrite, REG_SZ, HKEY_CURRENT_USER, Software\SAMP ,put2 , % put2
            SplashTextOn, , 60,Автообновление, Обновление. Ожидайте..`nОбновляем скрипт до версии %vupd%!
            URLDownloadToFile, %downlurl%, %a_temp%/updt.exe
            sleep, 1000
            run, %a_temp%/updt.exe
            exitapp
        }
    }
}
SplashTextoff


~Q::
IniRead, bclub, save.ini, sec1, key2
IniRead, klik, save.ini, sec1, key1
id := getIdByPed(getTargetPed())
if (id>-1)
goto next
else
return
next:
nickname := getPlayerNameById(id)
RegExMatch(nickname, "i)([a-z]*)_([a-z]*)", NickName)
pRpName := NickName1 ;Имя
pRpSurname := NickName2 ;Фамилия
texted :=nickname " [" id "]"
ShowDialog(2, texted, "1. {228B22}Принять в клуб`n2. {FFD700}Дать новую нашивку`n3. {DC143C}Расшить`n4. {FF69B4}Пожать руку","Ок")
Result := LineResult()
if (!Result)
return
Gosub, Label%Result%
return
Label1:
{
SendChat("/do В руке кейс с нашивками.")
sleep 2010
SendChat("/me открыл кейс")
sleep 2010
SendChat("/me достал из кейса нужную нашивку")
sleep 2010
SendInput, {F6}/do В руке нашивка Prospect | %bclub%{Enter}
sleep 2010
SendChat("/todo Держи мужик,косуха в баре*передав нашивку человеку напротив")
sleep 2010
SendInput, {F6}/binvite{Space}%id%{Enter}
sleep 2010
SendInput, {F6}/bk [%klik%] : Добро пожаловать новенький,наша косуха вторая на полке.{Enter}
sleep 2010
SendInput, {F6}/bk [%klik%] : Одевай и жди указаний,никуда не убегай.{Enter}
sleep 2010
return
}
return
Label2:
{
SendInput, {F6}/todo Подойди ближе*держа кейс с гравировкой %bclub%{Enter}
sleep 2010
SendChat("/todo И делом и словом, ты заслужил*открывая кейс с нашивками")
sleep 2010
SendChat("/do Кейс открыт.")
sleep 2010
SendChat("/todo Продолжай в том же духе*достав новую нашивку с кейса")
sleep 2010
SendInput, {F6}/me передал новую нашивку для %pRpName%{Space}%pRpSurname%{Enter}
sleep 2010
SendInput, {F6}/todo А теперь ступай,и твори новые дела во имя клуба*похлопав %pRpName%{Space}%pRpSurname% по плечу{Enter}
sleep 2010
SendInput, {F6}/bk [%klik%] : Поздравляем брата %pRpName%{Space}%pRpSurname% с получением новой нашивки.{Enter}
sleep 2010
SendInput, {F6}/brank{Space}%id%{Enter}
return
}
return
Label3:
{
SendInput, {F6}/todo Ты опозорил клуб,и подвёл меня*ударив %pRpName%{Space}%pRpSurname% по лицу{Enter}
sleep 2010
SendChat("/me резким движением руки сорвал нашивку с косухи")
sleep 2010
SendChat("/do Нашивка в руке.")
sleep 2010
SendChat("/todo Проваливай,изгой*сорвав с нашивки эмблему клуба")
sleep 2010
SendChat("/me бросил нашивку в лицо человеку")
sleep 2010
SendInput, {F6}/buninvite{Space}%id%{Space}[Расшит]. Косуха на помойке{Enter}
return
}
return
Label4:
{
  SendInput, {F6}/hi %id%{Enter}  
}
return
return
return







 ; Команды
:?:/klik::
#If WinActive("GTA:SA:MP")
sleep 200
 showDialog("1", "BclubHELP", "Введите Вашу кликуху. Если Вы Prospect, оставьте поле пустым", "Приянть", "Закрыть")
input, klik, V, {enter}
IniWrite, %klik%, save.ini, sec1, key1
return

:?:/bclub::
#If WinActive("GTA:SA:MP")
sleep 200
 showDialog("1", "BclubHELP", "Введите Ваш Байкерский Клуб.", "Приянть", "Закрыть")
input, bclub, V, {enter}
IniWrite, %bclub%, save.ini, sec1, key2
return

:?:/bkt::
#If WinActive("GTA:SA:MP")
SendMessage, 0x50,, 0x4190419,, A
IniRead, klik, save.ini, sec1, key1
SendMessage, 0x50,, 0x4190419,, A
SendInput, /bk [%klik%]{Space}:{Space}
return

:?:/bkn::
#If WinActive("GTA:SA:MP")
SendMessage, 0x50,, 0x4190419,, A
SendInput, /bk ((  )){Left}{Left}{Left}
return

:?:/hei::
#If WinActive("GTA:SA:MP")
SendMessage, 0x50,, 0x4190419,, A
Send, /bk %klik% Хой, мужики!{Enter}
return

:?:/time::
IniRead, bclub, save.ini, sec1, key2
#If WinActive("GTA:SA:MP")
sleep 20
FormatTime, nowtime,, LongDate
a := 59 - A_Min
b := 60 - A_Sec
SendMessage, 0x50,, 0x4190419,, A
sleep 200
SendInput, {F6}/todo Дата: %nowtime%, Время: %A_Hour%:%A_Min%:%A_Sec%, до зарплаты %a% минут %b% секунд *взглянув на часы с гравировкой %bclub% MC.{Enter}
sleep 200
SendInput, {F6}/time{Enter}
return

:?:/sazs:: ; Начало
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/me нагнувшись, открыл канистру, после чего достал из под косухи нож{enter}
sleep, 3000
SendInput, {F6}/do Канистра открыта. {enter}
sleep, 3000
SendInput, {F6}/do Нож в правой руке.{enter}
sleep, 3000
SendInput, {F6}/me разрезал ножом шланг, после чего засунул его в канистру{enter}
sleep, 3000
SendInput, {F6}/me надавил на шланг{enter}
sleep, 3000
SendInput, {F6}/do Бензин сливается в канистру.{enter}
sleep, 3000
SendInput, {F6}/me придерживает левой рукой канистру.{enter}
sleep, 13000
SendInput, {F6}/do Бензин продолжает сливаться в канистру.{enter}
return


:?:/pazs:: ; Конец
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/do Канистра полна бензином.{enter}
sleep, 3000
SendInput, {F6}/me вытащил шланг из канистры, после чего закрыл её{enter}
sleep, 3000
SendInput, {F6}/do Канистра закрыта.{enter}
sleep, 3000
SendInput, {F6}/me взял в обе руки канистру, после чего привязал её к байку{enter}
sleep, 3000
SendInput, {F6}/do Канистра наполненная бензином привязана к байку.{enter}
SendInput, {F6}/me отвязал канистру от байка{enter}
sleep, 3000
SendInput, {F6}/do Канистра наполненная бензином в руках.{enter}
sleep, 3000
SendInput, {F6}/me закинул канистру наполненную бензином на склад.{enter}
return

:?:/spour:: ; Слив бензина
SendMessage, 0x50,, 0x4190419,, A
SendInput, /me открыв бак, вынул крышку из него{Enter}
sleep 2010
SendInput, /me поставил канистру на землю{Enter}
sleep 2010
SendInput, /me достав шланг, вставил один конец в бак, затем нажал на грушу{Enter}
sleep 2010
SendInput, /do Топливо течет в канистру.{Enter}
sleep 2010
SendInput, /do Канистра заполнена.{Enter}
return

:?:/bm::
IniRead, klik, save.ini, sec1, key1
showGameText("~y~Bclub HELP ~g~v0.2", "3000", "4")
showDialog("2", "Меню - Bclub HELP", "Автор`nОтыгровки`nКоманды`nГорячие клавиши`n{FFFF00}Хой, мужик", "Далее", , 14)
Result := LineResult()
if (!Result)
return
Gosub, bmd%Result%
return
bmd1:
{
    showGameText("~y~Oddy ~r~hellk", "3000", "1")
showDialog("0", "Автор", "{3CB371}Автор {808080}- {40E0D0}Oddy ({A52A2A}hellk{40E0D0})`n{FFFF00}Пожертвования: `n{FFA500}Amber {808080}- {EEE8AA}39823 ({9370DB}Деньги{EEE8AA})`n{FF0000}Onyx {808080}- {EEE8AA}165910 ({9370DB}1980{EEE8AA})`n{6495ED}vk.com/idhellk", "Доначу")
}
return
bmd2:
{
showDialog("2", "Отыгровки", "Слив бензина с т/с`nОграбление АЗС`nИгра в бильярд`n", "Отыграть", "Отмена")
Result := LineResult()
if (!Result)
return
Gosub, brp%Result%
return
brp1:
{
SendInput, {F6}/pour{Enter}{Esc}
sleep 100
SendInput, {F6}/me открыв бак, вынул крышку из него{Enter}
sleep 2010
SendInput, {F6}/me поставил канистру на землю{Enter}
sleep 2010
SendInput, {F6}/me достав шланг, вставил один конец в бак, затем нажал на грушу{Enter}
sleep 2010
SendInput, {F6}/do Топливо течет в канистру.{Enter}
sleep 2010
SendInput, {F6}/do Канистра заполнена.{Enter} 
return
}
return
brp2:
{
SendMessage, 0x50,, 0x4190419,, A
SendInput, {F6}/me нагнувшись, открыл канистру, после чего достал из под косухи нож{enter}
sleep 3000
SendInput, {F6}/do Канистра открыта. {enter}
sleep 3000
SendInput, {F6}/do Нож в правой руке.{enter}
sleep 3000
SendInput, {F6}/me разрезал ножом шланг, после чего засунул его в канистру{enter}
sleep 3000
SendInput, {F6}/me надавил на шланг{enter}
sleep 3000
SendInput, {F6}/do Бензин сливается в канистру.{enter}
sleep 3000
SendInput, {F6}/me придерживает левой рукой канистру.{enter}
sleep 13000
SendInput, {F6}/do Бензин продолжает сливаться в канистру.{enter}
Sleep 120000
SendInput, {F6}/do Канистра полна бензином.{enter}
sleep, 3000
SendInput, {F6}/me вытащил шланг из канистры, после чего закрыл её{enter}
sleep, 3000
SendInput, {F6}/do Канистра закрыта.{enter}
sleep, 3000
SendInput, {F6}/me взял в обе руки канистру, после чего привязал её к байку{enter}
sleep, 3000
SendInput, {F6}/do Канистра наполненная бензином привязана к байку.{enter}
}
return
brp3:
{
    SendMessage, 0x50,, 0x4190419,, A
  SendInput,{F6}/me взял со стола кий{Enter}{Esc}
  sleep 2010
  SendInput,{F6}/do Кий в руках.{Enter}
  sleep 2010
  SendInput,{F6}/me подошел к краю бильярдного стола{Enter}
  sleep 2010
  SendInput,{F6}/me нагнулся к бильярдному столу{Enter}
  sleep 2010
  SendInput,{F6}/me отодвинул правый локоть чуть назад{Enter}
  sleep 2010
  SendInput,{F6}/me прицелившись, нанёс удар по белому шару{Enter}
  sleep 2010
  SendInput,{F6}/do Шары разлетелись в разные стороны.{Enter}
  sleep 2010
  SendInput,{F6}/try один из шаров попал в лунку{Enter}
  return
}
return
}
return
bmd3:
{
  comm1 := "{7FFFD4}Команды:"
   comm2 := "{B0C4DE}/bkn {808080}- {B8860B}НонРП чат"
   comm3 := "{B0C4DE}/hello {808080}- {B8860B}Поприветствовать мужиков"
   comm4 := "{B0C4DE}/spour {808080}- {B8860B}Слив Бензина с Т/С"
   comm5 := "{B0C4DE}/sazs {808080}- {B8860B}Ограбление АЗС"
   comm6 := "{B0C4DE}/pazs {808080}- {B8860B}Окончить оргабление АЗС"
   comm7 := "{B0C4DE}/pbill {808080}- {B8860B}Играть в бильярд"
   comm8 := "{B0C4DE}/klik {808080}- {B8860B}Ввести кликуху"
   comm9 := "{B0C4DE}/bclub {808080}- {B8860B}Ввести свой байкерский клуб"
   comm10 := "{B0C4DE}/time {808080}- {B8860B}Проверить время и посмотреть время до зарплаты"
     line := getDialogLine(getDialogIndex())
   AddChatMessage(comm1)
   AddChatMessage(comm2)
   AddChatMessage(comm3)
   AddChatMessage(comm4)
   AddChatMessage(comm5)
   AddChatMessage(comm6)
   AddChatMessage(comm7)
   AddChatMessage(comm8)
   AddChatMessage(comm9)
   AddChatMessage(comm10)
}
return
bmd4:
{
 showdialog("0", "Горячие клавиши", "{FFFF00}ПКМ+Q - {FFFFFF}Взаимодействие с персонажем`n", "Закрыть")   
}
return
bmd5:
{
 AddChatMessage("{FFFF00}Хой, " klik ", не забудь поздороваться с мужиками")
 return
}
return
return
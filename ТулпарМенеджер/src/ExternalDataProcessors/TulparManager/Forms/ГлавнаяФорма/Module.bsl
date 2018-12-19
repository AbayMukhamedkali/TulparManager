#Область ВспомогательныеПроцедурыИФункции
Функция ЗаполнитьСписокТиповОтображаемыхДанных()
	
	СЗ = Новый СписокЗначений;
	МассивРеквизитовФормы = ПолучитьРеквизиты();
	Для Каждого Стр Из МассивРеквизитовФормы Цикл 
		СЗ.Добавить(Стр.Имя);
	КонецЦикла;
	
	//Добавляем служебные типы
	СЗ.Добавить("Документы");
	Возврат СЗ;
	
КонецФункции

Функция СформироватьКоманду(КомОбъекты,СтруктураПараметров)
	
	Команда = КомОбъекты.SelectScripts[СтруктураПараметров.ТипДанных];
	Если СтруктураПараметров.ПараметрыКоманды.Количество() > 0 Тогда 
		Команда = УстановитьПараметрыКоманды(Команда,СтруктураПараметров.ПараметрыКоманды);
	КонецЕсли;
	
	Возврат Команда;
	
КонецФункции

Функция УстановитьПараметрыКоманды(Команда,СтруктураПараметровКоманды)
	
	Для Каждого Элем Из СтруктураПараметровКоманды Цикл 
		
		Команда = СтрЗаменить(Команда,Элем.Ключ,Элем.Значение);
		
	КонецЦикла;
	
	Возврат Команда;
	
КонецФункции

Функция СформироватьДанныеКоманды(ТипДанных, ПараметрыКоманды = Неопределено)
	
	ДанныеКоманды = Новый Структура;
	
	Если ПараметрыКоманды = Неопределено Тогда 
		ПараметрыКоманды = Новый Структура;
	КонецЕсли;
	
	ДанныеКоманды.Вставить("ПараметрыКоманды",ПараметрыКоманды);
	ДанныеКоманды.Вставить("ТипДанных",ТипДанных);
	
	Возврат ДанныеКоманды;
	
КонецФункции

Функция УбратьЛишниеСимволы(ИсходнаяСтрока);
	
	Стр = СтрЗаменить(Строка(ИсходнаяСтрока),символ(160),"");
	Возврат СтрЗаменить(Стр," ","");
	
КонецФункции

#КонецОбласти

#Область БлокПолученияИОтображенияДанных
Функция ПолучитьДанные(ТекстКоманды,КомОбъекты)
	
	Попытка
		ОткрытьПодключение(КомОбъекты);
		КомОбъекты.Команда.ActiveConnection = КомОбъекты.Соединение;    
		КомОбъекты.Команда.CommandText = ТекстКоманды;
		КомОбъекты.НаборЗаписей = КомОбъекты.Команда.Execute();
		Результат = ПоместитьРезультатCOMЗапросаВТаблицуЗначений(КомОбъекты);
		ЗакрытьПодключение(КомОбъекты);
		Возврат Результат;
	Исключение  
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Процедура ОтобразитьДанные(СтруктураПараметров,ТипСобытия = "")
	
	Если ТипСобытия = "АктивизацияСтроки" Тогда
	Иначе
		Если ДанныеЕсть(СтруктураПараметров.ТипДанных) Тогда 
			Возврат;
		КонецЕсли;
	КонецЕсли;	
		
	КомОбъекты = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);

	Если КомОбъекты = Неопределено Тогда 
		СоздатьSQLПодключение();
		КомОбъекты = ПолучитьИзВременногоХранилища(АдресВременногоХранилища);
	КонецЕсли;
	
	Если Не (ТипыОтображаемыхДанных.НайтиПоЗначению(СтруктураПараметров.ТипДанных) = Неопределено) Тогда
		ОтобразитьТекущиеДанные(СтруктураПараметров,КомОбъекты);		
	КонецЕсли;
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(КомОбъекты);
	
КонецПроцедуры

Процедура ОтобразитьТекущиеДанные(СтруктураПараметров,КомОбъекты)
	
	ТипДанных = СтруктураПараметров.ТипДанных;
	Команда = СформироватьКоманду(КомОбъекты,СтруктураПараметров);
	Данные = ПолучитьДанные(Команда,КомОбъекты);
	Если Данные = Неопределено Тогда 
		Возврат;
	Иначе 
		ЭтаФорма[ТипДанных].Загрузить(Данные);
	КонецЕсли;	
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Процедура пмСообщить(Текст)
	Сообщить(""+ТекущаяДата()+": "+Текст);
КонецПроцедуры

Функция ДанныеЕсть(ТипДанных)
	
	Если ЭтаФорма[ТипДанных].Количество() = 0 Тогда 
		Возврат Ложь;
	Иначе 
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

Функция ПоместитьРезультатCOMЗапросаВТаблицуЗначений(КомОбъекты) Экспорт
	
	ТЗ = Новый ТаблицаЗначений;
	//Определяем типы колонок по наименованию. В строковых есть ключевое слово СТРОКА, в числовых ЧИСЛО.
	КоличествоКолонок =	КомОбъекты.НаборЗаписей.Fields.Count;
	Для НомерКолонки = 0 по КоличествоКолонок - 1 Цикл
		ИмяКолонки = КомОбъекты.НаборЗаписей.Fields.Item(НомерКолонки).Name;
		ТипКолонки = ОпределитьТипКолонкиПоИмени(ИмяКолонки);
		Если ТипКолонки = Неопределено Тогда
			//пмСообщить("Тип колонки с именем:" +Колонка.Имя + " не определен. Проверьте имя колонки в COM запросе.");
		Иначе 
			ТЗ.Колонки.Добавить(ИмяКолонки,ТипКолонки);
		КонецЕсли;
	КонецЦикла;
	
	Пока Не КомОбъекты.НаборЗаписей.EOF Цикл
		НовСтрока = ТЗ.Добавить();
		Для НомерКолонки = 0 по КоличествоКолонок - 1 Цикл
			ИмяКолонки = КомОбъекты.НаборЗаписей.Fields.Item(НомерКолонки).Name;
			НовСтрока[ИмяКолонки] = УбратьЛишниеСимволы(КомОбъекты.НаборЗаписей.Fields(ИмяКолонки).Value);
		КонецЦикла;
		КомОбъекты.НаборЗаписей.MoveNext();
	КонецЦикла;
	
	Возврат ТЗ;
	
КонецФункции

&НаСервере
Функция ОпределитьТипКолонкиПоИмени(ИмяКолонки)
	
	КЧ = Новый КвалификаторыЧисла(12,2);
	КС = Новый КвалификаторыСтроки(300);
	
	//Определяем тип колонки по имени.
	Если Найти(ИмяКолонки,"Число") Тогда
		ТипКолонки = Новый ОписаниеТипов("Число")
	ИначеЕсли Найти(ИмяКолонки,"Строка") Тогда
		ТипКолонки = Новый ОписаниеТипов("Строка", КС)
	ИначеЕсли Найти(ИмяКолонки,"Дата") Тогда
		ТипКолонки = Новый ОписаниеТипов("Дата")
	ИначеЕсли Найти(ИмяКолонки,"ТипОбъект") Тогда
		ТипКолонки = Новый ОписаниеТипов("Строка", КС)
	Иначе
		пмСообщить("Не определен тип колонки.");
		ТипКолонки = Неопределено;
	КонецЕсли;
	
	Возврат ТипКолонки;
	
КонецФункции
#КонецОбласти

#Область ПодключениеОткрытиеЗакрытиеСоединения

Процедура СоздатьSQLПодключение()
	
	МодульОбработки = РеквизитФормыВЗначение("Объект");
	SelectScripts = МодульОбработки.СформироватьСписокКоманд(ПериодОтбора);
	
	СтрокаСоединения32 = "Driver={PostgreSQL Unicode};Server=Tulpar;Port=5432;Database=tulpardb;Uid=postgres;Pwd=20Htdhtc15;STMT=utf8";  //32
	СтрокаСоединения64 = "Driver={PostgreSQL Unicode(x64)};Server=Tulpar;Port=5432;Database=tulpardb;Uid=postgres;Pwd=20Htdhtc15;STMT=utf8";    //64
	CommandTimeout = 30000;

	Соединение 		= Новый COMОбъект("ADODB.Connection");
	Соединение.Provider = "MSDASQL.1";
	
	Команда 		= Новый COMОбъект("ADODB.Command");   
	НаборЗаписей 	= Новый COMОбъект("ADODB.RecordSet");
	
	КомОбъекты = Новый Структура;
	КомОбъекты.Вставить("SelectScripts",SelectScripts);
	КомОбъекты.Вставить("СтрокаСоединения32",СтрокаСоединения32);
	КомОбъекты.Вставить("СтрокаСоединения64",СтрокаСоединения64);
	КомОбъекты.Вставить("CommandTimeout",CommandTimeout);
	КомОбъекты.Вставить("Команда",Команда);
	КомОбъекты.Вставить("НаборЗаписей",НаборЗаписей);
	КомОбъекты.Вставить("Соединение",Соединение);
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(КомОбъекты);
	
КонецПроцедуры  

Процедура ОткрытьПодключение(КомОбъекты) Экспорт
 
	Попытка
        КомОбъекты.Соединение.Open(КомОбъекты.СтрокаСоединения32);
	Исключение
		Попытка
			КомОбъекты.Соединение.Open(КомОбъекты.СтрокаСоединения64);
		Исключение
        	Сообщить(ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
		КонецПопытки;
	КонецПопытки;
 
КонецПроцедуры
 
Процедура ЗакрытьПодключение(КомОбъекты) Экспорт
 
	Попытка
		Если КомОбъекты.Соединение <> Неопределено Тогда 
			КомОбъекты.Соединение.Close();
		КонецЕсли;
	Исключение
        Сообщить(ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
	КонецПопытки;
 
КонецПроцедуры

#КонецОбласти

#Область КамандыФормы
&НаСервере
Процедура ОбновитьДанныеНаСервере()
	
	ИмяСтраницы = Элементы.Страницы.ТекущаяСтраница.Имя;
	Если ИмяСтраницы = "Документы" Тогда
		ИмяСтраницы = Элементы.ВидыДокументов.ТекущаяСтраница.Имя;
		ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы);
		ОтобразитьДанные(ДанныеКоманды);	
	ИначеЕсли ИмяСтраницы = "Справочники" Тогда
		ИмяСтраницы = Элементы.СтраницыСправочников.ТекущаяСтраница.Имя;
		ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы);
		ОтобразитьДанные(ДанныеКоманды);
	ИначеЕсли ИмяСтраницы = "МониторОбмена" Тогда
		ДанныеКоманды = СформироватьДанныеКоманды("ТорговыеПредставители");
		ОтобразитьДанные(ДанныеКоманды);	
	Иначе
		ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы);
		ОтобразитьДанные(ДанныеКоманды);	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	ОбновитьДанныеНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриОткрытииНаСервере()
	
	ПериодОтбора.Вариант = ВариантСтандартногоПериода.Сегодня;
	
	СоздатьSQLПодключение();
	ТипыОтображаемыхДанных = ЗаполнитьСписокТиповОтображаемыхДанных();
	
	ДанныеКоманды = СформироватьДанныеКоманды("ТорговыеПредставители");
	ОтобразитьДанные(ДанныеКоманды);
		
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриОткрытииНаСервере();

КонецПроцедуры

#Область СменыСтраниц
&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	СтраницыПриСменеСтраницыНаСервере(ТекущаяСтраница.Имя);

КонецПроцедуры

&НаСервере
Процедура СтраницыПриСменеСтраницыНаСервере(ИмяСтраницы)
	
	Если ИмяСтраницы = "Документы" Тогда 
		ДанныеКоманды = СформироватьДанныеКоманды("Заказы");
		ОтобразитьДанные(ДанныеКоманды);	
	ИначеЕсли ИмяСтраницы = "Справочники" Тогда
		ДанныеКоманды = СформироватьДанныеКоманды("Товары");
		ОтобразитьДанные(ДанныеКоманды);
	ИначеЕсли ИмяСтраницы = "МониторОбмена" Тогда
		ДанныеКоманды = СформироватьДанныеКоманды("ТорговыеПредставители");
		ОтобразитьДанные(ДанныеКоманды);	
	Иначе
		ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы);
		ОтобразитьДанные(ДанныеКоманды);	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВидыДокументовПриСменеСтраницыНаСервере(ИмяСтраницы)
	
	ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы);
	ОтобразитьДанные(ДанныеКоманды);	
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДокументовПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ВидыДокументовПриСменеСтраницыНаСервере(ТекущаяСтраница.Имя);
КонецПроцедуры

&НаСервере
Процедура СтраницыСправочниковПриСменеСтраницыНаСервере(ИмяСтраницы)
	
	ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы);
	ОтобразитьДанные(ДанныеКоманды);	
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыСправочниковПриСменеСтраницы(Элемент, ТекущаяСтраница)
	СтраницыСправочниковПриСменеСтраницыНаСервере(ТекущаяСтраница.Имя);
КонецПроцедуры

#КонецОбласти

#Область АктивизацияСтрок

&НаСервере
Процедура ТорговыеПредставителиПриАктивизацииСтрокиНаСервере(salerepid)
	
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("ParamSalerepid",salerepid);
	ДанныеКоманды = СформироватьДанныеКоманды("ЛогиВыгрузкиЗагрузки",ПараметрыКоманды);
	
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
КонецПроцедуры	
	
&НаКлиенте
Процедура ТорговыеПредставителиПриАктивизацииСтроки(Элемент)
	
	ТорговыеПредставителиПриАктивизацииСтрокиНаСервере(Элемент.ТекущиеДанные.salerepidСтрока);
	
КонецПроцедуры

&НаСервере
Процедура Партнеры1ПриАктивизацииСтрокиНаСервере(ИДСтрока)
	
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("ParamСustomerid",ИДСтрока);
	ДанныеКоманды = СформироватьДанныеКоманды("Соглашение",ПараметрыКоманды);
	
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
КонецПроцедуры

&НаКлиенте
Процедура Партнеры1ПриАктивизацииСтроки(Элемент)
	
	Партнеры1ПриАктивизацииСтрокиНаСервере(Элемент.ТекущиеДанные.ИДСтрока);
	
КонецПроцедуры

&НаСервере
Процедура НоменклатураПриАктивизацииСтрокиНаСервере(ИДСтрока)
	
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ParamProduct",ИДСтрока);
	
	ДанныеКоманды = СформироватьДанныеКоманды("Цены",ПараметрыКоманды);	
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
	ДанныеКоманды = СформироватьДанныеКоманды("Остатки",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");	

КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриАктивизацииСтроки(Элемент)
	НоменклатураПриАктивизацииСтрокиНаСервере(Элемент.ТекущиеДанные.ИДСтрока);
КонецПроцедуры

&НаСервере
Процедура Заказы1ПриАктивизацииСтрокиНаСервере(ИДСтрока)
	
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("paramDocumentID",ИДСтрока);
	
	ДанныеКоманды = СформироватьДанныеКоманды("ДеталиДокумента",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");

	ДанныеКоманды = СформироватьДанныеКоманды("СкидкиДокумента",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
	ДанныеКоманды = СформироватьДанныеКоманды("ПромоДокумента",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
КонецПроцедуры

&НаКлиенте
Процедура Заказы1ПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Заказы1ПриАктивизацииСтрокиНаСервере(Элемент.ТекущиеДанные.ИДСтрока);
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура Накладные1ПриАктивизацииСтрокиНаСервере(ИДСтрока)
	
	ПараметрыКоманды = Новый Структура;
	
	ПараметрыКоманды.Вставить("paramDocumentID",ИДСтрока);
	
	ДанныеКоманды = СформироватьДанныеКоманды("ДеталиДокумента",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");

	ДанныеКоманды = СформироватьДанныеКоманды("СкидкиДокумента",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
	ДанныеКоманды = СформироватьДанныеКоманды("ПромоДокумента",ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды,"АктивизацияСтроки");
	
КонецПроцедуры

&НаКлиенте
Процедура Накладные1ПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда 
		Накладные1ПриАктивизацииСтрокиНаСервере(Элемент.ТекущиеДанные.ИДСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ПериодОтбораПриИзмененииНаСервере()
	
	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ParamDate1",ПериодОтбора.ДатаНачала);
	ПараметрыКоманды.Вставить("ParamDate2",ПериодОтбора.ДатаОкончания);
	
	ИмяСтраницы = Элементы.ВидыДокументов.ТекущаяСтраница.Имя;
	
	ДанныеКоманды = СформироватьДанныеКоманды(ИмяСтраницы,ПараметрыКоманды);
	ОтобразитьДанные(ДанныеКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодОтбораПриИзменении(Элемент)
	ПериодОтбораПриИзмененииНаСервере();
КонецПроцедуры


#КонецОбласти




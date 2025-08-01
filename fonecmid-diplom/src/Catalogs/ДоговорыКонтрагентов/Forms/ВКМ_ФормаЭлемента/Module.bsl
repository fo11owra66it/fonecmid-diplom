#Область ОбработчикиСобытийФормы

&НаСервере
	Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// +++ ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	ДобавитьГруппаЭлементовАбонентскоеОбслуживание();
	// --- ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
КонецПроцедуры

&НаКлиенте
	Процедура ПриОткрытии(Отказ)
	// +++ ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	ВидимостьДополнительныхРеквизитов();
	// --- ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы
&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	// +++ ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	ВидимостьДополнительныхРеквизитов();
	// --- ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
КонецПроцедуры
#КонецОбласти



#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьГруппаЭлементовАбонентскоеОбслуживание()
	
	// +++ ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	
	//Создаем группу формы
	ГруппаАбонентскоеОбслуживание = Элементы.Добавить("ГруппаАбонентскоеОбслуживание", Тип("ГруппаФормы"), ЭтотОбъект);
	ГруппаАбонентскоеОбслуживание.Вид				  = ВидГруппыФормы.ОбычнаяГруппа;
	ГруппаАбонентскоеОбслуживание.ОтображатьЗаголовок = Ложь;
	ГруппаАбонентскоеОбслуживание.Группировка		  = ГруппировкаПодчиненныхЭлементовФормы.Вертикальная;
	
	// Создаем элементы формы ДатаНачала
	ПолеДатаНачала = Элементы.Добавить("ВКМ_ДатаНачала", Тип("ПолеФормы"), ГруппаАбонентскоеОбслуживание);
	ПолеДатаНачала.Вид					= ВидПоляФормы.ПолеВвода;
	ПолеДатаНачала.ПутьКДанным			= "Объект.ВКМ_ДатаНачала";
	
	// Создаем элементы формы ДатаОкончания
	ПолеДатаОкончания = Элементы.Добавить("ВКМ_ДатаОкончания", Тип("ПолеФормы"), ГруппаАбонентскоеОбслуживание);
	ПолеДатаОкончания.Вид				 = ВидПоляФормы.ПолеВвода;
	ПолеДатаОкончания.ПутьКДанным		 = "Объект.ВКМ_ДатаОкончания";
	
	// Создаем элементы формы ПолеСуммаАбонентскойПлаты
	ПолеСуммаАбонентскойПлаты = Элементы.Добавить("ВКМ_СуммаАбонентскойПлаты", Тип("ПолеФормы"), ГруппаАбонентскоеОбслуживание);
	ПолеСуммаАбонентскойПлаты.Вид		 = ВидПоляФормы.ПолеВвода;
	ПолеСуммаАбонентскойПлаты.ПутьКДанным = "Объект.ВКМ_СуммаАбонентскойПлаты";
	
	// Создаем элементы формы СтоимостьЧаса
	ПолеСтоимостьЧаса = Элементы.Добавить("ВКМ_СтимостьЧаса", Тип("ПолеФормы"), ГруппаАбонентскоеОбслуживание);
	ПолеСтоимостьЧаса.Вид				 = ВидПоляФормы.ПолеВвода;
	ПолеСтоимостьЧаса.ПутьКДанным		 = "Объект.ВКМ_СтимостьЧаса";
	// --- ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	
КонецПроцедуры

&НаСервере
Процедура ВидимостьДополнительныхРеквизитов()
	
	// +++ ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.ВКМ_АбоненскоеОбслуживание") Тогда
		Элементы.ГруппаАбонентскоеОбслуживание.Видимость = Истина;
	Иначе
		Элементы.ГруппаАбонентскоеОбслуживание.Видимость = Ложь;
	КонецЕсли;
	// --- ВКМ Телицин С.Л. (Договоры на абонентское обслуживание)
	
КонецПроцедуры

#КонецОбласти
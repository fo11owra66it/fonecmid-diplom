
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)

	Движения.ОбработкаЗаказов.Записывать = Истина;
	Движения.ОстаткиТоваров.Записывать = Истина;
	
	Движение = Движения.ОбработкаЗаказов.Добавить();
	Движение.Период = Дата;
	Движение.Контрагент = Контрагент;
	Движение.Договор = Договор;
	Движение.Заказ = Основание;
	Движение.СуммаОтгрузки = СуммаДокумента;

	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ОстаткиТоваров.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Контрагент = Контрагент;
		Движение.Номенклатура = ТекСтрокаТовары.Номенклатура;
		Движение.Сумма = ТекСтрокаТовары.Сумма;
		Движение.Количество = ТекСтрокаТовары.Количество;
	КонецЦикла;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		ЗаполнитьНаОснованииЗаказаПокупателя(ДанныеЗаполнения);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииЗаказаПокупателя(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаказПокупателя.Организация КАК Организация,
	               |	ЗаказПокупателя.Контрагент КАК Контрагент,
	               |	ЗаказПокупателя.Договор КАК Договор,
	               |	ЗаказПокупателя.СуммаДокумента КАК СуммаДокумента,
	               |	ЗаказПокупателя.Товары.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Товары,
	               |	ЗаказПокупателя.Услуги.(
	               |		Ссылка КАК Ссылка,
	               |		НомерСтроки КАК НомерСтроки,
	               |		Номенклатура КАК Номенклатура,
	               |		Количество КАК Количество,
	               |		Цена КАК Цена,
	               |		Сумма КАК Сумма
	               |	) КАК Услуги
	               |ИЗ
	               |	Документ.ЗаказПокупателя КАК ЗаказПокупателя
	               |ГДЕ
	               |	ЗаказПокупателя.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	
	ТоварыОснования = Выборка.Товары.Выбрать();
	Пока ТоварыОснования.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), ТоварыОснования);
	КонецЦикла;
	
	УслугиОснования = Выборка.Услуги.Выбрать();
	Пока ТоварыОснования.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Услуги.Добавить(), УслугиОснования);
	КонецЦикла;
	
	Основание = ДанныеЗаполнения;
	
КонецПроцедуры

// +++ ВКМ Телицин С.Л. (Заполнение Реализации товаров и услуг)
Процедура ВКМ_ВыполнитьАвтозаполнение() Экспорт
	НоменклатураАбонентскаяПлата =Константы.ВКМ_НоменклатураАбонентскаяПлата.Получить();
	НоменклатураРаботыСпециалиста = Константы.ВКМ_НоменклатураРаботыСпециалиста.Получить();
	ЗавершениеПроцедуры = Ложь;
	
	Если НЕ ЗначениеЗаполнено(НоменклатураАбонентскаяПлата) Тогда
		ОбщегоНазначения.СообщитьПользователю("Не заполнена константа ""Номенклатура абонентская плата""");
		ЗавершениеПроцедуры = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(НоменклатураРаботыСпециалиста) Тогда
		ОбщегоНазначения.СообщитьПользователю("Не заполнена константа ""Номенклатура работы специалистов""");
		ЗавершениеПроцедуры = Истина;
	КонецЕсли;
	
	Если ЗавершениеПроцедуры Тогда
		Возврат;
	КонецЕсли;
	
	Услуги.Очистить();
	
	АбонентскаяПлата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор, "ВКМ_СуммаАбонентскойПлаты");
	
	СтрокаУслуга = Услуги.Добавить();
	СтрокаУслуга.Номенклатура = НоменклатураАбонентскаяПлата;
	СтрокаУслуга.Цена = АбонентскаяПлата;
	СтрокаУслуга.Количество = 1;
	СтрокаУслуга.Сумма = СтрокаУслуга.Количество * СтрокаУслуга.Цена;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЕСТЬNULL(ВКМ_ВыполненныеКлиентуРаботыОбороты.КоличествоЧасовОборот, 0) КАК КоличествоЧасов,
	|	ЕСТЬNULL(ВКМ_ВыполненныеКлиентуРаботыОбороты.СуммаКОплатеОборот, 0) КАК СуммаКОплате
	|ИЗ
	|	РегистрНакопления.ВКМ_ВыполненныеКлиентуРаботы.Обороты(&НачалоПериода, &КонецПериода, Месяц, Договор = &Договор) КАК
	|		ВКМ_ВыполненныеКлиентуРаботыОбороты";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Дата)); 
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаУслуга = Услуги.Добавить();
		СтрокаУслуга.Номенклатура = НоменклатураРаботыСпециалиста;
		СтрокаУслуга.Количество = Выборка.КоличествоЧасов;
		СтрокаУслуга.Сумма = Выборка.СуммаКОплате;
		СтрокаУслуга.Цена = Выборка.СуммаКОплате/Выборка.КоличествоЧасов; 
	КонецЦикла;
	
	СуммаДокумента = Товары.Итог("Сумма") + Услуги.Итог("Сумма");
КонецПроцедуры
// --- ВКМ Телицин С.Л. (Заполнение Реализации товаров и услуг)

#КонецОбласти

#КонецЕсли

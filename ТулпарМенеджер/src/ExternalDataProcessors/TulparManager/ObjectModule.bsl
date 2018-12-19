Функция СформироватьСписокКоманд(ПериодОтбора) Экспорт
	
	SelectScripts = Новый Структура;
	#Область _______ТекстЗапроса
	SelectScript = "	SELECT sd.name ПодразделениеСтрока, sr.name НомерТПСтрока, sr.salerepid salerepidСтрока, srt.name ТипТПСтрока, sr.person ФизЛицоСтрока  
						|FROM 	t_salereps sr 
						|join t_subdivision sd 
						|	on sr.subdivisionid = sd.subdivisionid
						|join t_salereptypes srt 
						|	on sr.salereptypeid = srt.salereptypeid
						|where 
						|	srt.name not in ('Супервайзер','Директор')";
	#КонецОбласти
	SelectScripts.Вставить("ТорговыеПредставители",SelectScript);
	
	#Область _______ТекстЗапроса
	SelectScript = "	SELECT log_date Дата, log_info ИнфоСтрока  
						|FROM 	t_logs_processing 
						|where 
						|	salerepid = ParamSalerepid";
	#КонецОбласти	
	SelectScripts.Вставить("ЛогиВыгрузкиЗагрузки",SelectScript);
	
	#Область _______ТекстЗапроса
	SelectScript = "	select 
						|d.documentid ИДСтрока, d.date Дата, d.number НомерСтрока, c.name КлиентСтрока, 
						|sr.name ТПСтрока, pt.name СоглашениеСтрока, s.name СкладСтрока, 
						|sd.name ПодразделениеСтрока, d.total СуммаЧисло, d.totaldiscount СуммаСкидкиЧисло, 
						|d.totalvat СуммаНДСЧисло, d.stateid СтатусЗагрузкиЧисло  
						|from t_documents d
						|join t_customers c 
						|	on d.customerid = c.customerid
						|join t_salereps sr
						|	on d.salerepid = sr.salerepid
						|join t_paymentterms pt
						|	on d.paymenttermid = pt.paymenttermid
						|join t_stocks s
						|	on d.stockid = s.stockid
						|join t_subdivision sd
						|	on d.subdivisionid = sd.subdivisionid		
						|where 
						|	date BETWEEN ParamDate1 AND ParamDate2
						|	and issale = false
						|	order by d.date";
	#КонецОбласти
	SelectScript = СтрЗаменить(SelectScript,"ParamDate1", ПреобразоватьДатуВПараметр(ПериодОтбора.ДатаНачала));
	SelectScript = СтрЗаменить(SelectScript,"ParamDate2",ПреобразоватьДатуВПараметр(ПериодОтбора.ДатаОкончания));
	SelectScripts.Вставить("Заказы",SelectScript);
	
	#Область _______ТекстЗапроса
	SelectScript = "	select 
						|d.documentid ИДСтрока, d.date Дата, d.number НомерСтрока, c.name КлиентСтрока, 
						|sr.name ТПСтрока, pt.name СоглашениеСтрока, s.name СкладСтрока, 
						|sd.name ПодразделениеСтрока, d.total СуммаЧисло, d.totaldiscount СуммаСкидкиЧисло, 
						|d.totalvat СуммаНДСЧисло, d.stateid СтатусЗагрузкиЧисло  
						|from t_documents d
						|join t_customers c 
						|	on d.customerid = c.customerid
						|join t_salereps sr
						|	on d.salerepid = sr.salerepid
						|join t_paymentterms pt
						|	on d.paymenttermid = pt.paymenttermid
						|join t_stocks s
						|	on d.stockid = s.stockid
						|join t_subdivision sd
						|	on d.subdivisionid = sd.subdivisionid		
						|where 
						|	date BETWEEN ParamDate1 AND ParamDate2
						|	and issale = true
						|	order by d.date";
	#КонецОбласти
	SelectScript = СтрЗаменить(SelectScript,"ParamDate1", ПреобразоватьДатуВПараметр(ПериодОтбора.ДатаНачала));
	SelectScript = СтрЗаменить(SelectScript,"ParamDate2",ПреобразоватьДатуВПараметр(ПериодОтбора.ДатаОкончания));
	SelectScripts.Вставить("Накладные",SelectScript);
	
	#Область _______ТекстЗапроса
		SelectScript = "SELECT c.customerid ИДСтрока, c.name КлиентСтрока, c.code КодСтрока, 
						|	t.name ТипТочкиСтрока, st.name ПризнакТорговлиСтрока, c.inn ИННСтрока, 
						|	c.latitude ШиротаСтрока, c.longitude ДолготаСтрока, sd.name ПодразделениеСтрока, 
						|	cp.name ГоловнойКлиентСтрока, c.isis ИсисКодСтрока
						|FROM t_customers c
						|	join t_customertypes t on c.typeid = t.customertypeid
						|	join t_storetype st on c.storetypeid = st.storetypeid 
						|	join t_customers cp on c.parentid = cp.customerid
						|	join t_subdivision sd on c.subdivisionid = sd.subdivisionid";
	#КонецОбласти
	SelectScripts.Вставить("Партнеры",SelectScript);
	
	#Область _______ТекстЗапроса
		SelectScript = "SELECT pt.name СоглашениеСтрока, pricetype.name ТипЦеныСтрока, 
						|pt.limitsum ЛимитСуммыСтрока, pt.debt ЗадолженностьСтрока, pt.limitday ЛимитДнейСтрока
						|FROM public.t_paymentterms pt
						|join t_pricetypes pricetype on pt.pricetypeid = pricetype.pricetypeid
						|where customerid = ParamСustomerid";
	#КонецОбласти
	SelectScripts.Вставить("Соглашение",SelectScript);
	
	#Область _______ТекстЗапроса
		SelectScript = "SELECT productid ИДСтрока, name ТоварСтрока, code КодСтрока, 
						|article АртикулСтрока, ean ШтрихкодСтрока
						|FROM public.t_products;";
	#КонецОбласти
	SelectScripts.Вставить("Товары",SelectScript);
	
		
	#Область _______ТекстЗапроса
	SelectScript = "	select t_pricetypes.name ТипЦеныСтрока, t_pricelist.price ЦенаЧисло
						|from t_pricelist t_pricelist
						|join t_pricetypes t_pricetypes on t_pricelist.pricetypeid = t_pricetypes.pricetypeid
						|where productid = ParamProduct";
	#КонецОбласти
	SelectScripts.Вставить("Цены",SelectScript);

	#Область _______ТекстЗапроса
	SelectScript = "	select p.article АртикулСтрока, p.name товарСтрока, 
						|dd.quantity КоличествоЧисло, dd.baseprice БазоваяЦенаЧисло, 
						|dd.price ЦенаЧисло, dd.sum СуммаЧисло, 
						|dd.discountsum СуммаТУЧисло, dd.promosum СуммаПромоЧисло 
						|from t_documentdetails dd join t_products p 
						|on dd.productid = p.productid 
						|where documentid = paramDocumentID";
	#КонецОбласти
	SelectScripts.Вставить("ДеталиДокумента",SelectScript);
	
	#Область _______ТекстЗапроса
	SelectScript = "	select pr.promoid ПромоИдСтрока, pr.name ПромоСтрока, 
						|dp.quantity КоличествоЧисло, dp.sum СуммаЧисло
						|from t_docpromo dp join t_promo pr
						|on dp.promoid = pr.promoid
						|where dp.documentid = paramDocumentID";
	#КонецОбласти
	SelectScripts.Вставить("ПромоДокумента",SelectScript);
	
	#Область _______ТекстЗапроса
	SelectScript = "	SELECT dt.name ТипСкидкиСтрока, dd.sum СуммаЧисло
						|FROM public.t_docdiscounts dd join
						|t_discounttypes dt on dd.discounttypeid = dt.discounttypeid
						|where dd.documentid = paramDocumentID";
	#КонецОбласти
	SelectScripts.Вставить("СкидкиДокумента",SelectScript);
	
	#Область _______ТекстЗапроса
	SelectScript = "	select s.name СкладСтрока, r.value ОстатокЧисло, 
						|s.subdivisionid ПодразделениеИДСтрока
						|from t_remains r join t_stocks s
						|on r.stockid = s.stockid
						|where productid = ParamProduct";
	#КонецОбласти
	SelectScripts.Вставить("Остатки",SelectScript);
	
	
	Возврат SelectScripts;
	
КонецФункции

Функция ПреобразоватьДатуВПараметр(ТекДата)

	Возврат "'" + Формат(ТекДата, "ДФ =гггММдд") + "'";
	
КонецФункции

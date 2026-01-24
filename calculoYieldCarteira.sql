with negotiation as (
	select n.ticker as ticker,
		   sum(
		   		case when n.operacao = 'C' then n.quantidade else -1*n.quantidade end
		   ) as quantidade   
	from negociacao n
	group by n.ticker
),
dividendos_dolarizados as (
	select n.ticker as ticker,
		   n.quantidade as quantidade,
		   d.data_liquidacao as data_liquidacao,
		   d.lancamento as lancamento,
		   cd.valor as valor,
		   d.lancamento / cd.valor as lacamentoDolarizado
	from negotiation n
	inner join dividendo d on d.ticker = n.ticker
	inner join cotacao_dolar cd on cd."data" = d.data_liquidacao 
	where n.quantidade > 0 
		and d.data_liquidacao between '2024-07-01' and '2025-06-30'
		--and d.data_liquidacao between '2024-01-01' and '2024-12-31'
		--and d.data_liquidacao between '2023-07-01' and '2024-06-30'
		--and d.data_liquidacao between '2023-01-01' and '2023-12-31'
		--and d.data_liquidacao between '2022-07-01' and '2023-06-30'
),
total_dividendos_dolarizados as (
	select dd.ticker,
		   sum(dd.lancamento) as totalDividendosReal,
		   sum(dd.lacamentoDolarizado) as totalDividendosDolar
	from dividendos_dolarizados dd
	group by dd.ticker
),
-- os 3 selects acima são para contabilizar os dividendos das ações que ainda tenho em carteira...
-- enquanto os dois abaixo são para contabilizar em dolar as compras de cada papel
-- para no fim da query eu poder calcular o y1 e y2
compras as (
	select n.ticker,
		   n.quantidade,
		   n."date",
		   n.preco_unitario,
		   CD.id,
		   cd.valor as fechamentoDolarNoDia,
		   n.preco_unitario / cd.valor as precoUnitarioDolarizado
	from negociacao n
	inner join cotacao_dolar cd on cd."data"  = n."date"
	-- fazendo aqui com que eu não traga dados de compra de ações que não constam mais em carteira
	inner join negotiation nn on nn.ticker = n.ticker
	where nn.quantidade > 0
		and n."date" < '2024-07-01'
--		and n."date" < '2024-01-01'
--		and n."date" < '2023-07-01'
--		and n."date" < '2023-01-01'
--		and n."date" < '2022-07-01'
),
-- select * from compras;
total_compras as (
	select c.ticker as ticker,
		   sum(c.preco_unitario*c.quantidade) as totalReal,
		   sum(c.precoUnitarioDolarizado*c.quantidade) as totalDolar
	from compras c
	group by c.ticker
),
yield_carteira as (
--	select total_compras.ticker,
--		   total_compras.totalreal as total_real,
--		   total_compras.totaldolar as total_dolar,
--		   tdd.totaldividendosreal as totaldividendosreal,
--		   tdd.totaldividendosdolar as totaldividendosdolar,
--		   tdd.totaldividendosreal / total_compras.totalreal as y1,
--		   tdd.totaldividendosdolar / total_compras.totaldolar as y2
--	from total_compras total_compras
--	inner join total_dividendos_dolarizados tdd on tdd.ticker = total_compras.ticker
--	order by y2 desc
	select sum(total_compras.totaldolar) as total_compras_dolar,
		   sum(tdd.totaldividendosdolar) as total_dividendos_dolar
	from total_compras total_compras
	inner join total_dividendos_dolarizados tdd on tdd.ticker = total_compras.ticker
	 inner join ticker_yield_results tyr on tyr.ticker = tdd.ticker and tyr.ticker_type = 'ACAO' -- 'FII'
)
select total_dividendos_dolar / total_compras_dolar as yield_carteira from yield_carteira;




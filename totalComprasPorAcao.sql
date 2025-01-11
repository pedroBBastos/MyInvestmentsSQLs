with negotiation as (
	select n.ticker as ticker,
		   sum(
		   		case when n.operacao = 'C' then n.quantidade else -1*n.quantidade end
		   ) as quantidade   
	from negociacao n
	group by n.ticker
),
compras as (
	select n.ticker,
		   n.quantidade,
		   n."date",
		   n.preco_unitario,
		   cd.valor as fechamentoDolarNoDia,
		   n.preco_unitario / cd.valor as precoUnitarioDolarizado
	from negociacao n
	inner join negotiation nn on nn.ticker = n.ticker
	inner join cotacao_dolar cd on cd."data"  = n."date"
	where nn.quantidade > 0
	-- where n."date" between '2022-01-01' and '2022-12-31'
),
total_compras as (
	select c.ticker as ticker,
		   sum(c.preco_unitario*c.quantidade) as totalReal,
		   sum(c.precoUnitarioDolarizado*c.quantidade) as totalDolar
	from compras c
	group by c.ticker
)
select * from total_compras
order by totalDolar desc;



CREATE TABLE stocks (
    ticker TEXT NOT NULL,
    setor TEXT,
    subsetor TEXT,
    segmento TEXT,
    PRIMARY KEY (ticker)
);

INSERT INTO stocks (ticker,setor,subsetor,segmento) VALUES
	 ('BBAS3','Financeiro','Intermediarios Financeiros','Bancos'),
	 ('AGRO3','Consumo não cíclico','Agropecuária','Agricultura'),
	 ('PCAR3','Consumo não cíclico','Comércio e Distribuição','Alimentos'),
	 ('PSSA3','Financeiro','Previdência e Seguros','Seguradoras'),
	 ('VALE3','Materiais Básicos','Mineração','Minerais Metálicos'),
	 ('PEAB3','Financeiro','Holdings Diversificadas','Holdings Diversificadas'),
	 ('PETR4','Petróleo. Gás e Biocombustíveis','Petróleo. Gás e Biocombustíveis','Exploração, Refino e Distribuição'),
	 ('UNIP5','Materiais Básicos','Químicos','Químicos Diversos'),
	 ('BRSR6','Financeiro','Intermediarios Financeiros','Bancos'),
	 ('ITSA4','Financeiro','Intermediarios Financeiros','Bancos');
INSERT INTO stocks (ticker,setor,subsetor,segmento) VALUES
	 ('SANB11','Financeiro','Intermediarios Financeiros','Bancos'),
	 ('BBDC3','Financeiro','Intermediarios Financeiros','Bancos'),
	 ('BRAP4','Materiais Básicos','Mineração','Minerais Metálicos'),
	 ('FLRY3','Saúde','Serv.Méd.Hospit, Análises e Diagnósticos','Serv.Méd.Hospit, Análises e Diagnósticos'),
	 ('CMIG4','Utilidade Pública','Energia Elétrica','Energia Elétrica'),
	 ('CMIG3','Utilidade Pública','Energia Elétrica','Energia Elétrica'),
	 ('TAEE4','Utilidade Pública','Energia Elétrica','Energia Elétrica'),
	 ('TAEE11','Utilidade Pública','Energia Elétrica','Energia Elétrica'),
	 ('ISAE4','Utilidade Pública','Energia Elétrica','Energia Elétrica'),
	 ('CMIN3','Materiais Básicos','Mineração','Minerais Metálicos');
INSERT INTO stocks (ticker,setor,subsetor,segmento) VALUES
	 ('CXSE3','Financeiro','Previdência e Seguros','Corretoras de Seguros'),
	 ('SAPR11','Utilidade Pública','Água e Saneamento','Água e Saneamento'),
	 ('CSMG3','Utilidade Pública','Água e Saneamento','Água e Saneamento'),
	 ('AURE3','Utilidade Pública','Energia Elétrica','Energia Elétrica'),
	 ('SLCE3','Consumo não cíclico','Agropecuária','Agricultura'),
	 ('EALT4','Bens Industriais','Máquinas e Equipamentos','Máquinas e Equipamentos Industriais'),
	 ('ROMI3','Bens Industriais','Máquinas e Equipamentos','Máquinas e Equipamentos Industriais'),
	 ('LEVE3','Consumo Cíclico','Automóveis e Motocicletas','Automóveis e Motocicletas'),
	 ('TASA4','Bens Industriais','Máquinas e Equipamentos','Armas e Munições'),
	 ('VIVT3','Comunicações','Telecomunicações','Telecomunicações');
INSERT INTO stocks (ticker,setor,subsetor,segmento) VALUES
	 ('GRND3','Consumo Cíclico','Tecidos, Vestuário e Calçados','Calçados'),
	 ('RANI3','Materiais Básicos','Embalagens','Embalagens'),
	 ('KLBN11','Materiais Básicos','Madeira e Papel','Papel e Celulose'),
	 ('MTRE3','Consumo Cíclico','Construção Civil','Incorporações');

-----------

with contagem as (
	select n.ticker as ticker,
		   sum(
		   		case when n.operacao = 'C' then n.quantidade else -1*n.quantidade end
		   ) as quantidade   
	from negociacao n
	group by n.ticker
)
select * from contagem
inner join stocks s on s.ticker = contagem.ticker
where contagem.quantidade > 0;

----------
--
--delete from negociacao 
--where ticker = 'EALT4' and valor_total in ( 506.0, 580.58);
--
--INSERT INTO negociacao
--(id, date, operacao, preco_unitario, quantidade, ticker, tipo_de_mercado, valor_total)
--VALUES(NULL, '2024-07-29', 'C', 11.38, 51, 'EALT4', NULL, 580.58);
--INSERT INTO negociacao
--(id, date, operacao, preco_unitario, quantidade, ticker, tipo_de_mercado, valor_total)
--VALUES(NULL, '2024-07-26', 'C', 11.5, 44, 'EALT4', NULL, 506.0);

select * from negociacao n
where n.ticker = 'RANI3';

select sum(quantidade) from negociacao n
where n.ticker = 'AGRO3';

select * from stocks;

select setor, count(*) from stocks
group by setor;

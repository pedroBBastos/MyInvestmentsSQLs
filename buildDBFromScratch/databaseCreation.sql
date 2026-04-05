create table negociacao
(
    id              integer primary key,
    date            date,
    operacao        character(1),
    preco_unitario  real,
    quantidade      integer,
    ticker          character varying(255),
    tipo_de_mercado character varying(255),
    valor_total     real
);

CREATE TABLE dividendo (
    id                INTEGER PRIMARY KEY,
    data_liquidacao   DATE,
    data_movimentacao DATE,
    lancamento        REAL,
    ticker            TEXT
);

CREATE TABLE cotacao_dolar (
    id    INTEGER PRIMARY KEY,
    data  DATE,
    valor REAL
);

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

create table main.ticker_yield_results
(
    ticker         character varying(255),
    y1             double precision,
    y2             double precision,
    tracked_period VARCHAR,
    ticker_type    VARCHAR
);

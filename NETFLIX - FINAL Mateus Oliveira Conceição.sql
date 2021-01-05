create database netflix;
use netflix;

-- tabela Pessoa
create table pessoa(
	id_pessoa int not null auto_increment,
    nome varchar(200) not null,
    data_nascimento varchar(45) not null,
    nacionalidade varchar(45) not null,
    identificador varchar(45) not null,
    
    primary key(id_pessoa)
);

-- tabela Filme
CREATE TABLE filme (
    id_filme INT NOT NULL AUTO_INCREMENT,
    nome_filme VARCHAR(255),
    ano_lancamento varchar(45),
    classificacao varchar(45),
    duracao VARCHAR(45),
    critica DOUBLE,
    
    PRIMARY KEY (id_filme)
);

-- tabela Direcao
create table direcao(
	id_diretor INT NOT NULL AUTO_INCREMENT,
    pessoa int,
    filme int,
    
    PRIMARY KEY (id_diretor),
    foreign key(filme) references filme(id_filme),
    foreign key(pessoa) references pessoa(id_pessoa)
);

-- Tabela Ator
create table ator(
	id_ator int not null auto_increment,
    papel varchar(45),
    tipo_papel varchar(45),
    pessoa int,
    filme int,
    
    primary key(id_ator),
    foreign key(pessoa) references pessoa(id_pessoa),
    foreign key(filme) references filme(id_filme)
);

-- tabela Genero
create table genero(
	id_genero int not null auto_increment,
    nome_genero varchar(255),
    
     primary key(id_genero)
);

-- tabela Filme_genero
create table filme_genero(
	filme int,
    genero int,
    
    foreign key(genero) references genero(id_genero),
    foreign key(filme) references filme(id_filme)
);

-- tabela Cliente
create table cliente(
	id_cliente int not null auto_increment,
	nome_usuario varchar(45),
    fk_pessoa int,
    
    primary key(id_cliente),
    foreign key(fk_pessoa) references pessoa(id_pessoa)
);

-- tabela Filmes_assistidos
create table filmes_assistidos(
	filme int,
    cliente int,
    porcentagem int,
    
    foreign key(filme) references filme(id_filme),
    foreign key(cliente) references cliente(id_cliente)
);

-- tabela Filmes_favoritos
create table filmes_favoritos(
	filme int,
    cliente int,
    
    foreign key(filme) references filme(id_filme),
    foreign key(cliente) references cliente(id_cliente)
);

-- Inserts de Filmes
insert into filme(nome_filme, ano_lancamento, classificacao, duracao ,critica)values
    ("The Last Days of American Crime","2020","65","200",5), -- 1
    ("Django Livre","2012","81","180",9), -- 2
    ("O Senhor dos Anéis: A Sociedade do Anel","2005","71","240",6); -- 3

-- Inserts de Pessoas
insert into pessoa(nome, data_nascimento, nacionalidade, identificador)values
    ("Michel Pitts", "10-12-1974", "USA", "CLI"), -- 1
    ("Heater Graham", "21-10-1965", "USA", "CLI"), -- 2
    ("Marcela Santos", "12-07-1989", "BRA", "ATR"), -- 3
    ("Zach Galifianakis", "11-09-1991", "ING", "ATR"), -- 4
    ("Mateus Oliveira", "22-05-2000", "BRA", "DIR"), -- 5
    ("Oliver Megaton", "18-05-1959", "USA", "DIR"); -- 6

-- Inserts de Atores
insert into ator(papel, tipo_papel, pessoa, filme)values
	("Doug Billings","Coadjuvante",3,2),-- 1
    ("Henry Torne","Protagonista",4,3), -- 2
    ("Gertrude Baniszewski","Coadjuvante",3,2); -- 3

-- Inserts de Diretores
insert into direcao(pessoa, filme)values
	(6,1),
    (6,3),
    (5,2);

-- Inserts de Generos
insert into genero(nome_genero)values
	("Ação"), -- 1
	("Aventura"), -- 2
	("Biografia"), -- 3
	("Comédia"), -- 3
	("Crime"), -- 4
	("Esporte"), -- 5
	("Natal"), -- 6
	("Fantasia"), -- 7
	("Policial"); -- 8

-- Inserts de Clientes
insert into cliente(nome_usuario, fk_pessoa)values
	("Michel Pitts", 1), -- 1
    ("Heater Graham", 2); -- 2


-- Inserts Filme_genero
insert into filme_genero(filme, genero)values
	(1, 4), -- 1
    (2, 1), -- 2
    (3, 7); -- 3
    
-- Q2.a
	DELIMITER $$
	create procedure `filmes_assistidos`(
		filme int, cliente int,porcentagem int
	)
	begin
		insert into filmes_assistidos values (filme, cliente, porcentagem);
	end $$
	DELIMITER ;
    
    call filmes_assistidos (1, 1, 100);
	call filmes_assistidos (1, 1, 40);
    call filmes_assistidos (2, 2, 70);
    call filmes_assistidos (3, 2, 20);

-- Q2.b
	DELIMITER $$
	create procedure `filmes_assistidos_completamente`(
		filme int, cliente int,porcentagem int
	)
	begin
		insert into filmes_assistidos values (filme, cliente, porcentagem);
	end $$
	DELIMITER ;
    
    call filmes_assistidos (3, 1, 100);
	call filmes_assistidos (3, 1, 100);
    call filmes_assistidos (1, 2, 100);
    

-- Q2.c
	DELIMITER $$
	create procedure `filmes_favoritos`(
		filme int, cliente int
	)
	begin
		insert into filmes_favoritos values (filme, cliente);
	end $$
	DELIMITER ;
    
    call filmes_favoritos (3, 1);
	call filmes_favoritos (1, 2);


-- Q2.d
	DELIMITER $$
	create procedure atualizar_filmes_favoritos(
		cliente int, filme int
	)
	begin
		update filmes_favoritos
		set cliente = cliente
		where cliente = cliente ;
		--
		update filmes_favoritos
		set filme = filme
		where filme = filme ;
	end $$
	DELIMITER ;

-- Q3.a
create view `genero_acao` as
select F.id_filme as "Id - Filme", F.nome_filme as "Filme", COUNT(F.nome_filme) as "Quant. Assistido" from cliente C
	inner join filmes_assistidos A on cliente = A.cliente
	inner join filme F on A.filme = F.id_filme
	inner join filme_genero Fg on F.id_filme = Fg.filme
	where Fg.genero = '1'
	group by 1 ;
        
-- Q3.b
	create view `10_assinantes` as
	select C.id_cliente as 'Id - cliente', C.nome_usuario, COUNT(a.filme) as 'Totalmente Asssistido' from cliente C
		inner join filmes_assistidos A on C.id_cliente = A.cliente
		where A.porcentagem = '100'
		group by 1 limit 10 ;
        
        
-- Q3.c
create view `50_filmes` as
	select F.id_filme as "ID - Filme", F.nome_filme as "Filme", COUNT(F.nome_filme) as "Quant. Assistido" from cliente c
	inner join filmes_assistidos A on C.id_cliente = A.cliente
	inner join filme F on A.filme = F.id_filme
	inner join filme_genero Fg on F.id_filme = Fg.filme
	where Fg.genero = '1'
	group by 1;

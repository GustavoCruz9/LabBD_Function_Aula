create database LabBD_Functions_Aula
go
use LabBD_Functions_Aula
go
create table Funcionario(
codFuncionario	int				not null,
nome			varchar(50)		not null,
salario			decimal(7,2)	not null
Primary key(codFuncionario)
)
go
create table Dependente(
codDep			int				not null,
codFuncionario	int				not null,
nomeDep			varchar(50)		not null,
salarioDep		decimal(7,2)	not null
Primary key(codDep)
Foreign Key(codFuncionario) references Funcionario(codFuncionario)
)
-- Inserindo valores na tabela Funcionario
INSERT INTO Funcionario (codFuncionario, nome, salario) VALUES
(1, 'João Silva', 3000.00),
(2, 'Maria Santos', 3500.00),
(3, 'Carlos Oliveira', 2800.00),
(4, 'Ana Pereira', 3200.00),
(5, 'Pedro Costa', 4000.00),
(6, 'Mariana Oliveira', 3100.00),
(7, 'Paulo Rodrigues', 2900.00),
(8, 'Fernanda Costa', 3300.00),
(9, 'Luiz Pereira', 3600.00),
(10, 'Juliana Santos', 2700.00);

INSERT INTO Dependente (codDep, codFuncionario, nomeDep, salarioDep) VALUES
(1, 1, 'Laura Oliveira', 1500.00),
(2, 1, 'Pedro Rodrigues', 1700.00),
(3, 2, 'Mariana Costa', 1800.00),
(4, 3, 'Lucas Pereira', 1600.00),
(5, 5, 'Ana Santos', 1400.00);


select * from Funcionario
select * from Dependente

-- Exercicio 1) Criar uma database, criar as tabelas abaixo, definindo o tipo de dados e a relação PK/FK e popular
--com alguma massa de dados de teste (Suficiente para testar UDFs)
--a) Código no Github ou Pastebin de uma Function que Retorne uma tabela:
--(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)--
--b) Código no Github ou Pastebin de uma Scalar Function que Retorne a soma dos Salários dos
--dependentes, mais a do funcionário.

-- a)

create function fn_exec1A()
returns @tabela table (
nomeFuncionario	varchar(50),
nomeDep			varchar(50),
salario			decimal(7,2),
salarioDep		decimal(7,2)
)
begin

	insert into @tabela (nomeFuncionario, nomeDep, salario,salarioDep)
		SELECT 
			f.nome AS Nome_Funcionario,
			d.nomeDep AS Nome_Dependente,
			f.salario AS Salario_Funcionario,
			d.salarioDep AS Salario_Dependente
		FROM 
			Funcionario f
		INNER JOIN 
			Dependente d ON f.codFuncionario = d.codFuncionario;

	return
end

select * from fn_exec1A()

--b)

create function fn_exec1B(@cod INT)
returns decimal(7,2)
begin
	DECLARE @somaSalario DECIMAL(7,2)

    SELECT @somaSalario = f.salario + ISNULL((SELECT SUM(d.salarioDep)
                                              FROM Dependente d
                                              WHERE d.codFuncionario = f.codFuncionario), 0)
    FROM Funcionario f
    WHERE f.codFuncionario = @cod

    RETURN @somaSalario
end

select dbo.fn_exec1B(1) as SomaSalarios

-- a) a partir da tabela Produtos (codigo, nome, valor unitário e qtd estoque), quantos produtos
-- estão com estoque abaixo de um valor de entrada

CREATE TABLE Produtos (
    codigo INT,
    nome VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    qtd_estoque INT NOT NULL
	Primary Key(codigo)
)

INSERT INTO Produtos (codigo, nome, valor_unitario, qtd_estoque) VALUES
(1, 'Camiseta', 29.99, 100),
(2, 'Calça Jeans', 59.90, 50),
(3, 'Tênis', 99.99, 30),
(4, 'Boné', 15.50, 80),
(5, 'Moletom', 49.99, 40),
(6, 'Jaqueta', 79.99, 20),
(7, 'Saia', 39.90, 60),
(8, 'Blusa de Frio', 35.99, 25),
(9, 'Shorts', 25.99, 70),
(10, 'Chinelo', 9.99, 90),
(11, 'Vestido', 45.90, 35),
(12, 'Meia', 4.50, 120),
(13, 'Cinto', 12.99, 75),
(14, 'Bermuda', 29.90, 55),
(15, 'Lenço', 8.99, 85)

select * from Produtos

create function fn_exec2A(@valor_estoque int)
returns int
as
begin
    declare @qtd int;

    select @qtd = COUNT(*)
    from Produtos
    where qtd_estoque <= @valor_estoque;

    return @qtd
end

select dbo.fn_exec2A(25) as qtd

-- b) Uma tabela com o código, o nome e a quantidade dos produtos que estão com o estoque
-- abaixo de um valor de entrada

create function fn_exec2B(@valor_estoque int)
returns @tabela table (
    codigo int,
    nome varchar(100),
    quantidade int
)
as
begin
    insert into @tabela (codigo, nome, quantidade)
		select codigo, nome, qtd_estoque
		from Produtos
		where qtd_estoque < @valor_estoque

    return
end

select * from fn_exec2B(50)

create table cliente (
	codigo		int,
	nome		varchar(100)
	primary key(codigo)
)
 
go
 
create table produto (
	codigo		int,
	nome		varchar(100),
	valor		decimal(7,2)
	primary key (codigo)
)
 
create table clienteproduto (
	cod				int		not null,
	codCliente		int		not null,
	codProduto		int		not null,
	Qtd				int		not null
	primary key(cod)
	foreign key (codCliente) references cliente (codigo),
	foreign key (codProduto) references produto (codigo)
)

-- Inserindo valores na tabela 'cliente'
INSERT INTO cliente (codigo, nome) VALUES
(1, 'Cliente A'),
(2, 'Cliente B'),
(3, 'Cliente C'),
(4, 'Cliente D'),
(5, 'Cliente E');
 
-- Inserindo valores na tabela 'produto'
INSERT INTO produto (codigo, nome, valor) VALUES
(1, 'Produto X', 29.99),
(2, 'Produto Y', 59.90),
(3, 'Produto Z', 99.99),
(4, 'Produto W', 15.50),
(5, 'Produto V', 49.99);

INSERT INTO clienteproduto (cod, codCliente, codProduto, Qtd) VALUES
(1, 1, 1, 10),
(2, 2, 2, 20),
(3, 3, 3, 5),
(4, 4, 4, 15),
(5, 5, 5, 8);

select * from cliente
select * from produto
select * from clienteproduto

create function fn_exec3()
returns @tabela table (
nomeCli		varchar(100),
nomeProd	varchar(100),
valor		decimal(7,2),
qtd			int,
dataHj		varchar(10)
)
begin
	insert into @tabela (nomeCli, nomeProd, valor, qtd, dataHj)
		select c.nome,	p.nome, cp.Qtd, cp.Qtd * p.valor, convert(varchar(10), getdate(), 103)
		from clienteproduto cp
		inner join cliente c on cp.codCliente = c.codigo
		inner join produto p on cp.codProduto = p.codigo

	return
end

select * from fn_exec3()
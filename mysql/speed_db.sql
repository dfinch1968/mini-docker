create database speedtest;

use speed;

create table speed(
	mydt	bigint not null,
	isp		varchar(50) not null,
	ispip	varchar(30) not null,
	prov	varchar(30) not null,
	provloc varchar(50) not null,
	lat int not null,
	down	int not null,	
	up		int not null,
    PRIMARY KEY (mydt)
);

INSERT INTO speed(mydt,isp,ispip,proc,provloc,lat,down,up) VALUES (202501051125,"myISP","199.0.0.1","Finch-fibre","LeHigh Acres, FL",0,10,1000)
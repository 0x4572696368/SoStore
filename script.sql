create database  so_store;
use so_store;

create table Products(
`idp` int auto_increment not null,
`name` text not null,
`description` text not null,
`price` int not null,
`stock` int not null,
primary key (`idp`)
);

create table Images(
`idi` int auto_increment not null,
`idp` int not null,
`image` text not null,
primary key (`idi`),
FOREIGN KEY (`idp`) REFERENCES Products(`idp`) ON DELETE CASCADE
);

DELIMITER $$
CREATE PROCEDURE `insertProducts`(in `name` text , in `description` text, in `price` int, in `stock` int)
BEGIN
insert into Products(`name`,`description`,`price`,`stock`) values (`name`,`description`,`price`,`stock`);
SELECT LAST_INSERT_ID() AS 'last_id';
END;
$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `insertImages`(in `idp` int , in `image` text)
BEGIN
insert into Images(`idp`,`image`) values (`idp`,`image`);
END;
$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE `selectProducts`(in `page` int)
BEGIN
IF `page` = 0 THEN
SELECT p.*, 
    (
        select concat('[', group_concat(json_object('idi', i.idi, 'Photo', i.image)), ']')
        from Images i
        where i.idp = p.idp
    ) as photos
from Products p order by p.idp desc limit 4;
	ELSE
    SELECT p.*, 
    (
        select concat('[', group_concat(json_object('idi', i.idi, 'Photo', i.image)), ']')
        from Images i
        where i.idp = p.idp
    ) as photos
from Products p where p.idp < `page` order by p.idp desc limit 4;
    END IF;
END
$$
DELIMITER ;

CALL insertProducts ('Zapato','El mejor zapato 100% cuero peruano',100,300);
Call selectProducts(4);


SELECT p.*, 
    (
        select concat('[', group_concat(json_object('idi', i.idi, 'Photo', i.image)), ']')
        from Images i
        where i.idp = p.idp
    ) as photos
from Products p where p.idp < 7 order by p.idp desc limit 4 ;

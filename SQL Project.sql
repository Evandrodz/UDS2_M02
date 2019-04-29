/* Query 1
-- Os 10 clientes que mais compraram do artista com maior faturamento.
-->Quem é o Ator que mais vende musicas  e quais são os 10 clientes que compraram suas musicas?
-->Quem é o cliente numero 1?  
*/
select c.firstname ||' '|| c.lastname Client,
       sum(il.unitprice * il.quantity) as amountspent, 
       c.CustomerId,
       ar.name Artist_name
  from track as t
  join album as a
    on a.albumid = t.albumid
  join artist as ar
    on ar.artistid = a.artistid
  join invoiceline as il
    on il.trackid = t.trackid
  join invoice as i
    on i.invoiceid = il.invoiceid
  join customer as c
    on c.customerid = i.customerid
  join (select ar.name, sum(il.unitprice * il.quantity) as amountspent
		  from track as t
		  join album as a
		    on a.albumid = t.albumid
		  join artist as ar
		    on ar.artistid = a.artistid
		  join invoiceline as il
		    on  il.trackid = t.trackid 
		 group by ar.name
		 order by amountspent desc
		 limit 1)sub
    on ar.name = sub.name
 group by ar.name, c.customerid, c.firstname,c.lastname
 order by amountspent desc
 limit 10;
 
/* Query 2
-- Os Generos de musicas mais vendidos em cada País.
--> Quais são o gêneros de musicas mais vendidos em cada país? 
--> Qual os 3 paises destaques do genero que mais vende?
*/ 
select  c.country ||'-'|| g.name as Country_gender, count(i.invoiceid) as Purchases
		from Genre as g
		join Track as t
		on t.genreid = g.Genreid
		join InvoiceLine AS il
		on il.trackid = t.Trackid
		join Invoice As i
		on i.Invoiceid = il.Invoiceid
		join Customer as c
		on c.Customerid = i.Customerid
		join (select aux.country, max(aux.purchases) as max_purchases
               from (select count(i0.invoiceid) as Purchases, c0.country, g0.name, g0.Genreid
					   from Genre as g0
					   join Track as t0
					   on t0.genreid = g0.Genreid
					   join InvoiceLine AS il0
					   on il0.trackid = t0.Trackid
					   join Invoice As i0
					   on i0.Invoiceid = il0.Invoiceid
					   join Customer as c0
					   on c0.Customerid = i0.Customerid
					   group by c0.country, g0.name, g0.Genreid
				    )aux
			   group by aux.country) cm
		  on cm.country = c.country		
		group by Country_gender
		having count(i.invoiceid) = cm.max_purchases; 
		
		
/* Query 3		
-- Rock in the World – Amount Spent	
--> Qual a total gasto com musica de Rock por cada país.	
*/		
select  c.country, sum(il.unitprice * il.quantity) as amountspent
		from Genre as g
		join Track as t
		  on t.genreid = g.Genreid
	     and t.genreid = 1 -- Rock
		join InvoiceLine AS il
		  on il.trackid = t.Trackid
		join Invoice As i
		  on i.Invoiceid = il.Invoiceid
		join Customer as c
		  on c.Customerid = i.Customerid
		group by Country;

/* Query 4		
-- Rock x Others musics	
--> Qual o total gasto com musica de Rock e o seu comparativo com todas os outros generos.	
*/
select  case when g.name = 'Rock' then 'Rock'
             else 'Others' end Gender, 
		round(sum(il.unitprice * il.quantity),2) as amountspent
		from Genre as g
		join Track as t
		  on t.genreid = g.Genreid	     
		join InvoiceLine AS il
		  on il.trackid = t.Trackid
		join Invoice As i
		  on i.Invoiceid = il.Invoiceid
		group by Gender 
		order by 2 desc; 		
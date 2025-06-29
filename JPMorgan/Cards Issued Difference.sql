with rank_db as (SELECT *,
DENSE_RANK() OVER(PARTITION BY card_name order by issued_amount) as rnk,
DENSE_RANK() OVER(PARTITION BY card_name order by issued_amount DESC) as rnk_desc
from monthly_cards_issued),

joined_db as
(select s.card_name,s.issued_amount as smaller_amount,s.rnk,b.issued_amount as bigger_amount,b.rnk_desc
from rank_db as s 
left join rank_db as b 
on s.rnk=b.rnk_desc
and s.card_name=b.card_name)

select card_name,(bigger_amount-smaller_amount) as difference
from joined_db
where rnk=1
group by card_name,bigger_amount,smaller_amount
order by (bigger_amount-smaller_amount) desc;

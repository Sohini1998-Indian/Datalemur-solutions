-- 🚀 Problem: Credit Card Issuance Difference
-- Platform: DataLemur | Company: JPMorgan Chase

-- 📝 Question:
-- Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights,
-- you're analyzing how many credit cards were issued each month.
--
-- Write a query that outputs the name of each credit card and the difference in the number of issued cards
-- between the month with the highest issuance and the lowest issuance.
-- Arrange the results based on the largest disparity.

-- 📊 Table: monthly_cards_issued
-- Columns:
-- - card_name STRING
-- - issued_amount INTEGER
-- - issue_month INTEGER
-- - issue_year INTEGER

-- 🧪 Example Input:
-- | card_name               | issued_amount | issue_month | issue_year |
-- |--------------------------|----------------|--------------|-------------|
-- | Chase Freedom Flex      | 55000          | 1            | 2021        |
-- | Chase Freedom Flex      | 60000          | 2            | 2021        |
-- | Chase Freedom Flex      | 65000          | 3            | 2021        |
-- | Chase Freedom Flex      | 70000          | 4            | 2021        |
-- | Chase Sapphire Reserve  | 170000         | 1            | 2021        |
-- | Chase Sapphire Reserve  | 175000         | 2            | 2021        |
-- | Chase Sapphire Reserve  | 180000         | 3            | 2021        |

-- ✅ Expected Output:
-- | card_name               | difference |
-- |--------------------------|------------|
-- | Chase Freedom Flex      | 15000      |
-- | Chase Sapphire Reserve  | 10000      |

-- 💡 Logic:
-- - Group by card_name
-- - Calculate max and min issued_amount per card
-- - Subtract min from max
-- - Sort descending by difference

-- 🧠 SQL Solution:
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

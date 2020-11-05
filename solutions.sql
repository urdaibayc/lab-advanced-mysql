CREATE TEMPORARY TABLE parcial_sales
SELECT title_id, au_id, price*qty*(royalty/100)*(royaltyper/100) as sales_royalty from(
  SELECT au.au_id, tiau.royaltyper, sa.title_id, ti.price, ti.royalty, sa.ord_num, sa.qty FROM sales AS sa
  INNER JOIN titles as ti
  ON sa.title_id = ti.title_id
  INNER JOIN titleauthor as tiau
  ON ti.title_id = tiau.title_id
  INNER JOIN authors AS au
  ON tiau.au_id = au.au_id
) as my_data
ORDER BY au_id DESC


SELECT title_id, au_id, SUM(sales_royalty) as sales from parcial_sales
GROUP BY au_id, title_id


SELECT au_id, SUM(sales) as au_sales FROM(
  SELECT title_id, au_id, SUM(sales_royalty) as sales from parcial_sales
  GROUP BY au_id, title_id
) as titau
GROUP BY au_id
ORDER BY au_sales DESC

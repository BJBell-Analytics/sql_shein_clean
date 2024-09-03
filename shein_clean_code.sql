# We are starting with 21 different data files imported into 21 separate tables. Our goal is to have a single table of clean data. 

# Get a list of all unique columns across all tables in the shein db.
SELECT DISTINCT COLUMN_NAME
FROM information_schema.columns
WHERE table_schema='shein';

/* Output:
'blackfridaybelts-bg src'
'blackfridaybelts-content'
'color-count'
'discount'
'goods-title-link'
'goods-title-link--jump'
'goods-title-link--jump href'
'price'
'product-locatelabels-img src'
'rank-sub'
'rank-title'
'selling_proposition'
*/

/* 
Eliminate unecessary columns if possible.

The 'goods-title-link--jump' and 'goods-title-link' appear to both be product descriptions.
Different products utilize one or the other (not both). We're going to make a 'product_description' 
field in the master table where this information will be stored. 

'goods-title-link-jump href' is the text url link to the product, but only available for half the products,
 and it not useful data for analysis.

The 'blackfridaybelts-bg src' column is a url to the same background image,
and is not relevant to our purposes. 'blackfridaybelts-content' just gives
a discount amount that we could calculate from 'discount' and 'price' if needed,
so we can eliminate that field as well.

'product-locatelabels-img src' is another unecessary static background image.

'color-count' is only available in a few categories, and with no additional data on what colors are available, 
it does not seem useful for analysis.

We want to preserve the category of each table, so we'll add 'product_category' and that will leave us with the following columns:

'product_category' - Text describing type of product
'product_description' - Text details describing product
'price' - $ amount for price
'discount' - % of discount
'rank-title' renamed to 'rank_title' - # representing best seller rank (e.g. #3 Best Seller)
'rank-sub' renamed to 'rank_sub' - Text description relevant to 'rank-title'
'selling_proposition' - Special field denoting tallied # of how many have been sold recently
*/

# Create master product table 'shein_products_staging1' preserving the old table name as the product_category for all items within the table. 
CREATE TABLE shein_products_staging1 (
	product_category text,
    product_description text,
    price text,  #convert type? We're going to keep everything text for now, and convert things later
    discount text, #convert type?
    rank_title text, #convert type?
    rank_sub text,
    selling_proposition text #convert type?  
);

# Copy data to new master product table 'shein_products_staging1'

# appliances
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "appliances",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM appliances;

# automotive
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, selling_proposition)
SELECT "automotive",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, selling_proposition
FROM automotive;

# baby_and_maternity
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, selling_proposition)
SELECT "baby_and_maternity",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, selling_proposition
FROM baby_and_maternity;

# bags_and_luggage
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "bags_and_luggage",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM bags_and_luggage;

# beauty_and_health
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "beauty_and_health",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM beauty_and_health;

# curve
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "curve",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM curve;

# electronics
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "electronics",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM electronics;

# home_and_kitchen
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "home_and_kitchen",
`goods-title-link`,  # Doesn't have the --jump column
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM home_and_kitchen;

# home_textile
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "home_textile",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM home_textile;

# jewelry_and_accessories
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "jewelry_and_accessories",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM jewelry_and_accessories;

# kids
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "kids",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM kids;

# mens_clothes
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "mens_clothes",
`goods-title-link`,  # Doesn't have the --jump column
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM mens_clothes;

# office_and_school_supplies
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "office_and_school_supplies",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM office_and_school_supplies;

# pet_supplies
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "pet_supplies",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM pet_supplies;

# shoes
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "shoes",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM shoes;

# sports_and_outdoors
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "sports_and_outdoors",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM sports_and_outdoors;

# swimwear
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub)
SELECT "swimwear",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`
FROM swimwear;

# tools_and_home_improvement
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "tools_and_home_improvement",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM tools_and_home_improvement;

# toys_and_games
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "toys_and_games",
`goods-title-link`,  # Doesn't have the --jump column
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM toys_and_games;

# underwear_and_sleepwear
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "underwear_and_sleepwear",
IF(`goods-title-link--jump` = "", `goods-title-link`,`goods-title-link--jump`), 
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM underwear_and_sleepwear;

# womens_clothing
INSERT INTO shein_products_staging1 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT "womens_clothing",
`goods-title-link`,  # Doesn't have the --jump column
price, discount, 
`rank-title`, `rank-sub`, selling_proposition
FROM womens_clothing;

# Create a staging table where we identify duplicates
CREATE TABLE shein_products_staging2 (
	product_category text,
    product_description text,
    price text,  #convert type? We're going to keep everything text for now, and convert things later
    discount text, 
    rank_title text, 
    rank_sub text,
    selling_proposition text,
    duplicate_num int # added to allow us to flag duplicate entries
);
# In shein_products_staging2, duplicate_num > 1 means it already has an identical entry in the database
INSERT INTO shein_products_staging2 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition, duplicate_num)
SELECT *, ROW_NUMBER() OVER(
	PARTITION BY product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition
) as duplicate_num
FROM shein_products_staging1;
# Get rid of duplicates and drop duplicate_num column
DELETE FROM shein_products_staging2 WHERE duplicate_num > 1;
ALTER TABLE shein_products_staging2 DROP COLUMN duplicate_num;

# rank_title appears to have inconsistencies with 'Best Seller' and 'Best Sellers'. We want consistency. 
UPDATE shein_products_staging2 SET rank_title = REPLACE(rank_title, 'Sellers', 'Seller');
 
# Get rid of '$' in price as well as '%' and '-' from discount so we can convert the datatypes as needed
UPDATE shein_products_staging2 SET price = REPLACE(price, '$', '');
UPDATE shein_products_staging2 SET discount = REPLACE(discount, '%', '');
UPDATE shein_products_staging2 SET discount = REPLACE(discount, '-', '');
 
# Create a staging table for converted values
CREATE TABLE shein_products_staging3 (
	product_category text,
    product_description text,
    price DECIMAL(15,2),  # $  
    discount DECIMAL(5,2),  # %
    rank_title text, 
    rank_sub text,
    selling_proposition text
);
INSERT INTO shein_products_staging3 (product_category, product_description, price, discount, rank_title, rank_sub, selling_proposition)
SELECT product_category, product_description, CAST(price AS float), (CAST(discount AS float)/100), rank_title, rank_sub, selling_proposition
FROM shein_products_staging2;

# At this point we can delete all of the original tables along with staging1 and staging2. We can also rename staging3 to the final (cleaned) table. 

# And the best part: data exploration can begin!

# Below are a few explorative queries

# Show discount alongside the current price of all products
SELECT product_description, price, discount FROM shein_products_staging3; 

# If there was a discount, calculate original price and show current price, and the discount
# original price = discounted price / (1 - discount)
SELECT product_description, CAST((price / (1-discount)) AS DECIMAL(15,2)) AS "Original Price", price AS "Current Price", CAST((discount*100) AS DECIMAL(3,0)) AS "Discount %"
FROM shein_products_staging3
WHERE discount <> 0;

# Look at all discounted products in the appliances category with a '#1' rank title
SELECT * FROM shein_products_staging3
WHERE rank_title LIKE '%#1 %' AND product_category = "appliances" AND discount <> 0;

# Output all cleaned data (67,245 products)
SELECT * INTO OUTFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/shein_cleaned_data_output.csv" FIELDS TERMINATED BY ',' ENCLOSED BY '"' ESCAPED BY '\\' LINES TERMINATED BY '\n' FROM shein_products_staging3;

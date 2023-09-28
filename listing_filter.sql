DROP PROCEDURE IF EXISTS listing_filter;

DELIMITER $$
CREATE PROCEDURE listing_filter
(
	param_borough VARCHAR(45),
    param_neighbourhood VARCHAR(45),
    param_type VARCHAR(45),
    param_min_price INT,
    param_max_price INT
)
BEGIN
    
-- //////////////////////////////// NO INPUT ///////////////////////////////
	IF param_borough = '' 
		AND param_neighbourhood = '' 
        AND param_type = '' 
		AND param_min_price = 0
        AND param_max_price = 0 THEN 
			SIGNAL SQLSTATE '22003'
			SET MESSAGE_TEXT = 'Please enter any information';
    END IF;

-- //////////////////////////////// WRONG INPUTS ///////////////////////////////
	IF param_borough NOT IN (SELECT DISTINCT borough FROM listings) AND param_borough != '' THEN
		SIGNAL SQLSTATE '22003'
		SET MESSAGE_TEXT = 'Please enter valid borough';
	
    ELSEIF param_neighbourhood NOT IN (SELECT DISTINCT neighbourhood FROM listings) AND param_neighbourhood != '' THEN
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Please enter valid neighbourhood';
        
	ELSEIF param_type NOT IN (SELECT DISTINCT type FROM listings) AND param_type != '' THEN
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Please enter valid type';
        
	ELSEIF param_min_price < (SELECT MIN(price) FROM listings) THEN
        SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Minimun Price subceeds all available prices';
        
	ELSEIF param_max_price < (SELECT MIN(price) FROM listings) THEN
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Minimum Price exceeds current Maximum Price';
        
	ELSEIF param_max_price < param_min_price AND param_max_price != 0 THEN
		SIGNAL SQLSTATE '22003'
        SET MESSAGE_TEXT = 'Maximum price needs to exceed minimum price';
    END IF;

-- //////////////////////////////// ALL INPUTS ///////////////////////////////
	IF param_borough IN (SELECT DISTINCT borough FROM listings)
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough
				AND neighbourhood = param_neighbourhood
				AND type = param_type
                AND price >= param_min_price
                AND price <= param_max_price;
	END IF;
    
-- //////////////////////////////// VARIANTS WITH ONE INPUT ///////////////////////////////
    IF param_borough IN (SELECT DISTINCT borough FROM listings)
		AND param_neighbourhood = '' 
        AND param_type = '' 
		AND param_min_price = 0
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough;

    ELSEIF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = '' 
		AND param_min_price = 0
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood;

    ELSEIF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE type = param_type;

    ELSEIF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE price >= param_min_price;

    ELSEIF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type = ''
		AND param_min_price = 0
        AND param_max_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings) THEN
			SELECT *
            FROM listings
            WHERE price <= param_max_price;
	END IF;

-- //////////////////////////////// VARIANTS WITH TWO INPUTS ///////////////////////////////
-- Borough
   IF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = '' 
		AND param_min_price = 0 
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood;
	
	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0 
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND type = param_type;

	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND price >= param_min_price;
                
	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type = ''
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND price <= param_max_price;
	END IF;

-- Neighbourhood
	IF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0 
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
				AND type = param_type;

	ELSEIF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
				AND price >= param_min_price;
                
	ELSEIF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = ''
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
				AND price <= param_max_price;
	END IF;
    
-- Type    
    IF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings) 
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE type = param_type
				AND price >= param_min_price;
	
	ELSEIF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings) 
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE type = param_type
				AND price <= param_max_price;
	END IF;
                
-- Min Price
    IF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE price >= param_min_price
				AND price <= param_max_price;
	END IF;

-- //////////////////////////////// VARIANTS WITH THREE INPUTS ///////////////////////////////
-- Borough
   IF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0 
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood
                AND type = param_type;
	
	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood
                AND price >= param_min_price;

	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = ''
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood
                AND price <= param_max_price;

	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND type = param_type
                AND price >= param_min_price;

	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND type = param_type
                AND price <= param_max_price;
                
		ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND price >= param_min_price
                AND price <= param_max_price;
	END IF;
                
-- Neighbourhood
   IF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
                AND type = param_type
                AND price >= param_min_price;
	
	ELSEIF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
				AND type = param_type
                AND price <= param_max_price;

	ELSEIF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
				AND price >= param_min_price
                AND price <= param_max_price;
	END IF;

-- Type
   IF param_borough = ''
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE type = param_type
                AND price >= param_min_price
                AND price <= param_max_price;
	END IF;
    
-- //////////////////////////////// VARIANTS WITH FOUR INPUTS ///////////////////////////////
-- Borough
   IF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price = 0 THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood
                AND type = param_type
                AND price >= param_min_price;
	
	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price = 0
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood
                AND type = param_type
                AND price <= param_max_price;

	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type = ''
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND neighbourhood = param_neighbourhood
                AND price >= param_min_price
                AND price <= param_max_price;

	ELSEIF param_borough IN (SELECT DISTINCT borough FROM listings) 
		AND param_neighbourhood = ''
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE borough = param_borough 
				AND type = param_type
                AND price >= param_min_price
                AND price <= param_max_price;

	ELSEIF param_borough = ''
		AND param_neighbourhood IN (SELECT DISTINCT neighbourhood FROM listings)
        AND param_type IN (SELECT DISTINCT type FROM listings)
		AND param_min_price BETWEEN (SELECT MIN(price) FROM listings) AND (SELECT MAX(price) FROM listings)
        AND param_max_price > param_min_price THEN
			SELECT *
            FROM listings
            WHERE neighbourhood = param_neighbourhood
				AND type = param_type
                AND price >= param_min_price
                AND price <= param_max_price;
	END IF;

END$$
DELIMITER ;

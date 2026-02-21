 --1--Trigger Function

CREATE OR REPLACE FUNCTION log_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    
    IF TG_OP = 'INSERT' THEN
        INSERT INTO products_audit (product_id, change_type, new_name, new_price)
        VALUES (NEW.product_id, 'INSERT', NEW.name, NEW.price);
        RETURN NEW;
    END IF;

    
    IF TG_OP = 'DELETE' THEN
        INSERT INTO products_audit (product_id, change_type, old_name, old_price)
        VALUES (OLD.product_id, 'DELETE', OLD.name, OLD.price);
        RETURN OLD;
    END IF;

    
    IF TG_OP = 'UPDATE' THEN
        IF NEW.name IS DISTINCT FROM OLD.name OR NEW.price IS DISTINCT FROM OLD.price THEN
            INSERT INTO products_audit (product_id, change_type, old_name, new_name, old_price, new_price)
            VALUES (OLD.product_id, 'UPDATE', OLD.name, NEW.name, OLD.price, NEW.price);
        END IF;
        RETURN NEW;
    END IF;

    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

--2--Trigger Definition

CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE
ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_changes();


--3--Test Trigger
INSERT INTO products (name, description, price, stock_quantity)
VALUES ('Miniature Thingamabob', 'A very small thingamabob.', 4.99, 500);

UPDATE products
SET price = 225.00, name = 'Mega Gadget v2'
WHERE name = 'Mega Gadget';

UPDATE products
SET description = 'An even simpler gizmo for all your daily tasks.'
WHERE name = 'Basic Gizmo';

DELETE FROM products
WHERE name = 'Super Widget';

--4--Verify the Audit Table
SELECT * FROM products_audit ORDER BY audit_id;

--Bonus
CREATE OR REPLACE FUNCTION set_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_last_modified
BEFORE UPDATE
ON products
FOR EACH ROW
EXECUTE FUNCTION set_last_modified();


UPDATE products
SET price = 10
WHERE name = 'Basic Gizmo';


SELECT * FROM products WHERE name = 'Basic Gizmo';




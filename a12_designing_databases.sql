-- ************ DATA MODELING **************
-- process of creating a model, for the data that you want to store in a database.

-- STEPS:
--      Understand the requirements
--      Build a Conceptual Model - a visual representation of concepts that we use to communicate with the stakesholders so we're both on the same page
--      Build a Logical Model - data structure for storing data
                              -- logical model is an abstract data model that is independent of database technology, it show tables and column that you need.
--      Build a Physical Model



-- ********** CONCEPTUAL MODELS ***************
-- Represents the entities and their relationships

-- Example: Website that is selling a course
-- Concept:
    -- Student
    -- Course 

-- PRIMARY KEYS - use to identify each row in a table
-- FOREIGN KEYS -
-- FOREIGN KEY CONSTRAINTS -
-- NORMALIZATION - is the process of reviewing our design and making sure and it follow a few predefined rules that prevent data duplication.
        -- First Normal Form - Each cell should have a single value and we cannot have repeated columns.
        -- Second Normal Form - Every table should describe one entity, and every column in that table should describe that entity.




-- ************* STORAGE ENGINES **************
SHOW STORAGE ENGINES;

-- *** changing storage engine 
-- InnoDB is default storage engine that supports transactions and other functions.
ALTER TABLE customers
ENGINE = InnoDB;
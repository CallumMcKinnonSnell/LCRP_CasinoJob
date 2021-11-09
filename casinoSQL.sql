SET @job_name = 'casino';
SET @society_name = 'society_casino';
SET @job_Name_Caps = 'Diamond Casino';



INSERT INTO `addon_account` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1),
  ('society_casino_fridge', 'casino (frigo)', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
    (@society_name, @job_Name_Caps, 1)
;

INSERT INTO `jobs` (name, label, whitelisted) VALUES
  (@job_name, @job_Name_Caps, 1)
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
    (@job_name, 0, 'recruit', 'Pit Boy', 1, '{}', '{}'),
    (@job_name, 1, 'employee', 'Croupier', 1, '{}', '{}'),
    (@job_name, 2, 'manager', 'Cashier', 1, '{}', '{}'),
    (@job_name, 3, 'viceboss', 'VIP Dealer', 1, '{}', '{}'),
    (@job_name, 4, 'boss', 'Manager', 1, '{}', '{}'),
    (@job_name, 5, 'boss', 'Owner', 1, '{}', '{}')
;

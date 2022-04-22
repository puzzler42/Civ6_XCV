-- -----------------------------------------------------------------------------
-- EXPANDED CULTURE VICTORY ADVANCED OPTIONS
-- -----------------------------------------------------------------------------
INSERT INTO Parameters (ParameterId, Name, Description, Domain, DefaultValue, ConfigurationGroup, ConfigurationId, GroupId, SortIndex) VALUES
('PARAMETER_XCV', 'LOC_XCV_NAME1', 'LOC_XCV_PARAMETER_DESCRIPTION', 'bool', 1, 'Game', 'CONFIG_XCV', 'GameOptions', 505),
('PARAMETER_XCV_PRODUCTION_MULTIPLIER', 'LOC_XCV_PRODUCTION_MULTIPLIER', 'LOC_XCV_PRODUCTION_MULTIPLIER_DESC', 'uint', 100, 'Game', 'CONFIG_XCV_PRODUCTION_MULTIPLIER', 'GameOptions', 506);
--('PARAMETER_XCV_BONUSES', 'LOC_XCV_BONUSES_NAME', 'LOC_XCV_BONUSES_DESC', 'bool', 1, 'Game', 'CONFIG_XCV_BONUSES', 'GameOptions', 507);

INSERT INTO ParameterCriteria (ParameterId, ConfigurationGroup, ConfigurationId, Operator, ConfigurationValue) VALUES
-- XCV is greyed out if Culture Victory is disabled (it is disabled via lua script)
('PARAMETER_XCV', 'Game', 'VICTORY_CULTURE', 'Equals', 1),
('PARAMETER_XCV_PRODUCTION_MULTIPLIER', 'Game', 'VICTORY_CULTURE', 'Equals', 1),
--('PARAMETER_XCV_BONUSES', 'Game', 'VICTORY_CULTURE', 'Equals', 1),
-- Configurations are greyed out if XCV is disabled
('PARAMETER_XCV_PRODUCTION_MULTIPLIER', 'Game', 'CONFIG_XCV', 'Equals', 1);
--('PARAMETER_XCV_BONUSES', 'Game', 'CONFIG_XCV', 'Equals', 1);






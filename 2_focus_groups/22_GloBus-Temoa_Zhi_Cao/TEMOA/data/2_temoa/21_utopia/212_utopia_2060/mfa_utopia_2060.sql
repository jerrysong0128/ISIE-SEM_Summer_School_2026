PRAGMA foreign_keys = OFF;
BEGIN TRANSACTION;
DROP TABLE IF EXISTS capacity_credit;
DROP TABLE IF EXISTS capacity_factor_process;
DROP TABLE IF EXISTS capacity_factor_tech;
DROP TABLE IF EXISTS capacity_to_activity;
DROP TABLE IF EXISTS commodity;
DROP TABLE IF EXISTS commodity_type;
DROP TABLE IF EXISTS construction_input;
DROP TABLE IF EXISTS cost_emission;
DROP TABLE IF EXISTS cost_fixed;
DROP TABLE IF EXISTS cost_invest;
DROP TABLE IF EXISTS cost_variable;
DROP TABLE IF EXISTS demand;
DROP TABLE IF EXISTS demand_specific_distribution;
DROP TABLE IF EXISTS efficiency;
DROP TABLE IF EXISTS efficiency_variable;
DROP TABLE IF EXISTS emission_activity;
DROP TABLE IF EXISTS emission_embodied;
DROP TABLE IF EXISTS emission_end_of_life;
DROP TABLE IF EXISTS end_of_life_output;
DROP TABLE IF EXISTS existing_capacity;
DROP TABLE IF EXISTS lifetime_process;
DROP TABLE IF EXISTS lifetime_survival_curve;
DROP TABLE IF EXISTS lifetime_tech;
DROP TABLE IF EXISTS limit_activity;
DROP TABLE IF EXISTS limit_activity_share;
DROP TABLE IF EXISTS limit_annual_capacity_factor;
DROP TABLE IF EXISTS limit_capacity;
DROP TABLE IF EXISTS limit_capacity_share;
DROP TABLE IF EXISTS limit_degrowth_capacity;
DROP TABLE IF EXISTS limit_degrowth_new_capacity;
DROP TABLE IF EXISTS limit_degrowth_new_capacity_delta;
DROP TABLE IF EXISTS limit_emission;
DROP TABLE IF EXISTS limit_growth_capacity;
DROP TABLE IF EXISTS limit_growth_new_capacity;
DROP TABLE IF EXISTS limit_growth_new_capacity_delta;
DROP TABLE IF EXISTS limit_new_capacity;
DROP TABLE IF EXISTS limit_new_capacity_share;
DROP TABLE IF EXISTS limit_resource;
DROP TABLE IF EXISTS limit_seasonal_capacity_factor;
DROP TABLE IF EXISTS limit_storage_level_fraction;
DROP TABLE IF EXISTS limit_tech_input_split;
DROP TABLE IF EXISTS limit_tech_input_split_annual;
DROP TABLE IF EXISTS limit_tech_output_split;
DROP TABLE IF EXISTS limit_tech_output_split_annual;
DROP TABLE IF EXISTS linked_tech;
DROP TABLE IF EXISTS loan_lifetime_process;
DROP TABLE IF EXISTS loan_rate;
DROP TABLE IF EXISTS metadata;
DROP TABLE IF EXISTS metadata_real;
DROP TABLE IF EXISTS myopic_efficiency;
DROP TABLE IF EXISTS operator;
DROP TABLE IF EXISTS output_built_capacity;
DROP TABLE IF EXISTS output_cost;
DROP TABLE IF EXISTS output_curtailment;
DROP TABLE IF EXISTS output_dual_variable;
DROP TABLE IF EXISTS output_emission;
DROP TABLE IF EXISTS output_flow_in;
DROP TABLE IF EXISTS output_flow_out;
DROP TABLE IF EXISTS output_flow_out_summary;
DROP TABLE IF EXISTS output_net_capacity;
DROP TABLE IF EXISTS output_objective;
DROP TABLE IF EXISTS output_retired_capacity;
DROP TABLE IF EXISTS output_storage_level;
DROP TABLE IF EXISTS planning_reserve_margin;
DROP TABLE IF EXISTS ramp_down_hourly;
DROP TABLE IF EXISTS ramp_up_hourly;
DROP TABLE IF EXISTS region;
DROP TABLE IF EXISTS reserve_capacity_derate;
DROP TABLE IF EXISTS rps_requirement;
DROP TABLE IF EXISTS sector_label;
DROP TABLE IF EXISTS storage_duration;
DROP TABLE IF EXISTS tech_group;
DROP TABLE IF EXISTS tech_group_member;
DROP TABLE IF EXISTS technology;
DROP TABLE IF EXISTS technology_type;
DROP TABLE IF EXISTS time_of_day;
DROP TABLE IF EXISTS time_period;
DROP TABLE IF EXISTS time_period_type;
DROP TABLE IF EXISTS time_season;
DROP TABLE IF EXISTS time_season_sequential;
CREATE TABLE capacity_credit
(
    region  TEXT,
    period  INTEGER
        REFERENCES time_period (period),
    tech    TEXT
        REFERENCES technology (tech),
    vintage INTEGER,
    credit  REAL,
    notes   TEXT,
    PRIMARY KEY (region, period, tech, vintage),
    CHECK (credit >= 0 AND credit <= 1)
);

CREATE TABLE capacity_factor_process
(
    region  TEXT,
    season TEXT
        REFERENCES time_season (season),
    tod     TEXT
        REFERENCES time_of_day (tod),
    tech    TEXT
        REFERENCES technology (tech),
    vintage INTEGER,
    factor  REAL,
    notes   TEXT,
    PRIMARY KEY (region, season, tod, tech, vintage),
    CHECK (factor >= 0 AND factor <= 1)
);

CREATE TABLE capacity_factor_tech
(
    region TEXT,
    season TEXT
        REFERENCES time_season (season),
    tod    TEXT
        REFERENCES time_of_day (tod),
    tech   TEXT
        REFERENCES technology (tech),
    factor REAL,
    notes  TEXT,
    PRIMARY KEY (region, season, tod, tech),
    CHECK (factor >= 0 AND factor <= 1)
);
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','day','E01',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','day','E21',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','day','E31',0.275,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','day','E51',0.17,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','day','E70',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','night','E01',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','night','E21',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','night','E31',0.275,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','night','E51',0.17,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','inter','night','E70',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','day','E01',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','day','E21',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','day','E31',0.275,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','day','E51',0.17,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','day','E70',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','night','E01',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','night','E21',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','night','E31',0.275,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','night','E51',0.17,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','summer','night','E70',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','day','E01',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','day','E21',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','day','E31',0.275,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','day','E51',0.17,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','day','E70',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','night','E01',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','night','E21',0.8,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','night','E31',0.275,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','night','E51',0.17,'');
INSERT INTO "capacity_factor_tech" VALUES('utopia','winter','night','E70',0.8,'');

CREATE TABLE capacity_to_activity
(
    region TEXT,
    tech   TEXT
        REFERENCES technology (tech),
    c2a    REAL,
    units  TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech)
);
INSERT INTO "capacity_to_activity" VALUES('utopia','E01',31.54,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','E21',31.54,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','E31',31.54,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','E51',31.54,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','E70',31.54,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','RHE',1.0,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','RHO',1.0,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','RL1',1.0,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','SRE',1.0,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','TXD',1.0,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','TXE',1.0,'PJ / (GW * year)','');
INSERT INTO "capacity_to_activity" VALUES('utopia','TXG',1.0,'PJ / (GW * year)','');

CREATE TABLE commodity
(
    name        TEXT
        PRIMARY KEY,
    flag        TEXT
        REFERENCES commodity_type (label),
    description TEXT,
    units       TEXT
);
INSERT INTO "commodity" VALUES('ethos','s','# dummy commodity to supply inputs','PJ');
INSERT INTO "commodity" VALUES('DSL','p','# diesel','PJ');
INSERT INTO "commodity" VALUES('ELC','p','# electricity','PJ');
INSERT INTO "commodity" VALUES('FEQ','p','# fossil equivalent','PJ');
INSERT INTO "commodity" VALUES('GSL','p','# gasoline','PJ');
INSERT INTO "commodity" VALUES('HCO','p','# coal','PJ');
INSERT INTO "commodity" VALUES('HYD','p','# water','PJ');
INSERT INTO "commodity" VALUES('OIL','p','# crude oil','PJ');
INSERT INTO "commodity" VALUES('URN','p','# uranium','PJ');
INSERT INTO "commodity" VALUES('co2','e','#CO2 emissions','Mt');
INSERT INTO "commodity" VALUES('nox','e','#NOX emissions','Mt');
INSERT INTO "commodity" VALUES('RH','d','# residential heating','PJ');
INSERT INTO "commodity" VALUES('RL','d','# residential lighting','PJ');
INSERT INTO "commodity" VALUES('TX','d','# transportation','PJ');

CREATE TABLE commodity_type
(
    label       TEXT
        PRIMARY KEY,
    description TEXT
);
INSERT INTO "commodity_type" VALUES('w','waste commodity');
INSERT INTO "commodity_type" VALUES('wa','waste annual commodity');
INSERT INTO "commodity_type" VALUES('wp','waste physical commodity');
INSERT INTO "commodity_type" VALUES('a','annual commodity');
INSERT INTO "commodity_type" VALUES('s','source commodity');
INSERT INTO "commodity_type" VALUES('p','physical commodity');
INSERT INTO "commodity_type" VALUES('e','emissions commodity');
INSERT INTO "commodity_type" VALUES('d','demand commodity');

CREATE TABLE construction_input
(
    region      TEXT,
    input_comm   TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    PRIMARY KEY (region, input_comm, tech, vintage)
);

CREATE TABLE cost_emission
(
    region    TEXT,
    period    INTEGER
        REFERENCES time_period (period),
    emis_comm TEXT NOT NULL
        REFERENCES commodity (name),
    cost      REAL NOT NULL,
    units     TEXT,
    notes     TEXT,
    PRIMARY KEY (region, period, emis_comm)
);

CREATE TABLE cost_fixed
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL
        REFERENCES time_period (period),
    tech    TEXT    NOT NULL
        REFERENCES technology (tech),
    vintage INTEGER NOT NULL
        REFERENCES time_period (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, period, tech, vintage)
);
INSERT INTO "cost_fixed" VALUES('utopia',2020,'E01',2020,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'E21',2020,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'E31',2020,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'E51',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'E70',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'RHO',2020,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'RL1',2020,9.46,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'TXD',2020,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'TXE',2020,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2020,'TXG',2020,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E01',2020,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E21',2020,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E31',2020,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E51',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E70',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'RHO',2020,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'TXD',2020,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'TXE',2020,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'TXG',2020,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E01',2030,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E21',2030,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E31',2030,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E51',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'E70',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'RHO',2030,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'RL1',2030,9.46,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'TXD',2030,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'TXE',2030,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2030,'TXG',2030,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E01',2020,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E21',2020,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E31',2020,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E51',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E70',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'RHO',2020,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E01',2030,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E21',2030,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E31',2030,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E51',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E70',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'RHO',2030,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'TXD',2030,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'TXE',2030,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'TXG',2030,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E01',2040,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E21',2040,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E31',2040,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E51',2040,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'E70',2040,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'RHO',2040,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'RL1',2040,9.46,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'TXD',2040,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'TXE',2040,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2040,'TXG',2040,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E01',2020,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E21',2020,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E31',2020,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E51',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E70',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E01',2030,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E21',2030,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E31',2030,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E51',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E70',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'RHO',2030,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E01',2040,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E21',2040,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E31',2040,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E51',2040,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E70',2040,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'RHO',2040,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'TXD',2040,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'TXE',2040,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'TXG',2040,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E01',2050,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E21',2050,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E31',2050,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E51',2050,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'E70',2050,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'RHO',2050,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'RL1',2050,9.46,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'TXD',2050,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'TXE',2050,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2050,'TXG',2050,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E31',2020,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E51',2020,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E01',2030,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E21',2030,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E31',2030,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E51',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E70',2030,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E01',2040,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E21',2040,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E31',2040,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E51',2040,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E70',2040,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'RHO',2040,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E01',2050,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E21',2050,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E31',2050,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E51',2050,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E70',2050,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'RHO',2050,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'TXD',2050,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'TXE',2050,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'TXG',2050,48.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E01',2060,100.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E21',2060,500.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E31',2060,75.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E51',2060,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'E70',2060,30.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'RHO',2060,1.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'RL1',2060,9.46,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'TXD',2060,52.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'TXE',2060,80.0,'Mdollar / (PJ^2 / GW / year)','');
INSERT INTO "cost_fixed" VALUES('utopia',2060,'TXG',2060,48.0,'Mdollar / (PJ^2 / GW / year)','');

CREATE TABLE cost_invest
(
    region  TEXT,
    tech    TEXT
        REFERENCES technology (tech),
    vintage INTEGER
        REFERENCES time_period (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, tech, vintage)
);
INSERT INTO "cost_invest" VALUES('utopia','E01',2020,1200.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E21',2020,5000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E31',2020,3000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E51',2020,900.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E70',2020,1000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHE',2020,90.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHO',2020,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','SRE',2020,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXD',2020,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXE',2020,1500.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXG',2020,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E01',2030,1200.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E21',2030,5000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E31',2030,3000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E51',2030,900.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E70',2030,1000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHE',2030,90.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHO',2030,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','SRE',2030,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXD',2030,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXE',2030,1500.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXG',2030,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E01',2040,1200.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E21',2040,5000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E31',2040,3000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E51',2040,900.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E70',2040,1000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHE',2040,90.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHO',2040,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','SRE',2040,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXD',2040,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXE',2040,1500.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXG',2040,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E01',2050,1200.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E21',2050,5000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E31',2050,3000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E51',2050,900.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E70',2050,1000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHE',2050,90.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHO',2050,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','SRE',2050,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXD',2050,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXE',2050,1500.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXG',2050,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E01',2060,1200.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E21',2060,5000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E31',2060,3000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E51',2060,900.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','E70',2060,1000.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHE',2060,90.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','RHO',2060,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','SRE',2060,100.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXD',2060,1044.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXE',2060,1500.0,'Mdollar / (PJ^2 / GW)','');
INSERT INTO "cost_invest" VALUES('utopia','TXG',2060,1044.0,'Mdollar / (PJ^2 / GW)','');

CREATE TABLE cost_variable
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL
        REFERENCES time_period (period),
    tech    TEXT    NOT NULL
        REFERENCES technology (tech),
    vintage INTEGER NOT NULL
        REFERENCES time_period (period),
    cost    REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, period, tech, vintage)
);
INSERT INTO "cost_variable" VALUES('utopia',2020,'E01',2020,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'E21',2020,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'E70',2020,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'IMPDSL1',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'IMPGSL1',2020,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'IMPHCO1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'IMPOIL1',2020,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'IMPURN1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2020,'SRE',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'E01',2020,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'E21',2020,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'E70',2020,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPDSL1',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPGSL1',2020,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPHCO1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPOIL1',2020,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPURN1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'SRE',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'E01',2030,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'E21',2030,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'E70',2030,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPDSL1',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPGSL1',2030,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPHCO1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPOIL1',2030,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'IMPURN1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2030,'SRE',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E01',2020,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E21',2020,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E70',2020,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPDSL1',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPGSL1',2020,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPHCO1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPOIL1',2020,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPURN1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'SRE',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E01',2030,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E21',2030,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E70',2030,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPDSL1',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPGSL1',2030,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPHCO1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPOIL1',2030,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPURN1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'SRE',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E01',2040,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E21',2040,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'E70',2040,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPDSL1',2040,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPGSL1',2040,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPHCO1',2040,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPOIL1',2040,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'IMPURN1',2040,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2040,'SRE',2040,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E01',2020,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E21',2020,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E70',2020,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPDSL1',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPGSL1',2020,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPHCO1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPOIL1',2020,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPURN1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'SRE',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E01',2030,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E21',2030,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E70',2030,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPDSL1',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPGSL1',2030,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPHCO1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPOIL1',2030,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPURN1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'SRE',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E01',2040,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E21',2040,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E70',2040,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPDSL1',2040,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPGSL1',2040,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPHCO1',2040,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPOIL1',2040,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPURN1',2040,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'SRE',2040,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E01',2050,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E21',2050,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'E70',2050,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPDSL1',2050,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPGSL1',2050,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPHCO1',2050,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPOIL1',2050,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'IMPURN1',2050,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2050,'SRE',2050,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPDSL1',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPGSL1',2020,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPHCO1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPOIL1',2020,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPURN1',2020,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'SRE',2020,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E01',2030,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E21',2030,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E70',2030,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPDSL1',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPGSL1',2030,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPHCO1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPOIL1',2030,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPURN1',2030,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'SRE',2030,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E01',2040,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E21',2040,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E70',2040,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPDSL1',2040,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPGSL1',2040,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPHCO1',2040,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPOIL1',2040,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPURN1',2040,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'SRE',2040,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E01',2050,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E21',2050,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E70',2050,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPDSL1',2050,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPGSL1',2050,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPHCO1',2050,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPOIL1',2050,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPURN1',2050,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'SRE',2050,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E01',2060,0.3,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E21',2060,1.5,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'E70',2060,0.4,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPDSL1',2060,10.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPGSL1',2060,15.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPHCO1',2060,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPOIL1',2060,8.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'IMPURN1',2060,2.0,'Mdollar / (PJ)','');
INSERT INTO "cost_variable" VALUES('utopia',2060,'SRE',2060,10.0,'Mdollar / (PJ)','');

CREATE TABLE demand
(
    region    TEXT,
    period    INTEGER
        REFERENCES time_period (period),
    commodity TEXT
        REFERENCES commodity (name),
    demand    REAL,
    units     TEXT,
    notes     TEXT,
    PRIMARY KEY (region, period, commodity)
);
INSERT INTO "demand" VALUES('utopia',2020,'RH',38.7,'PJ','');
INSERT INTO "demand" VALUES('utopia',2020,'RL',8.6,'PJ','');
INSERT INTO "demand" VALUES('utopia',2020,'TX',7.982,'PJ','');
INSERT INTO "demand" VALUES('utopia',2030,'RH',43.2,'PJ','');
INSERT INTO "demand" VALUES('utopia',2030,'RL',9.6,'PJ','');
INSERT INTO "demand" VALUES('utopia',2030,'TX',8.909,'PJ','');
INSERT INTO "demand" VALUES('utopia',2040,'RH',47.7,'PJ','');
INSERT INTO "demand" VALUES('utopia',2040,'RL',10.6,'PJ','');
INSERT INTO "demand" VALUES('utopia',2040,'TX',9.836,'PJ','');
INSERT INTO "demand" VALUES('utopia',2050,'RH',52.2,'PJ','');
INSERT INTO "demand" VALUES('utopia',2050,'RL',11.6,'PJ','');
INSERT INTO "demand" VALUES('utopia',2050,'TX',10.763,'PJ','');
INSERT INTO "demand" VALUES('utopia',2060,'RH',56.7,'PJ','');
INSERT INTO "demand" VALUES('utopia',2060,'RL',12.6,'PJ','');
INSERT INTO "demand" VALUES('utopia',2060,'TX',11.69,'PJ','');

CREATE TABLE demand_specific_distribution
(
    region      TEXT,
    period      INTEGER
        REFERENCES time_period (period),
    season TEXT
        REFERENCES time_season (season),
    tod         TEXT
        REFERENCES time_of_day (tod),
    demand_name TEXT
        REFERENCES commodity (name),
    dsd         REAL,
    notes       TEXT,
    PRIMARY KEY (region, period, season, tod, demand_name),
    CHECK (dsd >= 0 AND dsd <= 1)
);
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'inter','day','RH',0.12,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'inter','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'inter','night','RH',0.06,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'inter','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'summer','day','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'summer','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'summer','night','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'summer','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'winter','day','RH',0.4133,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'winter','day','RL',0.5,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'winter','night','RH',0.2067,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2020,'winter','night','RL',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'inter','day','RH',0.12,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'inter','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'inter','night','RH',0.06,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'inter','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'summer','day','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'summer','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'summer','night','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'summer','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'winter','day','RH',0.4133,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'winter','day','RL',0.5,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'winter','night','RH',0.2067,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2030,'winter','night','RL',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'inter','day','RH',0.12,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'inter','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'inter','night','RH',0.06,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'inter','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'summer','day','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'summer','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'summer','night','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'summer','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'winter','day','RH',0.4133,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'winter','day','RL',0.5,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'winter','night','RH',0.2067,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2040,'winter','night','RL',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'inter','day','RH',0.12,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'inter','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'inter','night','RH',0.06,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'inter','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'summer','day','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'summer','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'summer','night','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'summer','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'winter','day','RH',0.4133,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'winter','day','RL',0.5,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'winter','night','RH',0.2067,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2050,'winter','night','RL',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'inter','day','RH',0.12,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'inter','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'inter','night','RH',0.06,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'inter','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'summer','day','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'summer','day','RL',0.15,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'summer','night','RH',0.1,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'summer','night','RL',0.05,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'winter','day','RH',0.4133,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'winter','day','RL',0.5,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'winter','night','RH',0.2067,'');
INSERT INTO "demand_specific_distribution" VALUES('utopia',2060,'winter','night','RL',0.1,'');

CREATE TABLE efficiency
(
    region      TEXT,
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    efficiency  REAL,
    units       TEXT,
    notes       TEXT,
    PRIMARY KEY (region, input_comm, tech, vintage, output_comm),
    CHECK (efficiency > 0)
);
INSERT INTO "efficiency" VALUES('utopia','DSL','E70',2020,'ELC',0.294,'PJ / (PJ)','# 1/3.4');
INSERT INTO "efficiency" VALUES('utopia','DSL','RHO',2020,'RH',0.7,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','DSL','TXD',2020,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','E51',2020,'ELC',0.72,'PJ / (PJ)','# 1/1.3889');
INSERT INTO "efficiency" VALUES('utopia','ELC','RHE',2020,'RH',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','RL1',2020,'RL',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','TXE',2020,'TX',0.827,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','FEQ','E21',2020,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','GSL','TXG',2020,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','HCO','E01',2020,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','HYD','E31',2020,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2020,'DSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2020,'GSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','URN','E21',2020,'ELC',0.4,'PJ / (PJ)','# 1/2.5');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPDSL1',2020,'DSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPFEQ',2020,'FEQ',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPGSL1',2020,'GSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHCO1',2020,'HCO',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHYD',2020,'HYD',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPOIL1',2020,'OIL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPURN1',2020,'URN',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ELC','E51',1980,'ELC',0.72,'PJ / (PJ)','# keep existing-cap E51 alive into future');
INSERT INTO "efficiency" VALUES('utopia','HYD','E31',1980,'ELC',0.32,'PJ / (PJ)','# keep existing-cap E31 alive into future');
INSERT INTO "efficiency" VALUES('utopia','DSL','E70',2030,'ELC',0.294,'PJ / (PJ)','# 1/3.4');
INSERT INTO "efficiency" VALUES('utopia','DSL','RHO',2030,'RH',0.7,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','DSL','TXD',2030,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','E51',2030,'ELC',0.72,'PJ / (PJ)','# 1/1.3889');
INSERT INTO "efficiency" VALUES('utopia','ELC','RHE',2030,'RH',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','RL1',2030,'RL',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','TXE',2030,'TX',0.827,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','FEQ','E21',2030,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','GSL','TXG',2030,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','HCO','E01',2030,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','HYD','E31',2030,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2030,'DSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2030,'GSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','URN','E21',2030,'ELC',0.4,'PJ / (PJ)','# 1/2.5');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPDSL1',2030,'DSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPFEQ',2030,'FEQ',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPGSL1',2030,'GSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHCO1',2030,'HCO',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHYD',2030,'HYD',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPOIL1',2030,'OIL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPURN1',2030,'URN',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','DSL','E70',2040,'ELC',0.294,'PJ / (PJ)','# 1/3.4');
INSERT INTO "efficiency" VALUES('utopia','DSL','RHO',2040,'RH',0.7,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','DSL','TXD',2040,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','E51',2040,'ELC',0.72,'PJ / (PJ)','# 1/1.3889');
INSERT INTO "efficiency" VALUES('utopia','ELC','RHE',2040,'RH',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','RL1',2040,'RL',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','TXE',2040,'TX',0.827,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','FEQ','E21',2040,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','GSL','TXG',2040,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','HCO','E01',2040,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','HYD','E31',2040,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2040,'DSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2040,'GSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','URN','E21',2040,'ELC',0.4,'PJ / (PJ)','# 1/2.5');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPDSL1',2040,'DSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPFEQ',2040,'FEQ',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPGSL1',2040,'GSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHCO1',2040,'HCO',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHYD',2040,'HYD',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPOIL1',2040,'OIL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPURN1',2040,'URN',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','DSL','E70',2050,'ELC',0.294,'PJ / (PJ)','# 1/3.4');
INSERT INTO "efficiency" VALUES('utopia','DSL','RHO',2050,'RH',0.7,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','DSL','TXD',2050,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','E51',2050,'ELC',0.72,'PJ / (PJ)','# 1/1.3889');
INSERT INTO "efficiency" VALUES('utopia','ELC','RHE',2050,'RH',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','RL1',2050,'RL',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','TXE',2050,'TX',0.827,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','FEQ','E21',2050,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','GSL','TXG',2050,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','HCO','E01',2050,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','HYD','E31',2050,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2050,'DSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2050,'GSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','URN','E21',2050,'ELC',0.4,'PJ / (PJ)','# 1/2.5');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPDSL1',2050,'DSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPFEQ',2050,'FEQ',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPGSL1',2050,'GSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHCO1',2050,'HCO',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHYD',2050,'HYD',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPOIL1',2050,'OIL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPURN1',2050,'URN',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','DSL','E70',2060,'ELC',0.294,'PJ / (PJ)','# 1/3.4');
INSERT INTO "efficiency" VALUES('utopia','DSL','RHO',2060,'RH',0.7,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','DSL','TXD',2060,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','E51',2060,'ELC',0.72,'PJ / (PJ)','# 1/1.3889');
INSERT INTO "efficiency" VALUES('utopia','ELC','RHE',2060,'RH',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','RL1',2060,'RL',1.0,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','ELC','TXE',2060,'TX',0.827,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','FEQ','E21',2060,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','GSL','TXG',2060,'TX',0.231,'PJ / (PJ)','# direct translation from DMD_EFF');
INSERT INTO "efficiency" VALUES('utopia','HCO','E01',2060,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','HYD','E31',2060,'ELC',0.32,'PJ / (PJ)','# 1/3.125');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2060,'DSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','OIL','SRE',2060,'GSL',1.0,'PJ / (PJ)','# direct translation from PRC_INP2, PRC_OUT');
INSERT INTO "efficiency" VALUES('utopia','URN','E21',2060,'ELC',0.4,'PJ / (PJ)','# 1/2.5');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPDSL1',2060,'DSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPFEQ',2060,'FEQ',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPGSL1',2060,'GSL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHCO1',2060,'HCO',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPHYD',2060,'HYD',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPOIL1',2060,'OIL',1.0,'PJ / (PJ)','');
INSERT INTO "efficiency" VALUES('utopia','ethos','IMPURN1',2060,'URN',1.0,'PJ / (PJ)','');

CREATE TABLE efficiency_variable
(
    region      TEXT,
    season TEXT
        REFERENCES time_season (season),
    tod         TEXT
        REFERENCES time_of_day (tod),
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    efficiency  REAL,
    notes       TEXT,
    PRIMARY KEY (region, season, tod, input_comm, tech, vintage, output_comm),
    CHECK (efficiency > 0)
);

CREATE TABLE emission_activity
(
    region      TEXT,
    emis_comm   TEXT
        REFERENCES commodity (name),
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    activity    REAL,
    units       TEXT,
    notes       TEXT,
    PRIMARY KEY (region, emis_comm, input_comm, tech, vintage, output_comm)
);
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPDSL1',2020,'DSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPGSL1',2020,'GSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPHCO1',2020,'HCO',0.089,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPOIL1',2020,'OIL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','DSL','TXD',2020,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','GSL','TXG',2020,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPDSL1',2030,'DSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPGSL1',2030,'GSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPHCO1',2030,'HCO',0.089,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPOIL1',2030,'OIL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','DSL','TXD',2030,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','GSL','TXG',2030,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPDSL1',2040,'DSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPGSL1',2040,'GSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPHCO1',2040,'HCO',0.089,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPOIL1',2040,'OIL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','DSL','TXD',2040,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','GSL','TXG',2040,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPDSL1',2050,'DSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPGSL1',2050,'GSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPHCO1',2050,'HCO',0.089,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPOIL1',2050,'OIL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','DSL','TXD',2050,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','GSL','TXG',2050,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPDSL1',2060,'DSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPGSL1',2060,'GSL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPHCO1',2060,'HCO',0.089,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','co2','ethos','IMPOIL1',2060,'OIL',0.075,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','DSL','TXD',2060,'TX',1.0,'Mt / (PJ)','');
INSERT INTO "emission_activity" VALUES('utopia','nox','GSL','TXG',2060,'TX',1.0,'Mt / (PJ)','');

CREATE TABLE emission_embodied
(
    region      TEXT,
    emis_comm   TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    PRIMARY KEY (region, emis_comm, tech, vintage)
);

CREATE TABLE emission_end_of_life
(
    region      TEXT,
    emis_comm   TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    PRIMARY KEY (region, emis_comm, tech, vintage)
);

CREATE TABLE end_of_life_output
(
    region      TEXT,
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm   TEXT
        REFERENCES commodity (name),
    value       REAL,
    units       TEXT,
    notes       TEXT,
    PRIMARY KEY (region, tech, vintage, output_comm)
);

CREATE TABLE existing_capacity
(
    region   TEXT,
    tech     TEXT
        REFERENCES technology (tech),
    vintage  INTEGER
        REFERENCES time_period (period),
    capacity REAL,
    units    TEXT,
    notes    TEXT,
    PRIMARY KEY (region, tech, vintage)
);
INSERT INTO "existing_capacity" VALUES('utopia','E01',1960,0.1,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E70',1960,0.03,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E01',1970,0.15,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E70',1970,0.05,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','RHO',1970,12.5,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','TXD',1970,0.2,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','TXG',1970,1.2,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E01',1980,0.2,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E31',1980,0.1,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E51',1980,0.5,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','E70',1980,0.07,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','RHO',1980,13.5,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','RL1',1980,5.6,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','TXD',1980,0.4,'GW','');
INSERT INTO "existing_capacity" VALUES('utopia','TXG',1980,1.5,'GW','');

CREATE TABLE lifetime_process
(
    region   TEXT,
    tech     TEXT
        REFERENCES technology (tech),
    vintage  INTEGER
        REFERENCES time_period (period),
    lifetime REAL,
    units    TEXT,
    notes    TEXT,
    PRIMARY KEY (region, tech, vintage)
);

CREATE TABLE lifetime_survival_curve
(
    region  TEXT    NOT NULL,
    period  INTEGER NOT NULL,
    tech    TEXT    NOT NULL
        REFERENCES technology (tech),
    vintage INTEGER NOT NULL
        REFERENCES time_period (period),
    fraction  REAL,
    notes   TEXT,
    PRIMARY KEY (region, period, tech, vintage)
);

CREATE TABLE lifetime_tech
(
    region   TEXT,
    tech     TEXT
        REFERENCES technology (tech),
    lifetime REAL,
    units    TEXT,
    notes    TEXT,
    PRIMARY KEY (region, tech)
);
INSERT INTO "lifetime_tech" VALUES('utopia','E01',40.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','E21',40.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','E31',100.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','E51',100.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','E70',40.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPDSL1',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPFEQ',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPGSL1',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPHCO1',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPHYD',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPOIL1',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','IMPURN1',1000.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','RHE',30.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','RHO',30.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','RL1',10.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','SRE',50.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','TXD',15.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','TXE',15.0,'year','');
INSERT INTO "lifetime_tech" VALUES('utopia','TXG',15.0,'year','');

CREATE TABLE limit_activity
(
    region  TEXT,
    period  INTEGER
        REFERENCES time_period (period),
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    activity REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, period, tech_or_group, operator)
);

CREATE TABLE limit_activity_share
(
    region         TEXT,
    period         INTEGER
        REFERENCES time_period (period),
    sub_group      TEXT,
    super_group    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    share REAL,
    notes          TEXT,
    PRIMARY KEY (region, period, sub_group, super_group, operator)
);

CREATE TABLE limit_annual_capacity_factor
(
    region      TEXT,
    tech_or_group        TEXT,
    vintage      INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    factor      REAL,
    notes       TEXT,
    PRIMARY KEY (region, tech_or_group, vintage, output_comm, operator),
    CHECK (factor >= 0 AND factor <= 1)
);

CREATE TABLE limit_capacity
(
    region  TEXT,
    period  INTEGER
        REFERENCES time_period (period),
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    capacity REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, period, tech_or_group, operator)
);
INSERT INTO "limit_capacity" VALUES('utopia',2060,'E31','ge',0.13,'GW','');
INSERT INTO "limit_capacity" VALUES('utopia',2060,'E31','le',0.21,'GW','');
INSERT INTO "limit_capacity" VALUES('utopia',2060,'RHE','le',0.0,'GW','');
INSERT INTO "limit_capacity" VALUES('utopia',2060,'SRE','ge',0.1,'GW','');
INSERT INTO "limit_capacity" VALUES('utopia',2060,'TXD','le',4.76,'GW','');

CREATE TABLE limit_capacity_share
(
    region         TEXT,
    period         INTEGER
        REFERENCES time_period (period),
    sub_group      TEXT,
    super_group    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    share REAL,
    notes          TEXT,
    PRIMARY KEY (region, period, sub_group, super_group, operator)
);

CREATE TABLE limit_degrowth_capacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_degrowth_new_capacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_degrowth_new_capacity_delta
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_emission
(
    region    TEXT,
    period    INTEGER
        REFERENCES time_period (period),
    emis_comm TEXT
        REFERENCES commodity (name),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    value     REAL,
    units     TEXT,
    notes     TEXT,
    PRIMARY KEY (region, period, emis_comm, operator)
);

CREATE TABLE limit_growth_capacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_growth_new_capacity
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_growth_new_capacity_delta
(
    region TEXT,
    tech_or_group   TEXT,
    operator TEXT NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    rate   REAL NOT NULL DEFAULT 0,
    seed   REAL NOT NULL DEFAULT 0,
    seed_units TEXT,
    notes  TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_new_capacity
(
    region  TEXT,
    tech_or_group   TEXT,
    vintage  INTEGER
        REFERENCES time_period (period),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    new_cap REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, tech_or_group, vintage, operator)
);

CREATE TABLE limit_new_capacity_share
(
    region         TEXT,
    sub_group      TEXT,
    super_group    TEXT,
    vintage         INTEGER
        REFERENCES time_period (period),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    share REAL,
    notes          TEXT,
    PRIMARY KEY (region, sub_group, super_group, vintage, operator)
);

CREATE TABLE limit_resource
(
    region  TEXT,
    tech_or_group   TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    cum_act REAL,
    units   TEXT,
    notes   TEXT,
    PRIMARY KEY (region, tech_or_group, operator)
);

CREATE TABLE limit_seasonal_capacity_factor
(
	region  TEXT
        REFERENCES region (region),
	season TEXT
        REFERENCES time_season (season),
	tech_or_group    TEXT,
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
	factor	REAL,
	notes	TEXT,
	PRIMARY KEY(region, season, tech_or_group, operator)
);

CREATE TABLE limit_storage_level_fraction
(
    region   TEXT,
    season TEXT,
    tod      TEXT
        REFERENCES time_of_day (tod),
    tech     TEXT
        REFERENCES technology (tech),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    fraction REAL,
    notes    TEXT,
    CHECK (fraction >= 0 AND fraction <= 1),
    PRIMARY KEY(region, season, tod, tech, operator)
);

CREATE TABLE limit_tech_input_split
(
    region         TEXT,
    period         INTEGER
        REFERENCES time_period (period),
    input_comm     TEXT
        REFERENCES commodity (name),
    tech           TEXT
        REFERENCES technology (tech),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    proportion REAL,
    notes          TEXT,
    PRIMARY KEY (region, period, input_comm, tech, operator)
);

CREATE TABLE limit_tech_input_split_annual
(
    region         TEXT,
    period         INTEGER
        REFERENCES time_period (period),
    input_comm     TEXT
        REFERENCES commodity (name),
    tech           TEXT
        REFERENCES technology (tech),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    proportion REAL,
    notes          TEXT,
    PRIMARY KEY (region, period, input_comm, tech, operator)
);

CREATE TABLE limit_tech_output_split
(
    region         TEXT,
    period         INTEGER
        REFERENCES time_period (period),
    tech           TEXT
        REFERENCES technology (tech),
    output_comm    TEXT
        REFERENCES commodity (name),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    proportion REAL,
    notes          TEXT,
    PRIMARY KEY (region, period, tech, output_comm, operator)
);
INSERT INTO "limit_tech_output_split" VALUES('utopia',2030,'SRE','GSL','ge',0.3,'');
INSERT INTO "limit_tech_output_split" VALUES('utopia',2040,'SRE','GSL','ge',0.3,'');
INSERT INTO "limit_tech_output_split" VALUES('utopia',2050,'SRE','GSL','ge',0.3,'');
INSERT INTO "limit_tech_output_split" VALUES('utopia',2060,'SRE','DSL','ge',0.7,'');
INSERT INTO "limit_tech_output_split" VALUES('utopia',2060,'SRE','GSL','ge',0.3,'');

CREATE TABLE limit_tech_output_split_annual
(
    region         TEXT,
    period         INTEGER
        REFERENCES time_period (period),
    tech           TEXT
        REFERENCES technology (tech),
    output_comm    TEXT
        REFERENCES commodity (name),
    operator	TEXT  NOT NULL DEFAULT "le"
    	REFERENCES operator (operator),
    proportion REAL,
    notes          TEXT,
    PRIMARY KEY (region, period, tech, output_comm, operator)
);

CREATE TABLE linked_tech
(
    primary_region TEXT,
    primary_tech   TEXT
        REFERENCES technology (tech),
    emis_comm      TEXT
        REFERENCES commodity (name),
    driven_tech    TEXT
        REFERENCES technology (tech),
    notes          TEXT,
    PRIMARY KEY (primary_region, primary_tech, emis_comm)
);

CREATE TABLE loan_lifetime_process
(
    region   TEXT,
    tech     TEXT
        REFERENCES technology (tech),
    vintage  INTEGER
        REFERENCES time_period (period),
    lifetime REAL,
    units    TEXT,
    notes    TEXT,
    PRIMARY KEY (region, tech, vintage)
);

CREATE TABLE loan_rate
(
    region  TEXT,
    tech    TEXT
        REFERENCES technology (tech),
    vintage INTEGER
        REFERENCES time_period (period),
    rate    REAL,
    notes   TEXT,
    PRIMARY KEY (region, tech, vintage)
);

CREATE TABLE metadata
(
    element TEXT,
    value   INT,
    notes   TEXT,
    PRIMARY KEY (element)
);
INSERT INTO "metadata" VALUES('DB_MAJOR',4,'');
INSERT INTO "metadata" VALUES('DB_MINOR',0,'');

CREATE TABLE metadata_real
(
    element TEXT,
    value   REAL,
    notes   TEXT,

    PRIMARY KEY (element)
);
INSERT INTO "metadata_real" VALUES('default_loan_rate',0.05,'Default Loan Rate if not specified in loan_rate table');
INSERT INTO "metadata_real" VALUES('global_discount_rate',0.05,'');

CREATE TABLE myopic_efficiency
(
    base_year   integer,
    region      text,
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    efficiency  real,
    lifetime    integer,
    PRIMARY KEY (region, input_comm, tech, vintage, output_comm)
);

CREATE TABLE operator
(
	operator TEXT PRIMARY KEY,
	notes TEXT
);
INSERT INTO "operator" VALUES('e','equal to');
INSERT INTO "operator" VALUES('ge','greater than or equal to');
INSERT INTO "operator" VALUES('le','less than or equal to');

CREATE TABLE output_built_capacity
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT
        REFERENCES sector_label (sector),
    tech     TEXT
        REFERENCES technology (tech),
    vintage  INTEGER
        REFERENCES time_period (period),
    capacity REAL,
    units    TEXT,
    PRIMARY KEY (region, scenario, tech, vintage)
);

CREATE TABLE output_cost
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT REFERENCES sector_label (sector),
    period   INTEGER REFERENCES time_period (period),
    tech     TEXT REFERENCES technology (tech),
    vintage  INTEGER REFERENCES time_period (period),
    d_invest REAL,
    d_fixed  REAL,
    d_var    REAL,
    d_emiss  REAL,
    invest   REAL,
    fixed    REAL,
    var      REAL,
    emiss    REAL,
    units    TEXT,
    PRIMARY KEY (scenario, region, period, tech, vintage),
    FOREIGN KEY (vintage) REFERENCES time_period (period),
    FOREIGN KEY (tech) REFERENCES technology (tech)
);

CREATE TABLE output_curtailment
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT,
    period      INTEGER
        REFERENCES time_period (period),
    season      TEXT
        REFERENCES time_season (season),
    tod         TEXT
        REFERENCES time_of_day (tod),
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    curtailment REAL,
    units       TEXT,
    PRIMARY KEY (region, scenario, period, season, tod, input_comm, tech, vintage, output_comm)
);

CREATE TABLE output_dual_variable
(
    scenario        TEXT,
    constraint_name TEXT,
    dual            REAL,
    PRIMARY KEY (constraint_name, scenario)
);

CREATE TABLE output_emission
(
    scenario  TEXT,
    region    TEXT,
    sector    TEXT
        REFERENCES sector_label (sector),
    period    INTEGER
        REFERENCES time_period (period),
    emis_comm TEXT
        REFERENCES commodity (name),
    tech      TEXT
        REFERENCES technology (tech),
    vintage   INTEGER
        REFERENCES time_period (period),
    emission  REAL,
    units     TEXT,
    PRIMARY KEY (region, scenario, period, emis_comm, tech, vintage)
);

CREATE TABLE output_flow_in
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT
        REFERENCES sector_label (sector),
    period      INTEGER
        REFERENCES time_period (period),
    season TEXT
        REFERENCES time_season (season),
    tod         TEXT
        REFERENCES time_of_day (tod),
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    flow        REAL,
    units       TEXT,
    PRIMARY KEY (region, scenario, period, season, tod, input_comm, tech, vintage, output_comm)
);

CREATE TABLE output_flow_out
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT
        REFERENCES sector_label (sector),
    period      INTEGER
        REFERENCES time_period (period),
    season TEXT
        REFERENCES time_season (season),
    tod         TEXT
        REFERENCES time_of_day (tod),
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    flow        REAL,
    units       TEXT,
    PRIMARY KEY (region, scenario, period, season, tod, input_comm, tech, vintage, output_comm)
);

CREATE TABLE output_flow_out_summary
(
    scenario    TEXT,
    region      TEXT,
    sector      TEXT
        REFERENCES sector_label (sector),
    period      INTEGER
        REFERENCES time_period (period),
    input_comm  TEXT
        REFERENCES commodity (name),
    tech        TEXT
        REFERENCES technology (tech),
    vintage     INTEGER
        REFERENCES time_period (period),
    output_comm TEXT
        REFERENCES commodity (name),
    flow        REAL,
    PRIMARY KEY (scenario, region, period, input_comm, tech, vintage, output_comm)
);

CREATE TABLE output_net_capacity
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT
        REFERENCES sector_label (sector),
    period   INTEGER
        REFERENCES time_period (period),
    tech     TEXT
        REFERENCES technology (tech),
    vintage  INTEGER
        REFERENCES time_period (period),
    capacity REAL,
    units    TEXT,
    PRIMARY KEY (region, scenario, period, tech, vintage)
);

CREATE TABLE output_objective
(
    scenario          TEXT,
    objective_name    TEXT,
    total_system_cost REAL
);

CREATE TABLE output_retired_capacity
(
    scenario TEXT,
    region   TEXT,
    sector   TEXT
        REFERENCES sector_label (sector),
    period   INTEGER
        REFERENCES time_period (period),
    tech     TEXT
        REFERENCES technology (tech),
    vintage  INTEGER
        REFERENCES time_period (period),
    cap_eol REAL,
    cap_early REAL,
    units     TEXT,
    PRIMARY KEY (region, scenario, period, tech, vintage)
);

CREATE TABLE output_storage_level
(
    scenario TEXT,
    region TEXT,
    sector TEXT
        REFERENCES sector_label (sector),
    period INTEGER
        REFERENCES time_period (period),
    season TEXT,
    tod TEXT
        REFERENCES time_of_day (tod),
    tech TEXT
        REFERENCES technology (tech),
    vintage INTEGER
        REFERENCES time_period (period),
    level REAL,
    units TEXT,
    PRIMARY KEY (scenario, region, period, season, tod, tech, vintage)
);

CREATE TABLE planning_reserve_margin
(
    region TEXT
        PRIMARY KEY
        REFERENCES region (region),
    margin REAL,
    notes TEXT
);

CREATE TABLE ramp_down_hourly
(
    region TEXT,
    tech   TEXT
        REFERENCES technology (tech),
    rate   REAL,
    notes TEXT,
    PRIMARY KEY (region, tech)
);

CREATE TABLE ramp_up_hourly
(
    region TEXT,
    tech   TEXT
        REFERENCES technology (tech),
    rate   REAL,
    notes TEXT,
    PRIMARY KEY (region, tech)
);

CREATE TABLE region
(
    region TEXT
        PRIMARY KEY,
    notes  TEXT
);
INSERT INTO "region" VALUES('utopia',NULL);

CREATE TABLE reserve_capacity_derate
(
    region  TEXT,
    season  TEXT
    	REFERENCES time_season (season),
    tech    TEXT
        REFERENCES technology (tech),
    vintage INTEGER,
    factor  REAL,
    notes   TEXT,
    PRIMARY KEY (region, season, tech, vintage),
    CHECK (factor >= 0 AND factor <= 1)
);

CREATE TABLE rps_requirement
(
    region      TEXT    NOT NULL
        REFERENCES region (region),
    period      INTEGER NOT NULL
        REFERENCES time_period (period),
    tech_group  TEXT    NOT NULL
        REFERENCES tech_group (group_name),
    requirement REAL    NOT NULL,
    notes       TEXT
);

CREATE TABLE sector_label
(
    sector TEXT PRIMARY KEY,
    notes  TEXT
);
INSERT INTO "sector_label" VALUES('supply',NULL);
INSERT INTO "sector_label" VALUES('electric',NULL);
INSERT INTO "sector_label" VALUES('transport',NULL);
INSERT INTO "sector_label" VALUES('commercial',NULL);
INSERT INTO "sector_label" VALUES('residential',NULL);
INSERT INTO "sector_label" VALUES('industrial',NULL);

CREATE TABLE storage_duration
(
    region   TEXT,
    tech     TEXT,
    duration REAL,
    notes    TEXT,
    PRIMARY KEY (region, tech)
);

CREATE TABLE tech_group
(
    group_name TEXT
        PRIMARY KEY,
    notes      TEXT
);

CREATE TABLE tech_group_member
(
    group_name TEXT
        REFERENCES tech_group (group_name),
    tech       TEXT
        REFERENCES technology (tech),
    PRIMARY KEY (group_name, tech)
);

CREATE TABLE technology
(
    tech         TEXT    NOT NULL PRIMARY KEY,
    flag         TEXT    NOT NULL,
    sector       TEXT,
    category     TEXT,
    sub_category TEXT,
    unlim_cap    INTEGER NOT NULL DEFAULT 0,
    annual       INTEGER NOT NULL DEFAULT 0,
    reserve      INTEGER NOT NULL DEFAULT 0,
    curtail      INTEGER NOT NULL DEFAULT 0,
    retire       INTEGER NOT NULL DEFAULT 0,
    flex         INTEGER NOT NULL DEFAULT 0,
    exchange     INTEGER NOT NULL DEFAULT 0,
    seas_stor    INTEGER NOT NULL DEFAULT 0,
    description  TEXT,
    FOREIGN KEY (flag) REFERENCES technology_type (label)
);
INSERT INTO "technology" VALUES('E01','pb','electric','coal','',0,0,0,0,0,0,0,0,' coal power plant');
INSERT INTO "technology" VALUES('E21','pb','electric','nuclear','',0,0,0,0,0,0,0,0,' nuclear power plant');
INSERT INTO "technology" VALUES('E31','pb','electric','hydro','',0,0,0,0,0,0,0,0,' hydro power');
INSERT INTO "technology" VALUES('E51','ps','electric','electric','',0,0,0,0,0,0,0,0,' electric storage');
INSERT INTO "technology" VALUES('E70','p','electric','petroleum','',0,0,0,0,0,0,0,0,' diesel power plant');
INSERT INTO "technology" VALUES('IMPDSL1','p','supply','petroleum','',1,0,0,0,0,0,0,0,' imported diesel');
INSERT INTO "technology" VALUES('IMPFEQ','p','supply','petroleum','',1,0,0,0,0,0,0,0,' imported fossil equivalent');
INSERT INTO "technology" VALUES('IMPGSL1','p','supply','petroleum','',1,0,0,0,0,0,0,0,' imported gasoline');
INSERT INTO "technology" VALUES('IMPHCO1','p','supply','coal','',1,0,0,0,0,0,0,0,' imported coal');
INSERT INTO "technology" VALUES('IMPHYD','p','supply','hydro','',1,0,0,0,0,0,0,0,' imported water -- doesnt exist in Utopia');
INSERT INTO "technology" VALUES('IMPOIL1','p','supply','petroleum','',1,0,0,0,0,0,0,0,' imported crude oil');
INSERT INTO "technology" VALUES('IMPURN1','p','supply','nuclear','',1,0,0,0,0,0,0,0,' imported uranium');
INSERT INTO "technology" VALUES('RHE','p','residential','electric','',0,0,0,0,0,0,0,0,' electric residential heating');
INSERT INTO "technology" VALUES('RHO','p','residential','petroleum','',0,0,0,0,0,0,0,0,' diesel residential heating');
INSERT INTO "technology" VALUES('RL1','p','residential','electric','',0,0,0,0,0,0,0,0,' residential lighting');
INSERT INTO "technology" VALUES('SRE','p','supply','petroleum','',0,0,0,0,0,0,0,0,' crude oil processor');
INSERT INTO "technology" VALUES('TXD','p','transport','petroleum','',0,0,0,0,0,0,0,0,' diesel powered vehicles');
INSERT INTO "technology" VALUES('TXE','p','transport','electric','',0,0,0,0,0,0,0,0,' electric powered vehicles');
INSERT INTO "technology" VALUES('TXG','p','transport','petroleum','',0,0,0,0,0,0,0,0,' gasoline powered vehicles');

CREATE TABLE technology_type
(
    label       TEXT
        PRIMARY KEY,
    description TEXT
);
INSERT INTO "technology_type" VALUES('p','production technology');
INSERT INTO "technology_type" VALUES('pb','baseload production technology');
INSERT INTO "technology_type" VALUES('ps','storage production technology');

CREATE TABLE time_of_day
(
    sequence INTEGER UNIQUE,
    tod      TEXT
        PRIMARY KEY,
    hours    REAL NOT NULL DEFAULT 1,
    notes    TEXT,
    CHECK (hours > 0)
);
INSERT INTO "time_of_day" VALUES(1,'day',16.0,NULL);
INSERT INTO "time_of_day" VALUES(2,'night',8.0,NULL);

CREATE TABLE time_period
(
    sequence INTEGER UNIQUE,
    period   INTEGER
        PRIMARY KEY,
    flag     TEXT
        REFERENCES time_period_type (label)
);
INSERT INTO "time_period" VALUES(1,1960,'e');
INSERT INTO "time_period" VALUES(2,1970,'e');
INSERT INTO "time_period" VALUES(3,1980,'e');
INSERT INTO "time_period" VALUES(4,1990,'e');
INSERT INTO "time_period" VALUES(5,2000,'e');
INSERT INTO "time_period" VALUES(6,2010,'e');
INSERT INTO "time_period" VALUES(7,2020,'f');
INSERT INTO "time_period" VALUES(8,2030,'f');
INSERT INTO "time_period" VALUES(9,2040,'f');
INSERT INTO "time_period" VALUES(10,2050,'f');
INSERT INTO "time_period" VALUES(11,2060,'f');
INSERT INTO "time_period" VALUES(12,2070,'f');

CREATE TABLE time_period_type
(
    label       TEXT
        PRIMARY KEY,
    description TEXT
);
INSERT INTO "time_period_type" VALUES('e','existing vintages');
INSERT INTO "time_period_type" VALUES('f','future');

CREATE TABLE time_season
(
    sequence INTEGER UNIQUE,
    season TEXT,
    segment_fraction REAL NOT NULL,
    notes TEXT,
    PRIMARY KEY (season),
    CHECK (segment_fraction >= 0 AND segment_fraction <= 1)
);
INSERT INTO "time_season" VALUES(0,'inter',0.25,NULL);
INSERT INTO "time_season" VALUES(1,'summer',0.25,NULL);
INSERT INTO "time_season" VALUES(2,'winter',0.5,NULL);

CREATE TABLE time_season_sequential
(
    sequence INTEGER UNIQUE,
    seas_seq TEXT,
    season TEXT REFERENCES time_season(season),
    segment_fraction REAL NOT NULL,
    notes TEXT,
    PRIMARY KEY (seas_seq),
    CHECK (segment_fraction >= 0 AND segment_fraction <= 1)
);

COMMIT;

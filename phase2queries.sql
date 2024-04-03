CREATE TABLE FacilityTypes (
    Facility_Type VARCHAR(255) PRIMARY KEY NOT NULL,
    FType VARCHAR(255) NOT NULL
);

-- PQSL for importing: \copy FacilityTypes FROM 'D:\..\CSI4142_Project\facility_type_df.csv' DELIMITER ',' CSV HEADER;

Create TABLE AgeDemographics(
	Age_City_ID VARCHAR(255) PRIMARY KEY NOT NULL,
	City VARCHAR(255) NOT NULL,
	"0 to 4 years" INT NOT NULL,
    "5 to 9 years" INT NOT NULL,
    "10 to 14 years" INT NOT NULL,
    "15 to 19 years" INT NOT NULL,
    "20 to 24 years" INT NOT NULL,
    "25 to 29 years" INT NOT NULL,
    "30 to 34 years" INT NOT NULL,
    "35 to 39 years" INT NOT NULL,
    "40 to 44 years" INT NOT NULL,
    "45 to 49 years" INT NOT NULL,
    "50 to 54 years" INT NOT NULL,
    "55 to 59 years" INT NOT NULL,
    "60 to 64 years" INT NOT NULL,
    "65 to 69 years" INT NOT NULL,
    "70 to 74 years" INT NOT NULL,
    "75 to 79 years" INT NOT NULL,
    "80 to 84 years" INT NOT NULL,
    "85 years and over" INT NOT NULL,
    "85 to 89 years" INT NOT NULL,
    "90 to 94 years" INT NOT NULL,
    "95 to 99 years" INT NOT NULL,
    "100 years and over" INT NOT NULL
);

-- PSQL for importing: \copy AgeDemographics FROM 'D:\..\CSI4142_Project\age_df.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE EthnicityDemographics (
    Ethnicity_City_ID VARCHAR(255) PRIMARY KEY NOT NULL,
    City VARCHAR(255) NOT NULL,
    "South Asian" INT NOT NULL,
    Chinese INT NOT NULL,
    Black INT NOT NULL,
    Filipino INT NOT NULL,
    Arab INT NOT NULL,
    "Latin American" INT NOT NULL,
    "Southeast Asian" INT NOT NULL,
    "West Asian" INT NOT NULL,
    Korean INT NOT NULL,
    Japanese INT NOT NULL,
    "Visible minority, n.i.e." INT NOT NULL,
    "Multiple visible minorities" INT NOT NULL,
    "Not a visible minority" INT NOT NULL
);

-- PSQL for importing: \copy ethnicityDemographics FROM 'D:\..\eth_df.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE Facilities (
    Facility_ID INT PRIMARY KEY,
    Street_No INT NOT NULL,
    Street_Name VARCHAR(255),
    Street_Type VARCHAR(255),
    Street_Direction VARCHAR(255),
    Postal_Code VARCHAR(10),
    Prov_Terr VARCHAR(255) NOT NULL,
	City VARCHAR(255) NOT NULL,
    Facility_Type_ID VARCHAR(255) NOT NULL,
    FOREIGN KEY(Facility_Type_ID) REFERENCES FacilityTypes(Facility_Type)
);

-- PSQL import: \copy Facilities FROM 'D:\..\facility_df.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE AgeMapping (
    Age_ID INT PRIMARY KEY NOT NULL,
    Age_Range VARCHAR(255) NOT NULL
);

-- PSQL import: \copy AgeMapping FROM 'D:\..\CSI4142_Project\age_mapping.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE EthnicityMapping (
    Ethnicity_ID INT PRIMARY KEY NOT NULL,
    Ethnicity VARCHAR(255) NOT NULL
);

-- PSQL import: \copy ethnicityMapping FROM 'D:\..\CSI4142_Project\eth_mapping.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE FactTable (
    City VARCHAR(255) NOT NULL,
    Age_City_ID VARCHAR(255) NOT NULL,
    Ethnicity_City_ID VARCHAR(255) NOT NULL,
    Facility_Count INT NOT NULL,
    Highest_Population_Age_ID INT NOT NULL,
    Highest_Population_Ethnicity_ID INT NOT NULL,
    Facility_IDs TEXT[],
    FOREIGN KEY (Age_City_ID) REFERENCES AgeDemographics(Age_City_ID),
    FOREIGN KEY (Ethnicity_City_ID) REFERENCES EthnicityDemographics(Ethnicity_City_ID),
    FOREIGN KEY (Highest_Population_Age_ID) REFERENCES AgeMapping(Age_ID),
    FOREIGN KEY (Highest_Population_Ethnicity_ID) REFERENCES EthnicityMapping(Ethnicity_ID)
);

-- PSQL import: \copy FactTable FROM 'D:\..\CSI4142_Project\fact_df.csv' DELIMITER ',' CSV HEADER;

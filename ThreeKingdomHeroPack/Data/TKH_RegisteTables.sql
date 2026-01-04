-- TKH_RegisteTables
-- Author: PurpleSoul
-- DateCreated: 6/7/2025 12:20:19 PM
--------------------------------------------------------------


CREATE TABLE IF NOT EXISTS HeroClassAbilities (
	HeroClassType		TEXT   NOT NULL,
    UnitAbilityTypes	TEXT,
	PRIMARY KEY (HeroClassType)
);

CREATE TABLE IF NOT EXISTS HeroClassPortraits (
	HeroClassType   TEXT   NOT NULL,
    Normal			TEXT,
	Expired			TEXT,
	Killed			TEXT,
	PRIMARY KEY (HeroClassType)
);

CREATE TABLE IF NOT EXISTS TKH_Numbers (
	'No' INTEGER NOT NULL,
	PRIMARY KEY(No)
);
WITH RECURSIVE
INDICES(i) AS (SELECT 1 UNION ALL SELECT (i + 1) FROM INDICES LIMIT 100)
INSERT INTO TKH_Numbers(No) 
SELECT i 
FROM INDICES;

CREATE TABLE IF NOT EXISTS TKH_Heroes ( 
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL, 
    UnitTags TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS TKH_RelationshipAbilities ( 
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL, 
    Heroes TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS TKH_EquipmentTypes ( 
	EquipmentType TEXT NOT NULL, 
	Name TEXT, 
	PRIMARY KEY (EquipmentType) 
);

CREATE TABLE IF NOT EXISTS TKH_EquipmentSuits (
	Suit TEXT NOT NULL, 
	Name TEXT NOT NULL, 
	Description TEXT, 
	SuitAbilities TEXT, 
	SuitEquipmentAmount TEXT,
	PRIMARY KEY (Suit)
);

CREATE TABLE IF NOT EXISTS TKH_Equipments (
	Equipment TEXT NOT NULL, 
	EquipmentType TEXT NOT NULL, 
	Name TEXT, 
	Description TEXT, 
	EquipmentAbility TEXT, 
	Icon TEXT,
	HeroExclusive TEXT,
	RewardReqType TEXT NOT NULL DEFAULT 'TOTAL_KILL',
	MustReward BLOB NOT NULL DEFAULT 0,
	RewardParam1 TEXT,
	RewardParam2 TEXT,
	Suit TEXT,
	Level INTEGER NOT NULL DEFAULT 0,
	Price INTEGER NOT NULL DEFAULT 0,
	-- 护甲值
	Parameter1 INTEGER NOT NULL DEFAULT 0,	
	Parameter2 INTEGER NOT NULL DEFAULT 0,
	Parameter3 INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY (Equipment),
	FOREIGN KEY (EquipmentType) REFERENCES TKH_EquipmentTypes(EquipmentType),
	FOREIGN KEY (Suit) REFERENCES TKH_EquipmentSuits(Suit)
);

CREATE TABLE IF NOT EXISTS TKH_ArmouryProjects ( 
    ID INTEGER PRIMARY KEY AUTOINCREMENT,
    Name TEXT NOT NULL, 
    Tags TEXT NOT NULL, 
    CostMutilpier INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS TKH_GreatCities ( 
	City TEXT NOT NULL, 
	Name TEXT, 
    Level INTEGER,
    PropertyKey TEXT,
	PRIMARY KEY (City) 
);

CREATE TABLE IF NOT EXISTS TKH_GreatCityModifers ( 
	PropertyKey TEXT NOT NULL, 
	ModifierType TEXT,
	Name TEXT,
	ArgumentName TEXT, 
	ArgumentValue TEXT,
	SubjectRequirementSetId TEXT
);

CREATE TABLE IF NOT EXISTS TKH_UnitCommands(
	"CommandType" TEXT NOT NULL,
	"Description" TEXT NOT NULL,
	"Help" TEXT,
	"DisabledHelp" TEXT,
	"Icon" TEXT NOT NULL,
	"Sound" TEXT,
	"VisibleInUI" BOOLEAN NOT NULL CHECK (VisibleInUI IN (0,1)),
	"HoldCycling" BOOLEAN NOT NULL CHECK (HoldCycling IN (0,1)) DEFAULT 0,
	"CategoryInUI" TEXT,
	"InterfaceMode" TEXT,
	"PrereqTech" TEXT,
	"PrereqCivic" TEXT,
	"MaxEra" INTEGER NOT NULL DEFAULT -1,
	"HotkeyId" TEXT,
	PRIMARY KEY(CommandType),
	FOREIGN KEY (PrereqCivic) REFERENCES Civics(CivicType) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PrereqTech) REFERENCES Technologies(TechnologyType) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS TKH_UnitTypeUnitCommands (
	UnitType TEXT NOT NULL, 
	CommandType TEXT NOT NULL,
	ActionCharges INTEGER NOT NULL,
	Recover BOOLEAN NOT NULL CHECK (Recover IN (0,1)) DEFAULT 0,
	RecoverType INTEGER,
	PRIMARY KEY (UnitType, CommandType)
);

CREATE TABLE IF NOT EXISTS TKH_UnitTypeUnitCommandArguments (
	UnitType TEXT NOT NULL, 
	CommandType TEXT NOT NULL, 
	Name TEXT NOT NULL ,
	Value TEXT
);

CREATE TABLE IF NOT EXISTS TKH_GreatPeoples ( 
	Name TEXT NOT NULL, 
	GreatPersonClassType TEXT, 
    EraType INTEGER,
    Gender TEXT,
	CommandType,
	ActionCharges,
	CommandArgumentName,
	CommandArgumentValue,
	PRIMARY KEY (Name) 
);

CREATE TABLE IF NOT EXISTS TKH_UnitTagControlCrit ( 
	Tag TEXT NOT NULL, 
	Percent INTEGER, 
	PRIMARY KEY (Tag),
	FOREIGN KEY (Tag) REFERENCES Tags(Tag)
);

CREATE TABLE IF NOT EXISTS TKH_UnitTypeControlCrit ( 
	UnitType TEXT NOT NULL, 
	Percent INTEGER, 
	PRIMARY KEY (UnitType),
	FOREIGN KEY (UnitType) REFERENCES Units(UnitType)
);

CREATE TABLE IF NOT EXISTS TKH_UnitTagArmor ( 
	Tag TEXT NOT NULL, 
	BaseArmor INTEGER, 
	PRIMARY KEY (Tag),
	FOREIGN KEY (Tag) REFERENCES Tags(Tag)
);

CREATE TABLE IF NOT EXISTS TKH_UnitTypeArmor ( 
	UnitType TEXT NOT NULL, 
	BaseArmor INTEGER, 
	PRIMARY KEY (UnitType),
	FOREIGN KEY (UnitType) REFERENCES Units(UnitType)
);
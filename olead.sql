
DROP SCHEMA IF EXISTS olead CASCADE;

CREATE SCHEMA olead;

CREATE TABLE olead.advertisers (advertiser_iid TEXT PRIMARY KEY,
				caption TEXT NOT NULL,
				descr TEXT NOT NULL);

INSERT INTO olead.advertisers (advertiser_iid, caption, descr) VALUES ("ubbr", "Уббр Банк", "Уббр Банк");

CREATE TABLE olead.partners (partner_eid TEXT PRIMARY KEY,
			url TEXT NOT NULL,
			descr TEXT);

DROP SCHEMA IF EXISTS sheetapi CASCADE;
CREATE SCHEMA sheetapi;

CREATE TABLE sheetapi.camps (camp_eid TEXT PRIMARY KEY,
			hasoffers_url TEXT NOT NULL,
			name TEXT NOT NULL,
			advertiser_iid TEXT NOT NULL,
			created TIMESTAMP NOT NULL DEFAULT NOW(),
			api_userid TEXT NOT NULL,
			api_key TEXT NOT NULL,
			conversions BIGINT DEFAULT 0);

CREATE TABLE sheetapi.sheets (sheet_iid BIGSERIAL PRIMARY KEY,
			sheet_eid TEXT DEFAULT NULL,
			partner_eid TEXT NOT NULL,
			camp_id TEXT NOT NULL,
			fields TEXT NOT NULL,
			created TIMESTAMP NOT NULL DEFAULT NOW(),
			accepted boolean NOT NULL DEFAULT FALSE,
			declined boolean NOT NULL DEFAULT FALSE);

CREATE TABLE sheetapi.users (userid BIGSERIAL PRIMARY KEY,
			login TEXT NOT NULL,
			pass TEXT NOT NULL,
			email TEXT);

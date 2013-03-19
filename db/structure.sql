--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: games_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE games_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: games; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE games (
    id integer DEFAULT nextval('games_id_seq'::regclass) NOT NULL,
    player1_id integer,
    player2_id integer,
    winner_id integer,
    next_turn_id integer,
    status character varying(255) NOT NULL,
    height integer NOT NULL,
    width integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    CONSTRAINT games_height_check CHECK ((height > 0)),
    CONSTRAINT games_status_check CHECK (((status)::text <> ''::text)),
    CONSTRAINT games_width_check CHECK ((width > 0))
);


--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
    id integer DEFAULT nextval('players_id_seq'::regclass) NOT NULL,
    type character varying(255),
    name character varying(255),
    email character varying(255),
    battlefield integer[],
    battlefield_casualties integer[],
    previous_strikes integer[],
    p45_player_id integer,
    p45_next_move_x integer,
    p45_next_move_y integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: games_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
    ADD CONSTRAINT players_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: games_next_turn_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_next_turn_id_fkey FOREIGN KEY (next_turn_id) REFERENCES players(id);


--
-- Name: games_player1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_player1_id_fkey FOREIGN KEY (player1_id) REFERENCES players(id);


--
-- Name: games_player2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_player2_id_fkey FOREIGN KEY (player2_id) REFERENCES players(id);


--
-- Name: games_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY games
    ADD CONSTRAINT games_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES players(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130317163018');

INSERT INTO schema_migrations (version) VALUES ('20130317292548');

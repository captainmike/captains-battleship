class CreatePlayers < ActiveRecord::Migration
  def change
    execute <<-SQL
      create sequence players_id_seq;

      create table players (
        id integer not null default nextval('players_id_seq'),
        type varchar(255),
        name varchar(255),
        email varchar(255),
        battlefield integer[],
        battlefield_casualties integer[],
        previous_strikes integer[],
        p45_player_id integer,
        p45_next_move_x integer,
        p45_next_move_y integer,
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        primary key(id)
      );
    SQL
  end
end

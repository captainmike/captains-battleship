class CreateGames < ActiveRecord::Migration
  def change
    execute <<-SQL
      create sequence games_id_seq;

      create table games (
        id integer not null default nextval('games_id_seq'),
        player1_id integer references players(id),
        player2_id integer references players(id),
        winner_id integer references players(id),
        next_turn_id integer references players(id),
        status varchar(255) not null check (status != ''),
        height integer not null check (height > 0),
        width integer not null check (width > 0),
        created_at timestamp without time zone,
        updated_at timestamp without time zone,
        primary key(id)
      );
    SQL
  end
end

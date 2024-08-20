-- CREATE SCHEMA
CREATE SCHEMA sports_portal AUTHORIZATION sebitas;

-- CREATE TABLES
CREATE TABLE sports_portal.leagues (
    id serial4 NOT NULL,
    name varchar(255) NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT leagues_pkey PRIMARY KEY (id),
    CONSTRAINT leagues_name_unique UNIQUE (name)
);

CREATE TABLE sports_portal.users (
    id serial4 NOT NULL,
    username varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT users_email_key UNIQUE (email),
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_username_key UNIQUE (username)
);

CREATE TABLE sports_portal.teams (
    id serial4 NOT NULL,
    name varchar(255) NOT NULL,
    league_id int4 NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT teams_pkey PRIMARY KEY (id),
    CONSTRAINT teams_name_unique UNIQUE (name),
    CONSTRAINT teams_league_id_fkey FOREIGN KEY (league_id) REFERENCES sports_portal.leagues(id) ON DELETE SET NULL
);

CREATE TABLE sports_portal.advertisements (
    id serial4 NOT NULL,
    content text NOT NULL,
    team_id int4 NULL,
    league_id int4 NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT advertisements_pkey PRIMARY KEY (id),
    CONSTRAINT advertisements_league_id_fkey FOREIGN KEY (league_id) REFERENCES sports_portal.leagues(id) ON DELETE SET NULL,
    CONSTRAINT advertisements_team_id_fkey FOREIGN KEY (team_id) REFERENCES sports_portal.teams(id) ON DELETE SET NULL
);

CREATE TABLE sports_portal.articles (
    id serial4 NOT NULL,
    title varchar(255) NOT NULL,
    content text NOT NULL,
    published_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    team_id int4 NULL,
    league_id int4 NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT articles_pkey PRIMARY KEY (id),
    CONSTRAINT articles_league_id_fkey FOREIGN KEY (league_id) REFERENCES sports_portal.leagues(id) ON DELETE SET NULL,
    CONSTRAINT articles_team_id_fkey FOREIGN KEY (team_id) REFERENCES sports_portal.teams(id) ON DELETE SET NULL
);

CREATE TABLE sports_portal.comments (
    id serial4 NOT NULL,
    user_id int4 NULL,
    article_id int4 NULL,
    content text NOT NULL,
    comment_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT comments_pkey PRIMARY KEY (id),
    CONSTRAINT comments_article_id_fkey FOREIGN KEY (article_id) REFERENCES sports_portal.articles(id) ON DELETE CASCADE,
    CONSTRAINT comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES sports_portal.users(id) ON DELETE SET NULL
);

CREATE TABLE sports_portal.games (
    id serial4 NOT NULL,
    date timestamp NOT NULL,
    team1_id int4 NULL,
    team2_id int4 NULL,
    league_id int4 NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT games_pkey PRIMARY KEY (id),
    CONSTRAINT games_league_id_fkey FOREIGN KEY (league_id) REFERENCES sports_portal.leagues(id) ON DELETE SET NULL,
    CONSTRAINT games_team1_id_fkey FOREIGN KEY (team1_id) REFERENCES sports_portal.teams(id) ON DELETE SET NULL,
    CONSTRAINT games_team2_id_fkey FOREIGN KEY (team2_id) REFERENCES sports_portal.teams(id) ON DELETE SET NULL,
    CONSTRAINT games_team_check CHECK (team1_id <> team2_id)
);

CREATE TABLE sports_portal.media (
    id serial4 NOT NULL,
    url text NOT NULL,
    type varchar(50) NOT NULL,
    article_id int4 NULL,
    team_id int4 NULL,
    league_id int4 NULL,
    game_id int4 NULL,
    advertisement_id int4 NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT media_pkey PRIMARY KEY (id),
    CONSTRAINT media_advertisement_id_fkey FOREIGN KEY (advertisement_id) REFERENCES sports_portal.advertisements(id) ON DELETE SET NULL,
    CONSTRAINT media_article_id_fkey FOREIGN KEY (article_id) REFERENCES sports_portal.articles(id) ON DELETE SET NULL,
    CONSTRAINT media_game_id_fkey FOREIGN KEY (game_id) REFERENCES sports_portal.games(id) ON DELETE SET NULL,
    CONSTRAINT media_league_id_fkey FOREIGN KEY (league_id) REFERENCES sports_portal.leagues(id) ON DELETE SET NULL,
    CONSTRAINT media_team_id_fkey FOREIGN KEY (team_id) REFERENCES sports_portal.teams(id) ON DELETE SET NULL
);

CREATE TABLE sports_portal.article_views (
    id serial4 NOT NULL,
    user_id int4 NULL,
    article_id int4 NULL,
    view_date timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT article_views_pkey PRIMARY KEY (id),
    CONSTRAINT article_views_article_id_fkey FOREIGN KEY (article_id) REFERENCES sports_portal.articles(id) ON DELETE CASCADE,
    CONSTRAINT article_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES sports_portal.users(id) ON DELETE SET NULL
);

CREATE TABLE sports_portal.events (
    id serial4 NOT NULL,
    game_id int4 NULL,
    event_type varchar(255) NOT NULL,
    description text NULL,
    player_id int4 NULL,
    created_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT events_pkey PRIMARY KEY (id),
    CONSTRAINT events_game_id_fkey FOREIGN KEY (game_id) REFERENCES sports_portal.games(id) ON DELETE CASCADE,
    CONSTRAINT events_event_type_check CHECK (event_type IN ('goal', 'foul', 'substitution', 'card', 'injury'))
);

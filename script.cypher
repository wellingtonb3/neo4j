// --- 1. DELETAR DADOS EXISTENTES (Opcional, para um ambiente limpo) ---
MATCH (n) DETACH DELETE n;

// --- 2. CRIAR CONSTRAINTS (Restrições de Unicidade e Índice) ---

CREATE CONSTRAINT user_id IF NOT EXISTS FOR (u:User) REQUIRE u.userId IS UNIQUE;
CREATE CONSTRAINT movie_id IF NOT EXISTS FOR (m:Movie) REQUIRE m.movieId IS UNIQUE;
CREATE CONSTRAINT series_id IF NOT EXISTS FOR (s:Series) REQUIRE s.seriesId IS UNIQUE;
CREATE CONSTRAINT actor_id IF NOT EXISTS FOR (a:Actor) REQUIRE a.actorId IS UNIQUE;
CREATE CONSTRAINT director_id IF NOT EXISTS FOR (d:Director) REQUIRE d.directorId IS UNIQUE;
CREATE CONSTRAINT genre_name IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;

// --- 3. POPULAR O BANCO DE DADOS ---

// 3.1. Gêneros
MERGE (g1:Genre {name: 'Ação'});
MERGE (g2:Genre {name: 'Comédia'});
MERGE (g3:Genre {name: 'Drama'});
MERGE (g4:Genre {name: 'Ficção Científica'});
MERGE (g5:Genre {name: 'Terror'});
MERGE (g6:Genre {name: 'Fantasia'});

// 3.2. Atores e Diretores
MERGE (a1:Actor {actorId: 'A1', name: 'Tom Hanks'});
MERGE (a2:Actor {actorId: 'A2', name: 'Scarlett Johansson'});
MERGE (a3:Actor {actorId: 'A3', name: 'Leonardo DiCaprio'});
MERGE (a4:Actor {actorId: 'A4', name: 'Viola Davis'});
MERGE (a5:Actor {actorId: 'A5', name: 'Keanu Reeves'});
MERGE (d1:Director {directorId: 'D1', name: 'Christopher Nolan'});
MERGE (d2:Director {directorId: 'D2', name: 'Greta Gerwig'});
MERGE (d3:Director {directorId: 'D3', name: 'Quentin Tarantino'});
MERGE (d4:Director {directorId: 'D4', name: 'Steven Spielberg'});

// 3.3. Filmes e Séries (10 Itens)
// Filmes
MERGE (m1:Movie {movieId: 'M1', title: 'A Origem', releaseYear: 2010});
MERGE (m2:Movie {movieId: 'M2', title: 'O Lobo de Wall Street', releaseYear: 2013});
MERGE (m3:Movie {movieId: 'M3', title: 'Pulp Fiction', releaseYear: 1994});
MERGE (m4:Movie {movieId: 'M4', title: 'Forrest Gump', releaseYear: 1994});
MERGE (m5:Movie {movieId: 'M5', title: 'Matrix', releaseYear: 1999});
// Séries
MERGE (s1:Series {seriesId: 'S1', title: 'Stranger Things', seasons: 5});
MERGE (s2:Series {seriesId: 'S2', title: 'The Witcher', seasons: 3});
MERGE (s3:Series {seriesId: 'S3', title: 'The Office', seasons: 9});
MERGE (s4:Series {seriesId: 'S4', title: 'Breaking Bad', seasons: 5});
MERGE (s5:Series {seriesId: 'S5', title: 'The Queen\'s Gambit', seasons: 1});

// 3.4. Usuários (10 Usuários)
MERGE (u1:User {userId: 'U1', username: 'Ana'});
MERGE (u2:User {userId: 'U2', username: 'Bruno'});
MERGE (u3:User {userId: 'U3', username: 'Carla'});
MERGE (u4:User {userId: 'U4', username: 'David'});
MERGE (u5:User {userId: 'U5', username: 'Eva'});
MERGE (u6:User {userId: 'U6', username: 'Felipe'});
MERGE (u7:User {userId: 'U7', username: 'Giovana'});
MERGE (u8:User {userId: 'U8', username: 'Henrique'});
MERGE (u9:User {userId: 'U9', username: 'Isabela'});
MERGE (u10:User {userId: 'U10', username: 'João'});

// 3.5. RELACIONAMENTOS DE CONTEÚDO

// M1: A Origem (Nolan, DiCaprio) - Ação, Ficção Científica
MATCH (m:Movie {movieId: 'M1'}), (d:Director {directorId: 'D1'}), (a:Actor {actorId: 'A3'}), (gA:Genre {name: 'Ação'}), (gF:Genre {name: 'Ficção Científica'})
MERGE (d)-[:DIRECTED]->(m)
MERGE (a)-[:ACTED_IN]->(m)
MERGE (m)-[:IN_GENRE]->(gA)
MERGE (m)-[:IN_GENRE]->(gF);

// M3: Pulp Fiction (Tarantino, Travolta/Sem Dados Exatos) - Drama
MATCH (m:Movie {movieId: 'M3'}), (d:Director {directorId: 'D3'}), (gD:Genre {name: 'Drama'})
MERGE (d)-[:DIRECTED]->(m)
MERGE (m)-[:IN_GENRE]->(gD);

// M5: Matrix (Wachowskis/Sem Dados Exatos, Reeves) - Ação, Ficção Científica
MATCH (m:Movie {movieId: 'M5'}), (a:Actor {actorId: 'A5'}), (gA:Genre {name: 'Ação'}), (gF:Genre {name: 'Ficção Científica'})
MERGE (a)-[:ACTED_IN]->(m)
MERGE (m)-[:IN_GENRE]->(gA)
MERGE (m)-[:IN_GENRE]->(gF);

// S1: Stranger Things (Atores diversos/Sem Dados Exatos) - Terror, Ficção Científica
MATCH (s:Series {seriesId: 'S1'}), (gT:Genre {name: 'Terror'}), (gF:Genre {name: 'Ficção Científica'})
MERGE (s)-[:IN_GENRE]->(gT)
MERGE (s)-[:IN_GENRE]->(gF);

// S3: The Office (Atores diversos/Sem Dados Exatos) - Comédia
MATCH (s:Series {seriesId: 'S3'}), (gC:Genre {name: 'Comédia'})
MERGE (s)-[:IN_GENRE]->(gC);

// S4: Breaking Bad (Atores diversos/Sem Dados Exatos) - Drama
MATCH (s:Series {seriesId: 'S4'}), (gD:Genre {name: 'Drama'})
MERGE (s)-[:IN_GENRE]->(gD);

// 3.6. RELACIONAMENTOS DE VISUALIZAÇÃO/AVALIAÇÃO (WATCHED)

// U1 (Ana) gosta de Ação/Sci-Fi (M1, M5) e Série S4 (Drama)
MATCH (u:User {userId: 'U1'}), (m1:Movie {movieId: 'M1'}), (m5:Movie {movieId: 'M5'}), (s4:Series {seriesId: 'S4'})
MERGE (u)-[:WATCHED {rating: 5}]->(m1)
MERGE (u)-[:WATCHED {rating: 4}]->(m5)
MERGE (u)-[:WATCHED {rating: 5}]->(s4);

// U2 (Bruno) gosta de Drama (M3, S4) e Comédia (S3)
MATCH (u:User {userId: 'U2'}), (m3:Movie {movieId: 'M3'}), (s4:Series {seriesId: 'S4'}), (s3:Series {seriesId: 'S3'})
MERGE (u)-[:WATCHED {rating: 5}]->(m3)
MERGE (u)-[:WATCHED {rating: 4}]->(s4)
MERGE (u)-[:WATCHED {rating: 4}]->(s3);

// U3 (Carla) gosta de Ficção Científica (M1, S1)
MATCH (u:User {userId: 'U3'}), (m1:Movie {movieId: 'M1'}), (s1:Series {seriesId: 'S1'})
MERGE (u)-[:WATCHED {rating: 4}]->(m1)
MERGE (u)-[:WATCHED {rating: 5}]->(s1);

// U4 (David) é parecido com U1 - gosta de Ação/Sci-Fi (M1, M5)
MATCH (u:User {userId: 'U4'}), (m1:Movie {movieId: 'M1'}), (m5:Movie {movieId: 'M5'})
MERGE (u)-[:WATCHED {rating: 5}]->(m1)
MERGE (u)-[:WATCHED {rating: 5}]->(m5);

// U5 (Eva) gosta de Comédia (S3) e Drama (S4)
MATCH (u:User {userId: 'U5'}), (s3:Series {seriesId: 'S3'}), (s4:Series {seriesId: 'S4'})
MERGE (u)-[:WATCHED {rating: 5}]->(s3)
MERGE (u)-[:WATCHED {rating: 4}]->(s4);

// U6-U10 - Mais alguns dados esparsos
MATCH (u:User {userId: 'U6'}), (m2:Movie {movieId: 'M2'}) MERGE (u)-[:WATCHED {rating: 3}]->(m2);
MATCH (u:User {userId: 'U7'}), (m4:Movie {movieId: 'M4'}) MERGE (u)-[:WATCHED {rating: 5}]->(m4);
MATCH (u:User {userId: 'U8'}), (s2:Series {seriesId: 'S2'}) MERGE (u)-[:WATCHED {rating: 4}]->(s2);
MATCH (u:User {userId: 'U9'}), (s5:Series {seriesId: 'S5'}) MERGE (u)-[:WATCHED {rating: 5}]->(s5);
MATCH (u:User {userId: 'U10'}), (m1:Movie {movieId: 'M1'}) MERGE (u)-[:WATCHED {rating: 3}]->(m1);
implement main
    open core, file, stdio

domains
    city =
        moscow; saint_petersburg; rostov_on_don; grozny; krasnodar; orenburg; sochi; yekaterinburg; samara; voronezh; nizhny_novgorod; khimki;
        zelenograd; kazan; tula; ufa; tambov; volgograd.
    year = integer.
    month = integer.
    day = integer.
    hour = integer.
    minute = integer.
    date = date(year, month, day).
    time = time(hour, minute).

class facts - rpl
    % Club(id, name, city, stadium, coach)
    club : (integer Id_c, string Name_c, city City, string Stadium, string Coach).
    % Facts about players: player(id, first name, last name, age, position, club)
    player : (integer Id_p, string First_name, string Last_name, integer Age, string Position, integer Id_c).
    % Facts about matches: match(id of home team, id of away team, date, time, score)
    match : (integer Id_hc, integer Id_gc, date Date, time Time, string Score).

class facts
    s : (integer Sum) single.

class predicates
    % Clubs from a certain city
    club_by_city : (city City) nondeterm.
    % Players of a certain club
    player_by_club : (string Name_c) nondeterm.
    % Coaches of a certain club
    coach_by_club : (string Name_c) nondeterm.
    % Matches of a certain club
    match_by_club : (string Name_c) nondeterm.
    % Matches of a certain date
    match_by_date : (date Date) nondeterm.
    % Names of all clubs
    club_name : () nondeterm.
    % Total age of all players
    total_age : () nondeterm.

clauses
    s(0).

    club_by_city(City) :-
        club(Id_c, Name_c, City, _, _),
        write("Club: ", Name_c),
        nl,
        fail.

    player_by_club(Name_c) :-
        club(Id_c, Name_c, _, _, _),
        player(Id_p, First_name, Last_name, Age, Position, Id_c),
        write("Player: ", First_name, " ", Last_name, ", age: ", Age, ", position: ", Position),
        nl,
        fail.

    coach_by_club(Name_c) :-
        club(Id_c, Name_c, _, _, Coach),
        write("Coach: ", Coach),
        nl,
        fail.

    match_by_club(Name_c) :-
        club(Id_c, Name_c, _, _, _),
        match(Id_hc, Id_gc, Date, Time, Score),
        (Id_hc = Id_c or Id_gc = Id_c),
        club(Id_hc, Name_hc, _, _, _),
        club(Id_gc, Name_gc, _, _, _),
        write("Match: ", Name_hc, " - ", Name_gc, ", date: ", Date, ", time: ", Time, ", score: ", Score),
        nl,
        fail.

    match_by_date(Date) :-
        match(Id_hc, Id_gc, Date, Time, Score),
        club(Id_hc, Name_hc, _, _, _),
        club(Id_gc, Name_gc, _, _, _),
        write("Match: ", Name_hc, " - ", Name_gc, ", time: ", Time, ", score: ", Score),
        nl,
        fail.

    club_name() :-
        club(_, Name_c, _, _, _),
        write(Name_c),
        nl,
        fail.

    total_age() :-
        player(_, _, _, Age, _, _),
        s(Sum),
        assert(s(Sum + Age)),
        fail.
    total_age() :-
        s(Sum),
        write("Total age of all players: ", Sum),
        nl.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        write("### Names of all clubs ###"),
        nl,
        club_name(),
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        write("Enter a city to find out which clubs are based there: "),
        nl,
        C = read(),
        C = hasDomain(city, C),
        club_by_city(C),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        write("Enter the name of a club to find out its players: "),
        N = read(),
        player_by_club(N),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        write("Enter the name of a club to find out its coach: "),
        N = read(),
        coach_by_club(N),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        write("Enter the name of a club to find out its matches: "),
        N = read(),
        match_by_club(N),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        write("Enter a date in the format date(year, month, day) to find out the matches of that day: "),
        D = read(),
        D = hasDomain(date, D),
        match_by_date(D),
        nl,
        fail.

    run() :-
        console::initUtf8(),
        reconsult("../db.txt", rpl), % Changed the path to the consultative file
        total_age(),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::runUtf8(main::run).

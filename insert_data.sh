#! /bin/bash
 echo -e "\n~~Insert data for world cup db~~\n"
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

truncateRet=$($PSQL "truncate table teams,games")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals; do
  if [[ $year != 'year' ]]; then
  #select team for check exsiting
  winTeamId=$($PSQL "select team_id from teams where name='$winner'")
  oppTeamId=$($PSQL "select team_id from teams where name='$opponent'")
  #insert team if not exits
  if [[ -z $winTeamId ]]; then
    winInsert=$($PSQL "insert into teams(name) values('$winner')")
    echo -e "Insert team: $winner"
    winTeamId=$($PSQL "select team_id from teams where name='$winner'")
  fi
  if [[ -z $oppTeamId ]]; then
    oppInsert=$($PSQL "insert into teams(name) values('$opponent')")
    echo -e "Insert team: $opponent"
    oppTeamId=$($PSQL "select team_id from teams where name='$opponent'")
  fi
  #insert games
  gameRet=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($year, '$round', $winTeamId, $oppTeamId, $winner_goals, $opponent_goals);")

  fi
done

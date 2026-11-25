#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

# Commit 2/ feat: welcome new and returning users
USER_DATA=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_DATA ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO users(username) VALUES('$USERNAME')" > /dev/null
else
  IFS='|' read GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# commit3/ feat: add guessing loop

SECRET=$(( RANDOM % 1000 + 1 ))
GUESSES=0

echo "Guess the secret number between 1 and 1000:"
while true
do
  read GUESS
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  GUESSES=$(( GUESSES + 1 ))

  if [[ $GUESS -lt $SECRET ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $GUESS -gt $SECRET ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $GUESSES tries. The secret number was $SECRET. Nice job!"
    break
  fi
done
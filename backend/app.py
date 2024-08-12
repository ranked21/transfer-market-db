import flask
from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request, redirect, render_template, jsonify
import os

app = Flask(__name__)

# database connection
# Template:
# app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
# app.config["MYSQL_USER"] = "cs340_OSUusername"
# app.config["MYSQL_PASSWORD"] = "XXXX" | last 4 digits of OSU id
# app.config["MYSQL_DB"] = "cs340_OSUusername"
# app.config["MYSQL_CURSORCLASS"] = "DictCursor"

# database connection info
app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
app.config["MYSQL_USER"] = "cs340_kovoorg"
app.config["MYSQL_PASSWORD"] = "XXXX"
app.config["MYSQL_DB"] = "cs340_kovoorg"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)

# Routes
# have homepage route to /players by default for convenience, generally this will be your home route with its own template
@app.route("/")
def home():
    return render_template('index.html')

@app.route("/players", methods=["POST","GET"])
def players():
    if request.method == "GET":
        # mySQL query to grab all the players in the Players Table
        query = "SELECT Players.playerID, Players.playerFirstName, Players.playerLastName, Players.currentSalary, Players.position, Players.playerMarketValue, Players.teamID FROM Players"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()    

        teams_query = "SELECT teamID, teamName FROM Teams"
        cur.execute(teams_query)
        teams = cur.fetchall()

        # Test Statement to print the data to the console
        print("Retrieved Players: ", data)
        print("Retrieved Teams", teams)

        return render_template("players.html", data=data, teams=teams)
    
    if request.method == "POST":
      first_name = request.form["firstName"]
      last_name = request.form["lastNname"]
      position = request.form["position"]
      value = request.form["value"]
      teamID = request.form["team"]

      # Test Statement to print the data to the console
      print(first_name, last_name, position, value, teamID)

      query = "INSERT INTO Players (`playerFirstName`, `playerLastName`, `position`, `playerMarketValue`, `teamID`) VALUES (%s, %s, %s, %s, %s)"
      cur = mysql.connection.cursor()
      cur.execute(query, (first_name, last_name, position, value, teamID))
      mysql.connection.commit()

      return redirect("/players")
    
@app.route("/delete_player/<int:id>")
def delete_players(id):
   query = "DELETE FROM Players WHERE playerID = '%s'"
   cur = mysql.connection.cursor()
   cur.execute(query, (id,))
   mysql.connection.commit()

   return redirect("/players")
      
@app.route("/edit_player/<int:id>", methods=["POST","GET"])
def edit_player(id):
   if request.method == "POST":
      playerID = request.form["playerID"]
      first_name = request.form["firstName"]
      last_name = request.form["lastNname"]
      position = request.form["position"]
      value = request.form["value"]
      teamID = request.form["team"]

      # Test Statement to print the data to the console
      print("Testing Update!")
      print(first_name, last_name, position, value, teamID, playerID)

      query = "UPDATE Players SET playerFirstName = %s, playerLastName = %s, position = %s, playerMarketValue = %s, teamID = %s WHERE playerID = %s"
      cur = mysql.connection.cursor()
      cur.execute(query, (first_name, last_name, position, value, teamID, playerID))
      mysql.connection.commit()

      return redirect("/players")

   if request.method == "GET":
         query = "SELECT * FROM Players WHERE playerID = '%s'"
         cur = mysql.connection.cursor()
         cur.execute(query, (id,))
         player = cur.fetchall()

         teams_query = "SELECT teamID, teamName FROM Teams"
         cur.execute(teams_query)
         teams = cur.fetchall()

         # Test Statement to print the data to the console
         print("Selected Player: ", player)
         print("Retrieved Teams", teams)

         return render_template("edit_players.html", player=player, teams=teams)

@app.route("/leagues", methods=["POST","GET"])
def leagues():
    if request.method == "GET":
        # mySQL query to grab all the players in the Leagues Table
        query = "SELECT * FROM Leagues"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()    

        # Test Statement to print the data to the console
        print("Retrieved Leagues: ", data)

        return render_template("leagues.html", data=data)
    
    if request.method == "POST":    
      name = request.form["name"]
      country = request.form["country"]
      rank = request.form["rank"]
      numberTeams = request.form["numberTeams"]
      yearFounded = request.form["yearFounded"]

      # Test Statement to print the data to the console
      print(name, country, rank, numberTeams, yearFounded)

      query = "INSERT INTO Leagues (`leagueName`, `country`, `divisionRank`, `numberOfTeams`, `yearFounded`) VALUES (%s, %s, %s, %s, %s)"
      cur = mysql.connection.cursor()
      cur.execute(query, (name, country, rank, numberTeams, yearFounded))
      mysql.connection.commit()

      return redirect("/leagues")

@app.route("/delete_league/<int:id>")
def delete_leagues(id):
   query = "DELETE FROM Leagues WHERE leagueID = '%s'"
   cur = mysql.connection.cursor()
   cur.execute(query, (id,))
   mysql.connection.commit()

   return redirect("/leagues")

@app.route("/edit_league/<int:id>", methods=["POST","GET"])
def edit_league(id):
   if request.method == "POST":
      leagueID = request.form["leagueID"]
      name = request.form["name"]
      country = request.form["country"]
      rank = request.form["rank"]
      numberTeams = request.form["numberTeams"]
      yearFounded = request.form["yearFounded"]

      # Test Statement to print the data to the console
      print("Testing Update!")
      print(leagueID, name, country, rank, numberTeams, yearFounded)

      query = "UPDATE Leagues SET leagueName = %s, country = %s, divisionRank = %s, numberOfTeams = %s, yearFounded = %s WHERE leagueID = %s "
      cur = mysql.connection.cursor()
      cur.execute(query, (name, country, rank, numberTeams, yearFounded, leagueID))
      mysql.connection.commit()

      return redirect("/leagues")

   if request.method == "GET":
         query = "SELECT * FROM Leagues WHERE leagueID = '%s'"
         cur = mysql.connection.cursor()
         cur.execute(query, (id,))
         league = cur.fetchall()

         # Test Statement to print the data to the console
         print("Selected League: ", league)

         return render_template("edit_leagues.html",league=league)
   
@app.route("/teams", methods=["POST","GET"])
def teams():
    if request.method == "GET":
        # mySQL query to grab all the players in the Leagues Table
        query = "SELECT * FROM Teams"
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()    

        leagues_query = "SELECT leagueID, leagueName FROM Leagues"
        cur.execute(leagues_query)
        leagues = cur.fetchall()

        # Test Statement to print the data to the console
        print("Retrieved Teams: ", data)
        print("Retrieved Leagues: ", leagues)

        return render_template("teams.html", data=data, leagues=leagues)
    
    if request.method == "POST":
      teamName = request.form["name"]
      teamCity = request.form["city"]
      leagueID = request.form["league"]
      teamYearFounded = request.form["yearFounded"]
      teamStadiumCapacity = request.form["stadiumCapacity"]

      # Test Statement to print the data to the console
      print(teamName, teamCity, teamYearFounded, teamStadiumCapacity, leagueID)

      query = "INSERT INTO Teams (`teamName`, `city`, `yearFounded`, `stadiumCapacity`, `leagueID`) VALUES (%s, %s, %s, %s, %s)"
      cur = mysql.connection.cursor()
      cur.execute(query, (teamName, teamCity, teamYearFounded, teamStadiumCapacity, leagueID))
      mysql.connection.commit()

      return redirect("/teams")

@app.route("/delete_team/<int:id>")
def delete_teams(id):
   query = "DELETE FROM Teams WHERE teamID = '%s'"
   cur = mysql.connection.cursor()
   cur.execute(query, (id,))
   mysql.connection.commit()

   return redirect("/teams")   

@app.route("/edit_team/<int:id>", methods=["POST","GET"])
def edit_team(id):
   if request.method == "GET":
        query = "SELECT * FROM Teams WHERE teamID = '%s'"
        cur = mysql.connection.cursor()
        cur.execute(query, (id,))
        team = cur.fetchall()

        leagues_query = "SELECT leagueID, leagueName FROM Leagues"
        cur.execute(leagues_query)
        leagues = cur.fetchall()
        
        # Test Statement to print the data to the console
        print("Selected Team: ", team)
        print("Selected Leagues: ", leagues)

        return render_template("edit_teams.html", team=team, leagues=leagues)
   
   if request.method == "POST":
      print("Testing the new update method!")
      print(request.form)

      teamID = request.form["teamID"]
      teamName = request.form["name"]
      teamCity = request.form["city"]
      leagueID = request.form["league"]
      teamYearFounded = request.form["yearFounded"]
      teamStadiumCapacity = request.form["stadiumCapacity"]

      # Test Statement to print the data to the console
      print("Testing Update!")
      print(teamID, teamName, teamCity, leagueID, teamYearFounded, teamStadiumCapacity)

      query = "UPDATE Teams SET teamName = %s, city = %s, yearFounded = %s, stadiumCapacity = %s, leagueID = %s WHERE teamID = %s"
      cur = mysql.connection.cursor()
      cur.execute(query, (teamName, teamCity, teamYearFounded, teamStadiumCapacity, leagueID, teamID))
      mysql.connection.commit()

      return redirect("/teams")

# Listener
# change the port number if deploying on the flip servers
if __name__ == "__main__":
    app.run(port=59481)
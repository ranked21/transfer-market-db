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
***REMOVED***
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
        query = "SELECT * FROM Players"
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
         player = cur.fetchall();

         teams_query = "SELECT teamID, teamName FROM Teams"
         cur.execute(teams_query)
         teams = cur.fetchall()

         # Test Statement to print the data to the console
         print("Selected Player: ", player)
         print("Retrieved Teams", teams)

         return render_template("edit_players.html", player=player, teams=teams)


# Listener
# change the port number if deploying on the flip servers
if __name__ == "__main__":
    app.run(port=3000, debug=True)
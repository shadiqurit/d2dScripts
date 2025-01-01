<?php
// Connection details
$servername = "localhost";
$username = "sadiqpro_lot";
$password = "Dhaka_5229";
$dbname = "sadiqpro_lot";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lottery Picker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: block;
            flex-direction: row;
            padding: 20px;
        }
#fdisp{
    font-family: Arial, sans-serif;
            display: flex;
            flex-direction: row;
            padding: 20px;
}
        #entry-section {
            width: 30%;
            padding: 20px;
        }

        #display-section {
            width: 70%;
            text-align: center;
            padding: 20px;
        }

        #spinner {
            margin: 20px auto;
            width: 200px;
            height: 200px;
            border: 10px solid #f3f3f3;
            border-top: 10px solid #007BFF;
            border-radius: 50%;
            animation: spin 2s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        #name-display {
            font-size: 2em;
            font-weight: bold;
            margin: 20px 0;
            padding: 20px;
            border: 2px solid #007BFF;
            border-radius: 10px;
            background-color: #f9f9f9;
        }

        button {
            font-size: 1.2em;
            padding: 10px 20px;
            color: #fff;
            background-color: #007BFF;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover {
            background-color: #0056b3;
        }

        #name-list {
            margin-top: 20px;
        }
    </style>
    <script>
        function pickNameWithSpin() {
            const spinner = document.getElementById("spinner");
            const nameDisplay = document.getElementById("name-display");

            spinner.style.display = "block";
            nameDisplay.innerText = "Spinning...";

            fetch("pick_name.php", {
                method: "POST",
            })
            .then(response => response.text())
            .then(data => {
                setTimeout(() => {
                    spinner.style.display = "none";
                    nameDisplay.innerText = data;
                    updateNameList(); // Update the name list after picking a winner
                }, 3000); // Simulate spin duration
            })
            .catch(error => {
                spinner.style.display = "none";
                nameDisplay.innerText = "Error picking name.";
                console.error("Error:", error);
            });
        }

        function updateNameList() {
            fetch("get_names.php")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("name-ul").innerHTML = data;
                })
                .catch(error => console.error('Error:', error));
        }
    </script>
</head>
<body>
   <div id="fdisp">
   <div id="entry-section">
        <h2>Enter Names</h2>
        <form id="name-form" method="post" action="save_name.php">
            <input type="text" id="name-input" name="name" placeholder="Enter a name" required />
            <button type="submit">Add Name</button>
        </form>
        <div id="name-list">
            <h3>Names:</h3>
            <ul id="name-ul">
                <?php
                // Fetch names from the database to display
                $result = $conn->query("SELECT name FROM lottery_names WHERE status = 0");
                if ($result->num_rows > 0) {
                    while ($row = $result->fetch_assoc()) {
                        echo "<li>" . htmlspecialchars($row['name']) . "</li>";
                    }
                }
                ?>
            </ul>
        </div>
    </div>

    


    <div id="display-section">
        <h1>Lottery Picker</h1>
        <div id="spinner" style="display: none;"></div>
        <div id="name-display">
             <?php
    // Display the current winner and their win date
    $winner = $conn->query("SELECT name, win_date FROM lottery_names WHERE status = 1 LIMIT 1");
    if ($winner->num_rows > 0) {
        $winnerData = $winner->fetch_assoc();
        echo "Winner: " . htmlspecialchars($winnerData['name']) . "<br>";
        echo "Won on: " . date("F j, Y, g:i a", strtotime($winnerData['win_date']));
    } else {
        echo "Click the button to pick a name";
    }
    ?>
        </div>
        <button onclick="pickNameWithSpin()">Pick a Name</button>
    </div>
   </div>

   <div id="name-display">
    <?php
    // Display the current winner and their win date
    $winner = $conn->query("SELECT name, win_date FROM lottery_names WHERE status = 1 LIMIT 1");
    if ($winner->num_rows > 0) {
        $winnerData = $winner->fetch_assoc();
        echo "Winner: " . htmlspecialchars($winnerData['name']) . "<br>";
        echo "Won on: " . date("F j, Y, g:i a", strtotime($winnerData['win_date']));
    } else {
        echo "Click the button to pick a name";
    }
    ?>
</div>


<div id="winner-list">
    <h3>Previous Winners:</h3>
    <ul id="winner-ul">
        <?php
        // Fetch all winners from the database
        $winnerResult = $conn->query("SELECT name, win_date FROM winners ORDER BY win_date DESC");
        if ($winnerResult->num_rows > 0) {
            while ($winnerRow = $winnerResult->fetch_assoc()) {
                echo "<li>" . htmlspecialchars($winnerRow['name']) . " - " . date("F j, Y, g:i a", strtotime($winnerRow['win_date'])) . "</li>";
            }
        } else {
            echo "<li>No winners yet.</li>";
        }
        ?>
    </ul>
</div>



    <?php $conn->close(); ?>
</body>
</html>

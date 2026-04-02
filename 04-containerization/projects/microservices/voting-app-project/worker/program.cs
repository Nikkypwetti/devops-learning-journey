using System;
using System.IO;
using System.Threading;
using StackExchange.Redis;
using Npgsql;

// 1. Handle Docker Secrets
string password = "postgres";
if (File.Exists("/run/secrets/db_password")) {
    password = File.ReadAllText("/run/secrets/db_password").Trim();
}

string connString = $"Host=db;Username=postgres;Password={password};Database=postgres;";

// 2. Connect to Redis
var redis = ConnectionMultiplexer.Connect("redis");
var queue = redis.GetDatabase();

Console.WriteLine("Worker successfully connected to Redis. Starting DB initialization...");

// 3. Robust Connection Loop (Retry Logic)
while (true) {
    try {
        using var conn = new NpgsqlConnection(connString);
        conn.Open();
        using var cmd = new NpgsqlCommand("CREATE TABLE IF NOT EXISTS votes (id SERIAL PRIMARY KEY, vote TEXT NOT NULL)", conn);
        cmd.ExecuteNonQuery();
        Console.WriteLine("Database table ensured. Ready for votes!");
        break; // Exit the retry loop once successful
    } catch (Exception ex) {
        Console.WriteLine($"Waiting for Database... ({ex.Message})");
        Thread.Sleep(5000); // Wait 5 seconds before retrying
    }
}

// 4. Main Processing Loop (Updated for Real-Time UI)
while (true) {
    try {
        var vote = queue.ListLeftPop("votes");
        if (!vote.IsNull) {
            string voteValue = vote.ToString();
            
            using var conn = new NpgsqlConnection(connString);
            conn.Open();

            // STEP A: Insert the vote into PostgreSQL
            using var cmdInsert = new NpgsqlCommand("INSERT INTO votes (vote) VALUES (@v)", conn);
            cmdInsert.Parameters.AddWithValue("v", voteValue);
            cmdInsert.ExecuteNonQuery();
            Console.WriteLine($"Vote Processed: {voteValue}");

            // STEP B: Get updated totals from the DB to send to the UI
            using var cmdCount = new NpgsqlCommand("SELECT vote, COUNT(*) FROM votes GROUP BY vote", conn);
            using var reader = cmdCount.ExecuteReader();
            
            var totals = new System.Collections.Generic.Dictionary<string, int> {
                { "Docker", 0 }, { "Kubernetes", 0 }
            };

            while (reader.Read()) {
                string v = reader.GetString(0);
                int count = (int)reader.GetInt64(1);
                if (totals.ContainsKey(v)) totals[v] = count;
            }

            // STEP C: Publish to 'results_channel' (This moves the bars!)
            string jsonPayload = System.Text.Json.JsonSerializer.Serialize(totals);
            redis.GetSubscriber().Publish("results_channel", jsonPayload);
            
            Console.WriteLine($"Broadcasted to UI: {jsonPayload}");
        }
    } catch (Exception ex) {
        Console.WriteLine($"Processing Error: {ex.Message}");
    }
    Thread.Sleep(500); // 0.5s polling rate
}
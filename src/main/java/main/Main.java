package main;

import java.sql.*;
import java.nio.file.*;
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        String url = "jdbc:postgresql://ep-sweet-wind-a1kbhay3-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require&channel_binding=require";
        String user = "neondb_owner";
        String password = "npg_gkO7Hf0ojtsD";

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            System.out.println("✅ Connected to Neon PostgreSQL DB!");

            // Read schema.sql from the schema folder
            String sql = new String(Files.readAllBytes(Paths.get("schema/schema.sql")));

            try (Statement stmt = conn.createStatement()) {
                stmt.execute(sql);
                System.out.println("✅ Schema executed successfully!");
            }

        } catch (SQLException | IOException e) {
            System.out.println("❌ Error:");
            e.printStackTrace();
        }
    }
}

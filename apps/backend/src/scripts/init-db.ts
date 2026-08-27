import fs from "fs";
import path from "path";
import dotenv from "dotenv";
import { pool } from "../config/database";

dotenv.config();

async function initDatabase() {
  console.log("Connecting to database and running schema initialization...");
  const sqlPath = path.resolve(__dirname, "../../../../database/sql/schema.sql");
  
  if (!fs.existsSync(sqlPath)) {
    throw new Error(`Schema file not found at ${sqlPath}`);
  }

  const sql = fs.readFileSync(sqlPath, "utf-8");

  const client = await pool.connect();
  try {
    console.log("Executing SQL schema...");
    await client.query(sql);
    console.log("Database schema initialized and seed data inserted successfully!");
  } catch (error) {
    console.error("Failed to initialize database:", error);
    process.exit(1);
  } finally {
    client.release();
    await pool.end();
  }
}

initDatabase();

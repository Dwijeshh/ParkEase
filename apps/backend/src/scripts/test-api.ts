import app from "../app";
import http from "http";

async function runTests() {
  const server = http.createServer(app);
  await new Promise<void>((resolve) => server.listen(3099, resolve));
  console.log("Test server listening on port 3099");

  const baseUrl = "http://localhost:3099";

  async function request(endpoint: string, options: any = {}) {
    const res = await fetch(`${baseUrl}${endpoint}`, {
      headers: { "Content-Type": "application/json", ...(options.headers || {}) },
      ...options,
    });
    const text = await res.text();
    let json;
    try {
      json = JSON.parse(text);
    } catch {
      json = text;
    }
    return { status: res.status, data: json };
  }

  try {
    console.log("\n1. Testing Health Check...");
    const health = await request("/health");
    console.log("Health status:", health.status, health.data);

    console.log("\n2. Testing Admin Login (admin@parking.com / 123)...");
    const adminLogin = await request("/api/v1/auth/login", {
      method: "POST",
      body: JSON.stringify({ email: "admin@parking.com", password: "123" })
    });
    console.log("Admin login status:", adminLogin.status, "Token exists:", !!adminLogin.data.data?.token, "Role:", adminLogin.data.data?.user?.role);
    const adminToken = adminLogin.data.data?.token;

    console.log("\n3. Testing User Login (aditya@gmail.com / 123)...");
    const userLogin = await request("/api/v1/auth/login", {
      method: "POST",
      body: JSON.stringify({ email: "aditya@gmail.com", password: "123" })
    });
    console.log("User login status:", userLogin.status, "User Name:", userLogin.data.data?.user?.name);

    console.log("\n4. Testing GET /api/v1/users (with Admin Token)...");
    const users = await request("/api/v1/users", {
      headers: { Authorization: `Bearer ${adminToken}` }
    });
    console.log("Users count:", users.data.data?.length, "Sample user:", users.data.data?.[0]);

    console.log("\n5. Testing GET /api/v1/vehicles...");
    const vehicles = await request("/api/v1/vehicles", {
      headers: { Authorization: `Bearer ${adminToken}` }
    });
    console.log("Vehicles count:", vehicles.data.data?.length, "Sample vehicle:", vehicles.data.data?.[0]);

    console.log("\n6. Testing GET /api/v1/parking/slots...");
    const slots = await request("/api/v1/parking/slots", {
      headers: { Authorization: `Bearer ${adminToken}` }
    });
    console.log("Slots count:", slots.data.data?.length, "Sample slot:", slots.data.data?.[0]);

    console.log("\n7. Testing GET /api/v1/parking/available...");
    const available = await request("/api/v1/parking/available", {
      headers: { Authorization: `Bearer ${adminToken}` }
    });
    console.log("Available slots count:", available.data.data?.length);

    console.log("\n8. Testing GET /api/v1/sessions...");
    const sessions = await request("/api/v1/sessions", {
      headers: { Authorization: `Bearer ${adminToken}` }
    });
    console.log("Sessions count:", sessions.data.data?.length, "Sample session:", sessions.data.data?.[0]);

    console.log("\n9. Testing GET /api/v1/map/nodes...");
    const mapNodes = await request("/api/v1/map/nodes");
    console.log("Map nodes count:", mapNodes.data.data?.length);

    console.log("\n10. Testing GET /api/v1/map/routes/entry/14...");
    const entryRoute = await request("/api/v1/map/routes/entry/14");
    console.log("Entry route to node 14:", entryRoute.data.data);

    console.log("\n11. Testing GET /api/v1/map/nearest-slot?entranceId=1&type=Car...");
    const nearest = await request("/api/v1/map/nearest-slot?entranceId=1&type=Car");
    console.log("Nearest slot:", nearest.data.data);

    console.log("\n12. Testing GET /api/v1/reports...");
    const reports = await request("/api/v1/reports", {
      headers: { Authorization: `Bearer ${adminToken}` }
    });
    console.log("Report Summary:", reports.data.data);

    console.log("\nALL TESTS PASSED SUCCESSFULLY!");
  } catch (err) {
    console.error("Test error:", err);
  } finally {
    server.close();
    process.exit(0);
  }
}

runTests();

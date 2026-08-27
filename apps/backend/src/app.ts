import express, { NextFunction, Request, Response } from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";

import authRoutes from "./modules/auth/auth.routes";
import userRoutes from "./modules/users/user.routes";
import vehicleRoutes from "./modules/vehicles/vehicle.routes";
import parkingRoutes from "./modules/parking/parking.routes";
import sessionRoutes from "./modules/sessions/session.routes";
import allocationRoutes from "./modules/allocations/allocation.routes";
import mapRoutes from "./modules/map/map.routes";
import reportRoutes from "./modules/reports/report.routes";

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
app.use(express.json());

// API Routes
app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/users", userRoutes);
app.use("/api/v1/vehicles", vehicleRoutes);
app.use("/api/v1/parking", parkingRoutes);
app.use("/api/v1/sessions", sessionRoutes);
app.use("/api/v1/allocations", allocationRoutes);
app.use("/api/v1/map", mapRoutes);
app.use("/api/v1/reports", reportRoutes);

// Health check
app.get("/health", (_req, res) => {
  res.json({ status: "ok", service: "parkease-backend" });
});

// 404 handler
app.use((_req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: {
      code: "ROUTE_NOT_FOUND",
      message: "The requested route does not exist"
    }
  });
});

// Global error handler
app.use((err: any, _req: Request, res: Response, _next: NextFunction) => {
  console.error("Unhandled server error:", err);
  res.status(err.status || 500).json({
    success: false,
    error: {
      code: err.code || "INTERNAL_SERVER_ERROR",
      message: err.message || "An unexpected error occurred"
    }
  });
});

export default app;

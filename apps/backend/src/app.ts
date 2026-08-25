import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import alertRoutes from "./modules/alerts/alert.routes";
import validationRoutes from "./modules/validation/validation.routes";
import authRoutes from "./modules/auth/auth.routes";
import parkingRoutes from "./modules/parking/parking.routes";

const app = express();
app.use("/api/v1/validation", validationRoutes);
app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
app.use(express.json());
app.use("/api/v1/alerts", alertRoutes);
app.use("/api/v1/auth", authRoutes);
app.use("/api/v1/parking", parkingRoutes);

app.get("/health", (_req, res) => {
  res.json({ status: "ok", service: "parkease-backend" });
});

export default app;

import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import alertRoutes from "./modules/alerts/alert.routes";

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
app.use(express.json());
app.use("/api/v1/alerts", alertRoutes);

app.get("/health", (_req, res) => {
  res.json({ status: "ok", service: "parkease-backend" });
});

export default app;
import { Router } from "express";
import { requireAuth } from "../../middleware/auth.middleware";
import {
  getDailyReport,
  getOccupancyReport,
  getReportSummary,
  getRevenueReport,
  getVehicleReport,
} from "./report.controller";

const router = Router();

router.get("/", requireAuth, getReportSummary);
router.get("/daily", requireAuth, getDailyReport);
router.get("/occupancy", requireAuth, getOccupancyReport);
router.get("/revenue", requireAuth, getRevenueReport);
router.get("/vehicles", requireAuth, getVehicleReport);

export default router;

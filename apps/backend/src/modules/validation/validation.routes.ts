import { Router, json } from "express";
import { validateVehicle } from "./vehicle-validation.controller";

const router = Router();

router.use(json());
router.post("/vehicle", validateVehicle);

export default router;
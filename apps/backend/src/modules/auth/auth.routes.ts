import { Router } from "express";
import { getCurrentUser, login, register } from "./auth.controller";
import { requireAuth } from "../../middleware/auth.middleware";

const router = Router();

router.post("/login", login);
router.post("/register", register);
router.get("/me", requireAuth, getCurrentUser);

export default router;

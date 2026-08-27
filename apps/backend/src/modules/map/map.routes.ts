import { Router } from "express";
import {
  getEntryRoute,
  getExitRoute,
  getMallDistances,
  getMapEdges,
  getMapNodes,
  getNearestSlot,
  precomputeMapRoutes,
} from "./map.controller";

const router = Router();

router.get("/nodes", getMapNodes);
router.get("/edges", getMapEdges);
router.get("/mall-distances", getMallDistances);
router.get("/routes/entry/:parkingNodeId", getEntryRoute);
router.get("/routes/exit/:parkingNodeId", getExitRoute);
router.get("/nearest-slot", getNearestSlot);
router.post("/precompute", precomputeMapRoutes);

export default router;

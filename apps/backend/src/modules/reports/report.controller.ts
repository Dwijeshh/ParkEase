import { Request, Response } from "express";
import { query } from "../../config/database";

export async function getReportSummary(_req: Request, res: Response) {
  try {
    const slotsRes = await query(`
      SELECT
        COUNT(*) AS total_slots,
        COUNT(*) FILTER (WHERE status = 'ENGAGED') AS occupied_slots,
        COUNT(*) FILTER (WHERE status = 'VACANT') AS available_slots,
        COUNT(*) FILTER (WHERE status = 'WAITING') AS reserved_slots
      FROM parking_slots
    `);

    const vehiclesRes = await query("SELECT COUNT(*) AS total_vehicles FROM vehicles");
    const revenueRes = await query("SELECT COALESCE(SUM(amount), 0) AS total_revenue FROM parking_sessions");

    const slotStats = slotsRes.rows[0];
    const totalSlots = Number(slotStats.total_slots) || 0;
    const occupiedSlots = Number(slotStats.occupied_slots) || 0;
    const availableSlots = Number(slotStats.available_slots) || 0;
    const reservedSlots = Number(slotStats.reserved_slots) || 0;
    const totalVehicles = Number(vehiclesRes.rows[0].total_vehicles) || 0;
    const revenue = Number(revenueRes.rows[0].total_revenue) || 0;
    const occupancy = totalSlots > 0 ? Number(((occupiedSlots / totalSlots) * 100).toFixed(2)) : 0;

    const data = {
      totalVehicles,
      totalSlots,
      occupiedSlots,
      availableSlots,
      reservedSlots,
      occupancy,
      revenue
    };

    return res.json({
      success: true,
      ...data,
      data
    });
  } catch (error) {
    console.error("Failed to fetch report summary:", error);
    return res.status(500).json({
      success: false,
      error: { code: "REPORT_FETCH_FAILED", message: "Failed to generate report" }
    });
  }
}

export async function getDailyReport(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        DATE(entry_time) AS date,
        COUNT(*) AS total_sessions,
        COALESCE(SUM(amount), 0) AS revenue,
        COALESCE(AVG(amount), 0) AS avg_revenue
      FROM parking_sessions
      GROUP BY DATE(entry_time)
      ORDER BY date DESC
      LIMIT 30
    `);

    const daily = result.rows.map(r => ({
      date: r.date,
      totalSessions: Number(r.total_sessions),
      revenue: Number(r.revenue),
      avgRevenue: Number(Number(r.avg_revenue).toFixed(2))
    }));

    return res.json({ success: true, data: daily });
  } catch (error) {
    console.error("Failed to fetch daily report:", error);
    return res.status(500).json({
      success: false,
      error: { code: "DAILY_REPORT_FAILED", message: "Failed to fetch daily report" }
    });
  }
}

export async function getOccupancyReport(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        slot_type,
        COUNT(*) AS total,
        COUNT(*) FILTER (WHERE status = 'ENGAGED') AS engaged,
        COUNT(*) FILTER (WHERE status = 'VACANT') AS vacant,
        COUNT(*) FILTER (WHERE status = 'WAITING') AS waiting
      FROM parking_slots
      GROUP BY slot_type
      ORDER BY slot_type ASC
    `);

    const breakdown = result.rows.map(r => {
      const total = Number(r.total);
      const engaged = Number(r.engaged);
      return {
        slotType: r.slot_type,
        total,
        engaged,
        vacant: Number(r.vacant),
        waiting: Number(r.waiting),
        occupancyRate: total > 0 ? Number(((engaged / total) * 100).toFixed(2)) : 0
      };
    });

    return res.json({ success: true, data: breakdown });
  } catch (error) {
    console.error("Failed to fetch occupancy report:", error);
    return res.status(500).json({
      success: false,
      error: { code: "OCCUPANCY_REPORT_FAILED", message: "Failed to fetch occupancy report" }
    });
  }
}

export async function getRevenueReport(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        COUNT(*) AS total_sessions,
        COALESCE(SUM(amount), 0) AS total_revenue,
        COALESCE(AVG(amount), 0) AS average_amount,
        COALESCE(MIN(amount), 0) AS min_amount,
        COALESCE(MAX(amount), 0) AS max_amount
      FROM parking_sessions
    `);

    const stats = result.rows[0];
    return res.json({
      success: true,
      data: {
        totalSessions: Number(stats.total_sessions),
        totalRevenue: Number(stats.total_revenue),
        averageAmount: Number(Number(stats.average_amount).toFixed(2)),
        minAmount: Number(stats.min_amount),
        maxAmount: Number(stats.max_amount)
      }
    });
  } catch (error) {
    console.error("Failed to fetch revenue report:", error);
    return res.status(500).json({
      success: false,
      error: { code: "REVENUE_REPORT_FAILED", message: "Failed to fetch revenue report" }
    });
  }
}

export async function getVehicleReport(_req: Request, res: Response) {
  try {
    const result = await query(`
      SELECT
        v.vehicle_type,
        COUNT(*) AS total,
        COUNT(*) FILTER (WHERE a.status = 'ACTIVE') AS parked,
        COUNT(*) FILTER (WHERE a.status IS NULL OR a.status != 'ACTIVE') AS outside
      FROM vehicles v
      LEFT JOIN parking_allocations a ON v.vehicle_id = a.vehicle_id AND a.status = 'ACTIVE'
      GROUP BY v.vehicle_type
    `);

    const stats = result.rows.map(r => ({
      vehicleType: r.vehicle_type,
      total: Number(r.total),
      parked: Number(r.parked),
      outside: Number(r.outside)
    }));

    return res.json({ success: true, data: stats });
  } catch (error) {
    console.error("Failed to fetch vehicle report:", error);
    return res.status(500).json({
      success: false,
      error: { code: "VEHICLE_REPORT_FAILED", message: "Failed to fetch vehicle report" }
    });
  }
}
